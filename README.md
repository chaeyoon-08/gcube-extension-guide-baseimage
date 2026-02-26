# gcube Base Image

gcube 워크로드에서 사용하는 공식 베이스 이미지입니다.

## 기반 이미지

[pytorch/pytorch:2.7.0-cuda12.8-cudnn9-devel](https://hub.docker.com/r/pytorch/pytorch)

| 항목 | 버전 |
|------|------|
| PyTorch | 2.7.0 |
| CUDA | 12.8 |
| cuDNN | 9 |
| Python | 3.11 |

RTX 40 시리즈(Ada Lovelace, sm_89)와 RTX 50 시리즈(Blackwell, sm_120)를 모두 지원합니다.

## 포함 패키지

**apt**
- git, curl, wget, zstd

**pip**
- 기본 설치 없음 (requirements.txt에 추가)

## 디렉터리 구조

```
.
├── .github/
│   └── workflows/
│       └── docker-publish.yml   # GHCR 자동 빌드 및 배포
├── Dockerfile
├── entrypoint.sh                # 컨테이너 시작 스크립트
├── packages.txt                 # apt 패키지 목록
└── requirements.txt             # pip 패키지 목록
```

## 필수 환경변수

gcube 워크로드 배포 시 아래 환경변수를 반드시 설정해야 합니다.
누락 시 컨테이너가 즉시 종료됩니다.

| 환경변수 | 설명 |
|----------|------|
| `GIT_USER_NAME` | GitHub 사용자 이름 (e.g. `chaeyoon-08`) |
| `GIT_USER_EMAIL` | GitHub 이메일 |
| `GIT_TOKEN` | GitHub Personal Access Token (PAT) |

### GitHub PAT 발급 방법

1. GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. **Generate new token** 클릭
3. `repo` 권한 체크 후 발급
4. 발급된 토큰을 `GIT_TOKEN` 환경변수에 설정

## entrypoint 동작

컨테이너 시작 시 아래 순서로 자동 실행됩니다.

1. 필수 환경변수 검증 (누락 시 `exit 1`)
2. `/workspace` git 초기화
3. git 사용자 설정 (`user.name`, `user.email`)
4. GitHub 인증 설정 (PAT 기반, `~/.git-credentials`)
5. 커맨드가 있으면 백그라운드 실행
6. 컨테이너 상시 유지 (`tail -f /dev/null`)

인증 설정 완료 후 터미널에서 토큰 입력 없이 바로 `git clone`이 가능합니다.

## 이미지 사용

```
ghcr.io/{organization}/gcube-baseimage-pytorch:latest
```

## 빌드 및 배포

`main` 브랜치에 push하면 GitHub Actions가 자동으로 이미지를 빌드하여 GHCR에 push합니다.