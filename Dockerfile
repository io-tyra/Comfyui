# Base image for RunPod with ComfyUI
FROM docker.io/runpod/worker-comfyui:5.4.1-base

# Set the main working directory
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

# Clone all required custom nodes repositories, specifying the full destination path
RUN git clone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git /app/ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved
RUN git clone https://github.com/yvann-ba/ComfyUI_Yvann-Nodes.git /app/ComfyUI/custom_nodes/ComfyUI_Yvann-Nodes
RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git /app/ComfyUI/custom_nodes/ComfyUI-VideoHelperSuite
RUN git clone https://github.com/FizzleDorf/ComfyUI_FizzNodes.git /app/ComfyUI/custom_nodes/ComfyUI_FizzNodes
RUN git clone https://github.com/rgthree/rgthree-comfy.git /app/ComfyUI/custom_nodes/rgthree-comfy
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git /app/ComfyUI/custom_nodes/ComfyUI-Impact-Pack
RUN git clone https://github.com/Kijai/ComfyUI-KJNodes.git /app/ComfyUI/custom_nodes/ComfyUI-KJNodes
RUN git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git /app/ComfyUI/custom_nodes/ComfyUI-Frame-Interpolation
RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui.git /app/ComfyUI/custom_nodes/was-node-suite-comfyui
RUN git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git /app/ComfyUI/custom_nodes/ComfyUI-Custom-Scripts

# Install ALL Python dependencies from the custom nodes that require them
RUN pip install -r /app/ComfyUI/custom_nodes/ComfyUI-Impact-Pack/requirements.txt && \
    pip install -r /app/ComfyUI/custom_nodes/was-node-suite-comfyui/requirements.txt && \
    pip install -r /app/ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved/requirements.txt && \
    pip install -r /app/ComfyUI/custom_nodes/ComfyUI_Yvann-Nodes/requirements.txt

# --- Download all models and files ---

# Input Audio File
RUN mkdir -p /app/ComfyUI/input && \
    curl -L -o /app/ComfyUI/input/"Eye On The Road.wav" "https://huggingface.co/datasets/x0io0x/EOR/resolve/main/Eye%20On%20The%20Road.wav"

# Checkpoints
RUN mkdir -p /app/ComfyUI/models/checkpoints/SD15 && \
    curl -L -o /app/ComfyUI/models/checkpoints/SD15/mixCyber_noEma.safetensors "https://civitai.com/api/download/models/173821?type=Model&format=SafeTensor&size=pruned&fp=fp16"

# LoRAs
RUN mkdir -p /app/ComfyUI/models/loras/SD15 && \
    curl -L -o /app/ComfyUI/models/loras/SD15/CyberpunkWorld.safetensors "https://civitai.com/api/download/models/175276?type=Model&format=SafeTensor" && \
    curl -L -o /app/ComfyUI/models/loras/SD15/add-detail.safetensors "https://civitai.com/api/download/models/87153?type=Model&format=SafeTensor" && \
    curl -L -o /app/ComfyUI/models/loras/SD15/Glitching.safetensors "https://civitai.com/api/download/models/87191?type=Model&format=SafeTensor" && \
    curl -L -o /app/ComfyUI/models/loras/SD15/v3_sd15_adapter.ckpt "https://huggingface.co/guoyww/animatediff/resolve/main/v3_sd15_adapter.ckpt" && \
    curl -L -o /app/ComfyUI/models/loras/SD15/Hyper-SD15-12steps-CFG-lora.safetensors "https://civitai.com/api/download/models/571916?type=Model&format=SafeTensor" && \
    curl -L -o /app/ComfyUI/models/loras/SD15/emma15.safetensors "https://huggingface.co/datasets/x0io0x/EOR/resolve/main/emma15.safetensors" && \
    curl -L -o /app/ComfyUI/models/loras/SD15/tyrana20.safetensors "https://huggingface.co/datasets/x0io0x/EOR/resolve/main/tyrana20.safetensors"

# AnimateDiff Motion Model
RUN mkdir -p /app/ComfyUI/models/animatediff_models && \
    curl -L -o /app/ComfyUI/models/animatediff_models/mm_sd_v15_v2.ckpt "https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt"

# Motion LoRA
RUN mkdir -p /app/ComfyUI/models/motion_lora && \
    curl -L -o /app/ComfyUI/models/motion_lora/v2_lora_ZoomIn.ckpt "https://huggingface.co/guoyww/animatediff/resolve/main/v2_lora_ZoomIn.ckpt" && \
    curl -L -o /app/ComfyUI/models/motion_lora/"aidma-RUN-Motion Lora.safetensors" "https://civitai.com/api/download/models/529725?type=Model&format=SafeTensor" && \
    curl -L -o /app/ComfyUI/models/motion_lora/lightningMotionLora_thunderStrike.safetensors "https://civitai.com/api/download/models/671139?type=Model&format=SafeTensor"

# RIFE Models for Frame Interpolation (Link Verificado)
RUN mkdir -p /app/ComfyUI/models/rife && \
    curl -L -o /app/ComfyUI/models/rife/rife47.pth "https://huggingface.co/hzwer/rife-v4.7/resolve/main/rife_v4.7_large_model.pth?download=true"
