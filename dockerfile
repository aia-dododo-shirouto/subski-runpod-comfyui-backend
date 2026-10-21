# Dockerfile
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ComfyUI

# 再現性のため、検証が固まったらコミットハッシュを指定する
ARG COMFY_REF=master
RUN git clone https://github.com/comfyanonymous/ComfyUI.git . && git checkout ${COMFY_REF}

# torchは先に公式CUDAビルドで入れる（requirements.txtが汎用版を入れないように）
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
RUN pip install -r requirements.txt

EXPOSE 8188
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]