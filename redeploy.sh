#!/bin/bash
# 같은 영구 URL로 최신 빌드 재배포 — https://gojaehack.github.io/tycoon-webgl/
set -e
SRC=/Users/gojaehack/Desktop/BuildGame/_webgl_build/UnityProject/Build/WebGL
DST=/Users/gojaehack/Desktop/BuildGame/_webgl_pages
rsync -a --delete --exclude '.git/' --exclude '.nojekyll' --exclude 'README.md' --exclude 'redeploy.sh' "$SRC"/ "$DST"/
cd "$DST"
touch .nojekyll
git add -A
git -c user.email=gojaehack@gmail.com -c user.name=gojaehack commit -q -m "WebGL build redeploy $(git -C /Users/gojaehack/Desktop/BuildGame/Tycoon rev-parse --short HEAD 2>/dev/null)" || echo "no change"
git push -q origin main
echo "redeployed -> https://gojaehack.github.io/tycoon-webgl/"
