#!/bin/bash
# Codzienna aktualizacja cen kin studyjnych (launchd: pl.sajgonara.kina-update).
# Rotacyjnie weryfikuje ~12 kin dziennie (pełny cykl ~8 dni) przez claude -p,
# commituje i pushuje jako sajgonara bez zmiany aktywnego konta gh.
set -euo pipefail
REPO="$HOME/Desktop/SZYMON/PROJEKTY/kina-studyjne"
LOG="$REPO/update.log"
cd "$REPO"
exec >>"$LOG" 2>&1
echo "=== $(date '+%F %T') start ==="

DAY=$(date +%j)
BATCH=$(( (10#$DAY) % 8 ))

CLAUDE_CONFIG_DIR="$HOME/.claude-spectrum" /opt/homebrew/bin/claude -p \
  --dangerously-skip-permissions \
  "Jesteś w repo mapy kin studyjnych ($REPO). W pliku data.js jest tablica KINA (~99 kin, posortowana po city). Podziel listę na 8 równych partii; dziś aktualizujesz partię nr $BATCH (licząc od 0). Dla każdego kina z tej partii sprawdź przez WebFetch/WebSearch aktualne ceny na stronie kina (website/repertuarUrl): priceNormal, priceDiscount, priceMin, priceNote, showsPerDay. Zaktualizuj TYLKO zmienione wartości w data.js (zachowaj format JSON, polskie znaki, nie ruszaj innych partii). Jeśli cena z oficjalnej strony — verified:true. Na końcu zaktualizuj/dodaj w data.js linię 'const KINA_UPDATED = \"YYYY-MM-DD\";' z dzisiejszą datą. Nie commituj — tylko edytuj plik. Jeśli strona kina nie działa, zostaw stare dane. Max 2 próby na kino." \
  --max-turns 80 || echo "claude exited $?"

if ! git diff --quiet data.js 2>/dev/null; then
  # skan sekretów w diffie przed commitem
  if git diff data.js | grep -qiE "ghp_|gho_|github_pat_|xox[cbd]-|BEGIN .* KEY|AIza"; then
    echo "SECRET PATTERN IN DIFF — abort"; exit 1
  fi
  git add data.js
  git commit -m "Auto-aktualizacja cen (partia $BATCH, $(date +%F))

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
  env -u GITHUB_TOKEN git \
    -c credential.helper= \
    -c "credential.helper=!f(){ echo username=sajgonara; echo password=\$(env -u GITHUB_TOKEN gh auth token --user sajgonara); };f" \
    push origin main
  echo "pushed"
else
  echo "no changes"
fi
echo "=== $(date '+%F %T') done ==="
