#!/bin/bash

# --- 초기화 ---
echo "이전 빌드 파일을 삭제합니다..."
rm -rf dist
mkdir dist

# --- 1. 메인 페이지 (home-page) 빌드 ---
# home-page는 웹사이트의 루트(/)가 됩니다.
echo "--------------------------------------------------"
echo "메인 페이지(home-page)를 빌드합니다."
echo "--------------------------------------------------"

# 소스 코드가 있는 home-page-source 디렉터리로 이동합니다.
cd home-page-source

echo "메인 페이지의 의존성을 설치합니다..."
npm install

echo "메인 페이지 빌드를 실행합니다..."
# package.json의 homepage 값이 "."으로 설정되어 있어야 합니다.
npm run build

# 빌드된 파일들을 dist 폴더의 루트로 복사합니다.
if [ -d "build" ]; then
  echo "빌드된 메인 페이지 파일을 dist 폴더로 옮깁니다..."
  # build 폴더의 '모든 내용'을 dist 폴더로 복사합니다.
  cp -a build/. ../dist/
else
  echo "오류: 메인 페이지의 build 디렉터리를 찾을 수 없습니다. 중단합니다."
  exit 1
fi

# 상위 디렉터리로 복귀합니다.
cd ..

# --- 2. 개별 서브 프로젝트들 빌드 ---
# 여기에 배포할 다른 프로젝트 폴더 이름을 추가하세요. (예: PROJECTS=("lotto-generator" "my-app2"))
PROJECTS=("lotto-generator")

for project_name in "${PROJECTS[@]}"; do
  # 해당 프로젝트 디렉터리가 존재하는지 확인합니다.
  if [ -d "$project_name" ]; then
    echo "--------------------------------------------------"
    echo "서브 프로젝트($project_name)를 빌드합니다."
    echo "--------------------------------------------------"

    cd $project_name

    echo "($project_name)의 의존성을 설치합니다..."
    npm install

    echo "($project_name) 빌드를 실행합니다..."
    # 중요: 각 서브 프로젝트의 package.json homepage 값은 "/프로젝트이름" 형식으로 미리 설정되어 있어야 합니다.
    # 예: lotto-generator의 homepage는 "/lotto-generator"가 되어야 합니다.
    npm run build

    # 빌드 결과물(build 폴더)을 dist 폴더 아래에 프로젝트 이름으로 된 폴더로 이동합니다.
    if [ -d "build" ]; then
      echo "빌드된 ($project_name) 파일을 dist/$project_name 폴더로 옮깁니다..."
      mv build ../dist/$project_name
    else
      echo "오류: ($project_name)의 build 디렉터리를 찾을 수 없습니다."
    fi

    cd ..
  else
    echo "경고: '$project_name' 디렉터리를 찾을 수 없어 건너뜁니다."
  fi
done

# --- 3. 최종 배포 ---
echo "--------------------------------------------------"
echo "모든 프로젝트 빌드가 완료되었습니다."
echo "GitHub Pages로 배포를 시작합니다..."
echo "--------------------------------------------------"

# 'dist' 폴더의 내용을 gh-pages 브랜치로 배포합니다.
npx gh-pages -d dist

echo "--------------------------------------------------"
echo "배포가 완료되었습니다!"
echo "--------------------------------------------------"
