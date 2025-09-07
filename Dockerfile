# Usa la imagen base oficial de ComfyUI de RunPod.
FROM runpod/worker-comfyui:5.4.1-base

# Cambia al usuario 'root' para obtener los permisos necesarios.
USER root

# Instala los repositorios y las dependencias de NVIDIA.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    zip \
    unzip \
    rar \
    wget
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub | gpg --dearmor -o /etc/apt/keyrings/nvidia-container-toolkit-keyring.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nvidia-container-toolkit-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnvinfer-dev \
    libnccl-dev \
    libnv-compute-dev \
    libcublas-dev \
    libcusparse-dev \
    libcufft-dev \
    libcurand-dev \
    libnpp-dev \
    cuda-toolkit-12-2 \
    ttf-dejavu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Vuelve a cambiar al usuario runpod.
USER runpod

# Establece el directorio de trabajo.
WORKDIR /workspace

# Clonar nodos personalizados
RUN git clone https://github.com/Smirnov75/ComfyUI-mxToolkit.git /workspace/ComfyUI/custom_nodes/ComfyUI-mxToolkit
RUN git clone https://github.com/thu-ml/SageAttention.git /workspace/ComfyUI/custom_nodes/SageAttention && cd /workspace/ComfyUI/custom_nodes/SageAttention && pip install .
RUN git clone https://github.com/Yarvix/ComfyUI-YarvixPA.git /workspace/ComfyUI/custom_nodes/ComfyUI-YarvixPA && pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-YarvixPA/requirements.txt
RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui.git /workspace/ComfyUI/custom_nodes/was-node-suite-comfyui && pip install -r /workspace/ComfyUI/custom_nodes/was-node-suite-comfyui/requirements.txt
RUN git clone https://github.com/diogod/ComfyUI_ChatterBox_SRT_Voice.git /workspace/ComfyUI/custom_nodes/ComfyUI_ChatterBox_SRT_Voice && pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI_ChatterBox_SRT_Voice/requirements.txt
RUN git clone https://github.com/Zehong-Ma/ComfyUI-MagCache.git /workspace/ComfyUI/custom_nodes/ComfyUI-MagCache && pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-MagCache/requirements.txt
RUN git clone https://github.com/Academiasd/comfyui_AcademiaSD.git /workspace/ComfyUI/custom_nodes/comfyui_AcademiaSD && pip install -r /workspace/ComfyUI/custom_nodes/comfyui_AcademiaSD/requirements.txt

# Instalar dependencias de los nodos personalizados
WORKDIR /workspace/ComfyUI/custom_nodes/ComfyUI-mxToolkit
RUN pip install --no-cache-dir -r requirements.txt 2>/dev/null || echo "No requirements.txt found, continuing..."

# Volver al directorio principal
WORKDIR /workspace

# Crear estructura de directorios para modelos
RUN mkdir -p /workspace/ComfyUI/models/checkpoints \
    /workspace/ComfyUI/models/loras \
    /workspace/ComfyUI/models/animatediff_models \
    /workspace/ComfyUI/models/animatediff_motion_lora \
    /workspace/ComfyUI/models/controlnet \
    /workspace/ComfyUI/models/vae \
    /workspace/ComfyUI/input

# Descargar modelos
RUN comfy model download --url https://civitai.com/api/download/models/503725 --relative-path models/checkpoints/SD15 --filename 503725.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/237459 --relative-path models/checkpoints/SD15 --filename 237459.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/173821 --relative-path models/checkpoints/SD15 --filename 173821.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/175276 --relative-path models/loras/SD15 --filename 175276.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/87153 --relative-path models/loras/SD15 --filename 87153.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/87191 --relative-path models/loras/SD15 --filename 87191.safetensors
RUN comfy model download --url https://huggingface.co/guoyww/animatediff/resolve/main/v3_sd15_adapter.ckpt --relative-path models/loras/SD15 --filename v3_sd15_adapter.ckpt
RUN comfy model download --url https://civitai.com/api/download/models/571916 --relative-path models/loras/SD15 --filename 571916.safetensors
RUN comfy model download --url https://huggingface.co/datasets/x0io0x/EOR/resolve/main/emma15.safetensors --relative-path models/loras/SD15/Emma --filename emma15.safetensors
RUN comfy model download --url https://huggingface.co/datasets/x0io0x/EOR/resolve/main/tyrana20.safetensors --relative-path models/loras/SD15/tyrana2 --filename tyrana20.safetensors
RUN comfy model download --url https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt --relative-path models/animatediff_models --filename mm_sd_v15_v2.ckpt
RUN comfy model download --url https://huggingface.co/guoyww/animatediff/resolve/main/v2_lora_ZoomIn.ckpt --relative-path models/animatediff_motion_lora --filename v2_lora_ZoomIn.ckpt
RUN comfy model download --url https://civitai.com/api/download/models/529725 --relative-path models/animatediff_motion_lora --filename 529725.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/671139 --relative-path models/animatediff_motion_lora --filename 671139.safetensors
RUN comfy model download --url https://huggingface.co/datasets/x0io0x/EOR/resolve/main/Eye%20On%20The%20Road.wav --relative-path input --filename EyeOnTheRoad.wav

# Configurar variables de entorno
ENV PYTHONUNBUFFERED=1

# Puerto expuesto
EXPOSE 3000

# Comando de inicio para RunPod serverless
CMD ["python", "-u", "/workspace/ComfyUI/main.py", "--listen", "0.0.0.0", "--port", "3000"]
