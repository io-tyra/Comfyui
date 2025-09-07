# Usa la imagen base de RunPod para ComfyUI, que ya tiene las dependencias base de CUDA y Python.
FROM docker.io/runpod/worker-comfyui:5.4.1-base

# Establece el directorio de trabajo a la raíz de ComfyUI.
WORKDIR /app/ComfyUI

# 1. INSTALAR DEPENDENCIAS DEL SISTEMA
# ------------------------------------
# Instala git (para clonar repos) y otras utilidades. Se corrige el nombre del paquete de fuentes.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    fonts-dejavu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. INSTALAR NODOS PERSONALIZADOS
# --------------------------------
# Clona todos los repositorios de nodos personalizados que tu workflow necesita.
WORKDIR /app/ComfyUI/custom_nodes

RUN git clone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git && \
    git clone https://github.com/yolain/comfyui_yvann_nodes.git && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git && \
    git clone https://github.com/FizzleDorf/ComfyUI_FizzNodes.git && \
    git clone https://github.com/rgthree/rgthree-comfy.git && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git && \
    git clone https://github.com/Kijai/ComfyUI-KJNodes.git && \
    git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git && \
    git clone https://github.com/WASasquatch/was-node-suite-comfyui.git && \
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git

# Instala las dependencias de Python para los nodos personalizados
RUN pip install -r ComfyUI-Impact-Pack/requirements.txt && \
    pip install -r was-node-suite-comfyui/requirements.txt

# 3. DESCARGAR TODOS LOS MODELOS Y ARCHIVOS
# -----------------------------------------
# Vuelve al directorio raíz de ComfyUI para organizar los modelos.
WORKDIR /app/ComfyUI

# == Archivo de Audio de Entrada ==
# Se coloca en la carpeta 'input' para que el nodo 'Load Audio' lo encuentre.
RUN mkdir -p /app/ComfyUI/input && \
    wget -O /app/ComfyUI/input/"Eye On The Road.wav" "https://huggingface.co/datasets/x0io0x/EOR/resolve/main/Eye%20On%20The%20Road.wav"

# == Checkpoints ==
RUN mkdir -p /app/ComfyUI/models/checkpoints/SD15 && \
    # Asumo que 'mixCyber_noEma.safetensors' es un modelo personalizado. Reemplaza la URL si tienes una fuente oficial.
    # Por ahora, uso un checkpoint cyberpunk popular como marcador de posición.
    wget -O /app/ComfyUI/models/checkpoints/SD15/mixCyber_noEma.safetensors "https://civitai.com/api/download/models/122359"

# == LoRAs ==
RUN mkdir -p /app/ComfyUI/models/loras/SD15/tyrana2 && \
    mkdir -p /app/ComfyUI/models/loras/SD15/Emma && \
    wget -O /app/ComfyUI/models/loras/SD15/v3_sd15_adapter.ckpt "https://huggingface.co/guoyww/animatediff/resolve/main/v3_sd15_adapter.ckpt" && \
    wget -O /app/ComfyUI/models/loras/SD15/Hyper-SD15-12steps-CFG-lora.safetensors "https://huggingface.co/ByteDance/Hyper-SD/resolve/main/Hyper-SD15-12steps-CFG-lora.safetensors" && \
    wget -O /app/ComfyUI/models/loras/SD15/Glitching.safetensors "https://civitai.com/api/download/models/261311" && \
    wget -O /app/ComfyUI/models/loras/SD15/tyrana2/tyrana20.safetensors "https://huggingface.co/datasets/x0io0x/EOR/resolve/main/tyrana20.safetensors" && \
    wget -O /app/ComfyUI/models/loras/SD15/more_details.safetensors "https://civitai.com/api/download/models/128383" && \
    wget -O /app/ComfyUI/models/loras/SD15/Emma/emma15.safetensors "https://huggingface.co/datasets/x0io0x/EOR/resolve/main/emma15.safetensors" && \
    wget -O /app/ComfyUI/models/loras/SD15/CyberpunkWorld.safetensors "https://civitai.com/api/download/models/241851"

# == AnimateDiff Motion Models ==
RUN mkdir -p /app/ComfyUI/models/animatediff_models && \
    wget -O /app/ComfyUI/models/animatediff_models/mm_sd_v15_v2.ckpt "https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt"

# == Motion LoRAs ==
RUN mkdir -p /app/ComfyUI/models/motion_lora && \
    wget -O /app/ComfyUI/models/motion_lora/v2_lora_ZoomIn.ckpt "https://huggingface.co/guoyww/animatediff/resolve/main/v2_lora_ZoomIn.ckpt" && \
    wget -O /app/ComfyUI/models/motion_lora/lightningMotionLora_thunderStrike.safetensors "https://civitai.com/api/download/models/662943" && \
    wget -O "/app/ComfyUI/models/motion_lora/aidma-RUN-Motion Lora.safetensors" "https://civitai.com/api/download/models/539121"

# == Upscale Models ==
RUN mkdir -p /app/ComfyUI/models/upscale_models && \
    wget -O /app/ComfyUI/models/upscale_models/8x_NMKD-Superscale_150000_G.pth "https://huggingface.co/gemasai/8x_NMKD-Superscale_150000_G/resolve/main/8x_NMKD-Superscale_150000_G.pth"

# == RIFE Models ==
RUN mkdir -p /app/ComfyUI/models/rife && \
    wget -O /app/ComfyUI/models/rife/rife47.pth "https://huggingface.co/hithereai/rife-v4.7/resolve/main/rife47.pth"
