# Project Summary for Gemini

## Project Goal
하나의 도메인(예: `Lee-GyeongMin95.github.io/react-portfolio`) 아래에 여러 React 애플리케이션을 폴더별로 나누어 배포하고 관리합니다. (예: `/lotto-generator`, `/project2` 등)

## Current Status (2025년 7월 29일)
현재 `react-portfolio` 프로젝트는 메인 페이지와 하나의 서브 프로젝트(`lotto-generator`)를 포함하고 있습니다.

### Directory Structure
```
react-portfolio/
├── home-page/             # 메인 페이지의 빌드 결과물 (배포용)
├── home-page-source/      # 메인 페이지의 원본 소스 코드
├── lotto-generator/       # 로또 생성기 프로젝트의 원본 소스 코드
├── deploy-all.sh          # 모든 프로젝트를 빌드하고 배포하는 스크립트
└── GEMINI.md              # 이 문서
```

### Completed Tasks
1.  **메인 페이지 (`home-page`) 설정:**
    *   `home-page-source` 프로젝트의 `package.json` 내 `homepage` 값을 `.`으로 변경하여 상대 경로 배포에 적합하도록 설정했습니다.
    *   `home-page-source` 프로젝트를 빌드하여 `react-portfolio/home-page` 경로에 빌드 결과물을 배치했습니다.
    *   `home-page-source`에 `react-router-dom` 라이브러리를 설치하고, `src/App.js`를 수정하여 라우팅(`BrowserRouter`, `Routes`, `Route`, `Link`)을 설정했습니다. 메인 페이지에서 `/lotto-generator` 경로로 이동하는 링크를 `<Link>` 컴포넌트로 변경했습니다.

2.  **로또 생성기 (`lotto-generator`) 설정:**
    *   `lotto-generator` 프로젝트를 `react-portfolio/home-page-source` 내부에서 `react-portfolio/` 루트 디렉터리 아래로 이동시켰습니다.
    *   `lotto-generator/src/App.js` 파일에서 정의되지 않은 `GlobalHeader` 컴포넌트 참조를 제거하여 빌드 오류를 해결했습니다.
    *   `lotto-generator` 프로젝트의 `package.json` 내 `homepage` 값은 이미 `https://Lee-GyeongMin95.github.io/react-portfolio/lotto-generator`로 올바르게 설정되어 있었습니다.

3.  **배포 스크립트 (`deploy-all.sh`) 개선:**
    *   `deploy-all.sh` 스크립트를 수정하여 `home-page-source`를 먼저 빌드하고 `dist` 폴더의 루트에 배치하도록 했습니다.
    *   이후 `PROJECTS` 배열에 정의된 서브 프로젝트들(현재 `lotto-generator`)을 빌드하여 `dist` 폴더 내의 해당 프로젝트 이름으로 된 하위 폴더에 배치하도록 했습니다.
    *   `gh-pages` 명령어 실행 시 `gh-pages: command not found` 오류를 해결하기 위해 `npx gh-pages -d dist`로 변경했습니다.

## Next Steps

### Immediate Next Step (Git Repository Setup)
현재 `react-portfolio` 디렉터리는 Git 리포지토리로 초기화되지 않았습니다. GitHub Pages에 배포하려면 다음 Git 명령어를 실행해야 합니다:
1.  `git init`
2.  `git add .
3.  `git commit -m "Initial commit"`
4.  `git remote add origin <YOUR_GITHUB_REPOSITORY_URL>` (예: `https://github.com/Lee-GyeongMin95/react-portfolio.git`)
5.  `git push -u origin master` (또는 `main` 브랜치)

### Future Steps (Deployment)
모든 12개 프로젝트가 생성되고 `react-portfolio` 디렉터리 내에 적절히 배치된 후, `deploy-all.sh` 스크립트를 실행하여 GitHub Pages에 최종 배포를 진행할 예정입니다.

### Future Steps (Project Integration)
`home-page-source/src/App.js`에 임시로 정의된 `LottoGenerator` 컴포넌트를 실제 `lotto-generator` 프로젝트와 통합하는 방법을 결정해야 합니다. 이는 `lotto-generator` 프로젝트를 `home-page` 내부에 직접 포함시키거나, `iframe`을 사용하거나, 또는 API 호출을 통해 데이터를 가져오는 방식 등이 될 수 있습니다. 현재는 라우팅 테스트를 위한 임시 컴포넌트입니다.
