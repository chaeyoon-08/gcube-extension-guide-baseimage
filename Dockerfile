FROM nvcr.io/nvidia/cuda:12.8.0-cudnn-devel-ubuntu22.04

# apt 패키지 설치
COPY packages.txt .
RUN apt-get update && xargs apt-get install -y < packages.txt \
    && rm -rf /var/lib/apt/lists/*

# PyTorch 설치 (CUDA 12.8)
RUN pip install torch==2.7.0 torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu128

# pip 패키지 설치
COPY requirements.txt .
RUN pip install -r requirements.txt

# 작업 디렉토리 설정
WORKDIR /workspace

# entrypoint 스크립트 복사 및 실행 권한 부여
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]