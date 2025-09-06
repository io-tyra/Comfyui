# Usa la imagen base oficial y verificada de ComfyUI de RunPod.
FROM runpod/worker-comfyui:5.4.1-base

# Instala el kit de desarrollo de CUDA para compilar los nodos.
RUN apt-get update && apt-get install -y git zip unzip rar ttf-dejavu cuda-toolkit-12-2

# Clona e instala ComfyUI-mxToolkit
RUN git clone https://github.com/Smirnov75/ComfyUI-mxToolkit.git /workspace/ComfyUI/custom_nodes/ComfyUI-mxToolkit

# Clona el repositorio de SageAttention y lo instala
RUN git clone https://github.com/thu-ml/SageAttention.git
WORKDIR /SageAttention
RUN pip install .

# Navega al directorio de nodos personalizados de ComfyUI
WORKDIR /workspace/ComfyUI/custom_nodes

# Clona y navega a los directorios de los otros nodos personalizados
RUN git clone https://github.com/Yarvix/ComfyUI-YarvixPA.git && \
    git clone https://github.com/WASasquatch/was-node-suite-comfyui.git && \
    git clone https://github.com/diogod/ComfyUI_ChatterBox_SRT_Voice.git && \
    git clone https://github.com/Zehong-Ma/ComfyUI-MagCache.git && \
    git clone https://github.com/Academiasd/comfyui_AcademiaSD.git

# Instala las dependencias de Python para cada nodo.
RUN pip install -r ComfyUI-YarvixPA/requirements.txt && \
    pip install -r was-node-suite-comfyui/requirements.txt && \
    pip install -r ComfyUI_ChatterBox_SRT_Voice/requirements.txt && \
    pip install -r ComfyUI-MagCache/requirements.txt && \
    pip install -r comfyui_AcademiaSD/requirements.txt
