#!/bin/bash
# 같은 영구 URL로 최신 빌드 재배포 — https://gojaehack.github.io/tycoon-webgl/
set -e
SRC=/Users/gojaehack/Desktop/BuildGame/_webgl_build/UnityProject/Build/WebGL
DST=/Users/gojaehack/Desktop/BuildGame/_webgl_pages
rsync -a --delete --exclude '.git/' --exclude '.nojekyll' --exclude 'README.md' --exclude 'redeploy.sh' "$SRC"/ "$DST"/
cd "$DST"
touch .nojekyll
# 캐시 무력화: Build 리소스는 파일명이 고정(WebGL.*.unityweb)이라, 쿼리를 안 붙이면 브라우저가
# 옛 빌드를 그대로 캐시에서 쓴다(회장 실기기 "구빌드가 보임"의 원인). 매 배포마다 게임 저장소
# 짧은 HEAD 를 ?v= 로 붙여 강제 재요청시킨다. 기존 ?v= 는 먼저 걷어내 멱등.
VER=$(git -C /Users/gojaehack/Desktop/BuildGame/Tycoon rev-parse --short HEAD 2>/dev/null || date +%s)
perl -0pi -e 's/(WebGL\.(?:loader\.js|data\.unityweb|framework\.js\.unityweb|wasm\.unityweb))\?v=[^"?]*/$1/g; s/(WebGL\.(?:loader\.js|data\.unityweb|framework\.js\.unityweb|wasm\.unityweb))(")/$1?v='"$VER"'$2/g' index.html
echo "cache-bust v=$VER"
git add -A
git -c user.email=gojaehack@gmail.com -c user.name=gojaehack commit -q -m "WebGL build redeploy $(git -C /Users/gojaehack/Desktop/BuildGame/Tycoon rev-parse --short HEAD 2>/dev/null)" || echo "no change"
git push -q origin main
echo "redeployed -> https://gojaehack.github.io/tycoon-webgl/"
