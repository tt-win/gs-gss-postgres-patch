#!/usr/bin/env bash
set -euo pipefail

DOCKER="${DOCKER:-/usr/local/bin/docker}"
TEST_DB="${TEST_DB:-gs_gss_patch_test}"
PG_CONTAINER="${PG_CONTAINER:-rgs-studio-server-21-postgres-1}"
PATCH_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Full upgrade chain, in release order. A brownfield DB applies these one after another, so
# validation must too (not just the v1.0.0 baseline) to catch cross-release regressions.
RELEASES=(
  v1.0.0-TP-0000.lst
  v1.0.1-TP-5315.lst
  v1.0.1-TP-5315-2.lst
  v1.0.1-TP-5315-3.lst
  v1.0.1-TP-5315-4.lst
  v1.0.1-TP-5315-5.lst
  v1.0.1-TP-5315-6.lst
  v1.0.1-TP-5315-7.lst
  v1.0.1-TP-5315-8.lst
  v1.0.1-TP-5315-9.lst
  v1.0.1-TP-5315-10.lst
  v1.0.1-TP-5315-11.lst
  v1.0.1-TP-5315-12.lst
  v1.0.1-TP-5315-13.lst
  v1.0.1-TP-5315-14.lst
)

run_psql() {
  local db=$1
  shift
  $DOCKER exec -i "$PG_CONTAINER" psql -U postgres -d "$db" -v ON_ERROR_STOP=1 "$@"
}

find_script() {
  local name=$1
  local path
  path=$(find "$PATCH_ROOT/scripts" -name "$name" -print -quit)
  if [[ -z "$path" || ! -f "$path" ]]; then
    echo "error: cannot find script: $name" >&2
    exit 1
  fi
  printf '%s' "$path"
}

cleanup() {
  $DOCKER exec "$PG_CONTAINER" psql -U postgres -d postgres -c "DROP DATABASE IF EXISTS $TEST_DB;" >/dev/null 2>&1 || true
}
trap cleanup EXIT

cleanup
$DOCKER exec "$PG_CONTAINER" psql -U postgres -d postgres -c "CREATE DATABASE $TEST_DB OWNER postgres;"

for release in "${RELEASES[@]}"; do
  lst="${PATCH_ROOT}/release/${release}"
  echo "==> Running ${lst} against ${TEST_DB}..."
  while IFS= read -r f; do
    [[ -z "$f" || "$f" =~ ^# ]] && continue
    path=$(find_script "$f")
    echo "  -> $f"
    run_psql "$TEST_DB" < "$path"
  done < "$lst"
done

echo "==> Tables:"
run_psql "$TEST_DB" -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'gs_gss' AND table_type = 'BASE TABLE' ORDER BY 1;"

echo "==> Seed row counts:"
run_psql "$TEST_DB" <<'SQL'
SET search_path TO gs_gss, public;
SELECT 'currency_codes' AS table_name, count(*) FROM currency_codes
UNION ALL SELECT 'currencies', count(*) FROM currencies
UNION ALL SELECT 'menus', count(*) FROM menus
UNION ALL SELECT 'permissions', count(*) FROM permissions
UNION ALL SELECT 'roles', count(*) FROM roles
UNION ALL SELECT 'users', count(*) FROM users
UNION ALL SELECT 'platforms', count(*) FROM platforms
UNION ALL SELECT 'games', count(*) FROM games
UNION ALL SELECT 'platform_games', count(*) FROM platform_games
UNION ALL SELECT 'gs_version', count(*) FROM gs_version
ORDER BY 1;
SQL

echo "==> gs_version:"
run_psql "$TEST_DB" -c "SET search_path TO gs_gss, public; SELECT version, description FROM gs_version;"

echo "==> PASS: release manifest applied successfully."
