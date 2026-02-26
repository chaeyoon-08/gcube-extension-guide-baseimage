#!/bin/bash

echo "================================================"
echo "  gcube Base Image Entrypoint"
echo "================================================"

# Git 초기화 및 사용자 설정
echo "[1/2] Git 초기화 중..."
git init /workspace
echo "✅ git init 완료"

echo "[2/2] Git 사용자 설정 중..."

# 환경변수가 제공된 경우에만 git config 설정
if [ -n "$GIT_USER_NAME" ]; then
    git config --global user.name "$GIT_USER_NAME"
    echo "✅ user.name 설정 완료: $GIT_USER_NAME"
else
    echo "⚠️  GIT_USER_NAME 환경변수가 설정되지 않았습니다."
fi

if [ -n "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
    echo "✅ user.email 설정 완료: $GIT_USER_EMAIL"
else
    echo "⚠️  GIT_USER_EMAIL 환경변수가 설정되지 않았습니다."
fi

echo "================================================"
echo "  설정 완료! 컨테이너를 시작합니다."
echo "================================================"

# 이후 커맨드 실행 (gcube에서 전달된 컨테이너 명령 실행)
exec "$@"

# 명령이 없을 경우 컨테이너 유지
if [ $# -eq 0 ]; then
    tail -f /dev/null
fi