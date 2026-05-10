#!/usr/bin/env bash
#
# capture-screenshots.sh — Play Store 用スクリーンショットを Android emulator で撮る。
#
# 使い方:
#   scripts/capture-screenshots.sh [device_id]
#
#   device_id 省略時は `flutter devices` の最初の Android emulator を使う。
#
# 出力: ./screenshots/*.png
#
# 前提:
#   - Android emulator が起動済み（推奨: Pixel 7 / 1080x2400）
#   - fvm が入っているなら fvm 経由で実行（無ければ素の flutter）

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

color() { printf "\033[%sm%s\033[0m" "$1" "$2"; }
info()  { echo "$(color 36 ℹ) $*"; }
ok()    { echo "$(color 32 ✓) $*"; }
err()   { echo "$(color 31 ✗) $*" >&2; }
die()   { err "$*"; exit 1; }

# fvm 優先
if command -v fvm >/dev/null && [[ -f .fvmrc ]]; then
  FLUTTER="fvm flutter"
else
  FLUTTER="flutter"
fi

DEVICE="${1:-}"
if [[ -z "$DEVICE" ]]; then
  DEVICE=$($FLUTTER devices --machine 2>/dev/null \
    | python3 -c "import json,sys; ds=json.load(sys.stdin); print(next((d['id'] for d in ds if d.get('platformType')=='android' and 'emulator' in d.get('id','')), ''))")
  [[ -n "$DEVICE" ]] || die "Android emulator が見つかりません。'flutter emulators --launch <id>' で起動してから再実行してください。"
  info "device 自動検出: $DEVICE"
fi

info "古い screenshots/ をクリア"
rm -rf screenshots
mkdir -p screenshots

info "integration_test を実行（数分かかります）"
$FLUTTER drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshots_test.dart \
  --device-id="$DEVICE" \
  --profile

if compgen -G "screenshots/*.png" > /dev/null; then
  ok "撮影完了:"
  ls -la screenshots/*.png
else
  die "screenshots/*.png が生成されませんでした"
fi

# Play Store Phone screenshot 要件チェック
# 仕様: 最小辺 1080px 以上 / 最大辺 3840px 以下 / 比率 1:2 〜 2:1
info "Play Store Phone 要件チェック（最小辺 1080px / 比率 1:2〜2:1）"
WARN_COUNT=0
for png in screenshots/*.png; do
  if command -v sips >/dev/null; then
    W=$(sips -g pixelWidth "$png" 2>/dev/null | awk '/pixelWidth/ {print $2}')
    H=$(sips -g pixelHeight "$png" 2>/dev/null | awk '/pixelHeight/ {print $2}')
  elif command -v identify >/dev/null; then
    read W H < <(identify -format "%w %h" "$png")
  else
    W=""; H=""
  fi
  if [[ -z "$W" || -z "$H" ]]; then
    continue
  fi
  MIN=$(( W < H ? W : H ))
  MAX=$(( W > H ? W : H ))
  STATUS="✓"
  if (( MIN < 1080 )); then STATUS="⚠ 最小辺 < 1080px"; WARN_COUNT=$((WARN_COUNT+1)); fi
  if (( MAX > 3840 )); then STATUS="⚠ 最大辺 > 3840px"; WARN_COUNT=$((WARN_COUNT+1)); fi
  # 比率: max/min が 2.0 を超えると Play Store NG
  RATIO_X10=$(( MAX * 10 / MIN ))
  if (( RATIO_X10 > 20 )); then STATUS="⚠ 比率 > 2:1"; WARN_COUNT=$((WARN_COUNT+1)); fi
  printf "  %s  %s  %sx%s\n" "$STATUS" "$png" "$W" "$H"
done
if (( WARN_COUNT > 0 )); then
  echo "$(color 33 ⚠) $WARN_COUNT 枚が Play Store の要件外。emulator サイズを見直してください。"
fi

cat <<DONE

$(color 32 "===== 完了 =====")

📁 出力先: $(pwd)/screenshots/

Play Console アップロード手順:
  1. Play Console → アプリ → ストアの掲載情報 → グラフィック
  2. 「電話」セクションに 01〜04 をドラッグ&ドロップ
  3. 必須は 2 枚以上、推奨は 4〜8 枚

UI を変更したら、このスクリプトを再実行するだけで全部撮り直せます。

DONE
