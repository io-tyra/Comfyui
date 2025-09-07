# Base image for RunPod with ComfyUI
FROM docker.io/runpod/worker-comfyui:5.4.1-base

# Set the working directory
WORKDIR /app/ComfyUI

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    fonts-dejavu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable to prevent git from prompting for credentials
ENV GIT_TERMINAL_PROMPT=0

# Switch to the custom_nodes directory
WORKDIR /app/ComfyUI/custom_nodes

# Clone required custom nodes repositories individually for better error handling and caching
RUN git clone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
RUN git clone https://github.com/yolain/comfyui_yvann_nodes.git
RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
RUN git clone https://github.com/FizzleDorf/ComfyUI_FizzNodes.git
RUN git clone https://github.com/rgthree/rgthree-comfy.git
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
RUN git clone https://github.com/Kijai/ComfyUI-KJNodes.git
RUN git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui.git
RUN git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git

# Install Python dependencies for the custom nodes
RUN pip install -r ComfyUI-Impact-Pack/requirements.txt && \
    pip install -r was-node-suite-comfyui/requirements.txt

# Return to the main ComfyUI directory
WORKDIR /app/ComfyUI

# Create directories and download models and audio file

# Input Audio File
RUN mkdir -p /app/ComfyUI/input && \
    wget -O /app/ComfyUI/input/"Eye On The Road.wav" "https://huggingface.co/datasets/x0io0x/EOR/resolve/main/Eye%20On%20The%20Road.wav"

# Checkpoints
RUN mkdir -p /app/ComfyUI/models/checkpoints/SD15 && \
    wget -O /app/ComfyUI/models/checkpoints/SD15/model1.safetensors "https://civitai.com/api/download/models/503725?type=Model&format=SafeTensor&size=pruned&fp=fp16" && \
    wget -O /app/ComfyUI/models/checkpoints/SD15/model2.safetensors "https://civitai.com/api/download/models/237459?type=Model&format=SafeTensor&size=pruned&fp=fp16" && \
    wget -O /app/ComfyUI/models/checkpoints/SD15/model3.safetensors "https://civitai.com/api/download/models/173821?type=Model&format=SafeTensor&size=pruned&fp=fp16"

# LoRAs
RUN mkdir -p /app/ComfyUI/models/loras/SD15 && \
    wget -O /app/ComfyUI/models/loras/SD15/lora1.safetensors "https://civitai.com/api/download/models/175276?type=Model&format=SafeTensor" && \
    wget -O /app/ComfyUI/models/loras/SD15/lora2.safetensors "https://civitai.com/api/download/models/87153?type=Model&format=SafeTensor" && \
    wget -O /app/ComfyUI/models/loras/SD15/lora3.safetensors "https://civitai.com/api/download/models/87191?type=Model&format=SafeTensor" && \
    wget -O /app/ComfyUI/models/loras/SD15/v3_sd15_adapter.ckpt "https://huggingface.co/guoyww/animatediff/resolve/main/v3_sd15_adapter.ckpt" && \
    wget -O /app/ComfyUI/models/loras/SD15/lora4.safetensors "https://civitai.com/api/download/models/571916?type=Model&format=SafeTensor" && \
    wget -O /app/ComfyUI/models/loras/SD15/emma15.safetensors "https://huggingface.co/datasets/x0io0x/EOR/resolve/main/emma15.safetensors" && \
    wget -O /app/ComfyUI/models/loras/SD15/tyrana20.safetensors "https://huggingface.co/datasets/x0io0x/EOR/resolve/main/tyrana20.safetensors"

# AnimateDiff Motion Model
RUN mkdir -p /app/ComfyUI/models/animatediff_models && \
    wget -O /app/ComfyUI/models/animatediff_models/mm_sd_v15_v2.ckpt "https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt"

# Motion LoRA
RUN mkdir -p /app/ComfyUI/models/motion_lora && \
    wget -O /app/ComfyUI/models/motion_lora/v2_lora_ZoomIn.ckpt "https://huggingface.co/guoyww/animatediff/resolve/main/v2_lora_ZoomIn.ckpt" && \
    wget -O /app/ComfyUI/models/motion_lora/motion_lora1.safetensors "https://civitai.com/api/download/models/529725?type=Model&format=SafeTensor" && \
    wget -O /app/ComfyUI/models/motion_lora/motion_lora2.safetensors "https://civitai.com/api/download/models/671139?type=Model&format=SafeTensor"

# RIFE Models for Frame Interpolation
RUN mkdir -p /app/ComfyUI/models/rife && \
    wget -O /app/ComfyUI/models/rife/rife47.pth "https://huggingface.co/hithereai/rife-v4.7/resolve/main/rife47.pth"
