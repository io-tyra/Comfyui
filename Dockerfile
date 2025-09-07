# Usa la imagen base oficial de ComfyUI de RunPod.
FROM runpod/worker-comfyui:5.4.1-base

# Cambia al usuario 'root' para obtener los permisos necesarios.
USER root

# Instala las dependencias necesarias, incluyendo las bibliotecas de desarrollo de CUDA.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    zip \
    unzip \
    rar \
    libnvinfer-dev \
    libnccl-dev \
    libnv-compute-dev \
    libcublas-dev \
    libcusparse-dev \
    libcufft-dev \
    libcurand-dev \
    libnpp-dev \
    cuda-toolkit-12-2

# Agrega la ruta de binarios de CUDA al PATH para que 'nvcc' se encuentre.
ENV PATH="/usr/local/cuda/bin:${PATH}"

# --- Nodos personalizados ---
RUN git clone https://github.com/Smirnov75/ComfyUI-mxToolkit.git /workspace/ComfyUI/custom_nodes/ComfyUI-mxToolkit
# Se clona el repositorio de SageAttention y luego se instala en un paso separado.
RUN git clone https://github.com/thu-ml/SageAttention.git /workspace/ComfyUI/custom_nodes/SageAttention && cd /workspace/ComfyUI/custom_nodes/SageAttention && pip install .
RUN git clone https://github.com/Yarvix/ComfyUI-YarvixPA.git /workspace/ComfyUI/custom_nodes/ComfyUI-YarvixPA && pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-YarvixPA/requirements.txt
RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui.git /workspace/ComfyUI/custom_nodes/was-node-suite-comfyui && pip install -r /workspace/ComfyUI/custom_nodes/was-node-suite-comfyui/requirements.txt
RUN git clone https://github.com/diogod/ComfyUI_ChatterBox_SRT_Voice.git /workspace/ComfyUI/custom_nodes/ComfyUI_ChatterBox_SRT_Voice && pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI_ChatterBox_SRT_Voice/requirements.txt
RUN git clone https://github.com/Zehong-Ma/ComfyUI-MagCache.git /workspace/ComfyUI/custom_nodes/ComfyUI-MagCache && pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-MagCache/requirements.txt
RUN git clone https://github.com/Academiasd/comfyui_AcademiaSD.git /workspace/ComfyUI/custom_nodes/comfyui_AcademiaSD && pip install -r /workspace/ComfyUI/custom_nodes/comfyui_AcademiaSD/requirements.txt

# --- Modelos y LoRAs ---
# Checkpoints SD15
RUN comfy model download --url https://civitai.com/api/download/models/503725 --relative-path models/checkpoints/SD15 --filename 503725.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/237459 --relative-path models/checkpoints/SD15 --filename 237459.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/173821 --relative-path models/checkpoints/SD15 --filename 173821.safetensors

# LoRAs SD15
RUN comfy model download --url https://civitai.com/api/download/models/175276 --relative-path models/loras/SD15 --filename 175276.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/87153 --relative-path models/loras/SD15 --filename 87153.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/87191 --relative-path models/loras/SD15 --filename 87191.safetensors
RUN comfy model download --url https://huggingface.co/guoyww/animatediff/resolve/main/v3_sd15_adapter.ckpt --relative-path models/loras/SD15 --filename v3_sd15_adapter.ckpt
RUN comfy model download --url https://civitai.com/api/download/models/571916 --relative-path models/loras/SD15 --filename 571916.safetensors
RUN comfy model download --url https://huggingface.co/datasets/x0io0x/EOR/resolve/main/emma15.safetensors --relative-path models/loras/SD15/Emma --filename emma15.safetensors
RUN comfy model download --url https://huggingface.co/datasets/x0io0x/EOR/resolve/main/tyrana20.safetensors --relative-path models/loras/SD15/tyrana2 --filename tyrana20.safetensors

# Animatediff Motion Model
RUN comfy model download --url https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt --relative-path models/animatediff_models --filename mm_sd_v15_v2.ckpt

# Motion LoRAs
RUN comfy model download --url https://huggingface.co/guoyww/animatediff/resolve/main/v2_lora_ZoomIn.ckpt --relative-path models/animatediff_motion_lora --filename v2_lora_ZoomIn.ckpt
RUN comfy model download --url https://civitai.com/api/download/models/529725 --relative-path models/animatediff_motion_lora --filename 529725.safetensors
RUN comfy model download --url https://civitai.com/api/download/models/671139 --relative-path models/animatediff_motion_lora --filename 671139.safetensors

# Archivo de audio (se descarga en la carpeta input)
RUN comfy model download --url https://huggingface.co/datasets/x0io0x/EOR/resolve/main/Eye%20On%20The%20Road.wav --relative-path input --filename EyeOnTheRoad.wav
