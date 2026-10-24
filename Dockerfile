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

# Network Volume（/runpod-volume）上のモデルを参照する設定
# ComfyUIはルート直下の extra_model_paths.yaml を起動時に自動で読み込む
COPY extra_model_paths.yaml /ComfyUI/extra_model_paths.yaml

EXPOSE 8188

# output / input / user を Network Volume に置き、ワーカー停止後も残す
CMD ["python", "main.py", \
     "--listen", "0.0.0.0", \
     "--port", "8188", \
     "--output-directory", "/runpod-volume/ComfyUI/output", \
     "--input-directory", "/runpod-volume/ComfyUI/input", \
     "--user-directory", "/runpod-volume/ComfyUI/user"]
