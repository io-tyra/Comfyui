# Usa la imagen base de ComfyUI de RunPod.
FROM runpod/worker-comfyui:5.4.1-base

# Instala Git y las herramientas de compresión
RUN apt-get update && apt-get install -y git zip unzip rar

# Clona el repositorio de ComfyUI-mxToolkit
RUN git clone https://github.com/Smirnov75/ComfyUI-mxToolkit.git /workspace/ComfyUI/custom_nodes/ComfyUI-mxToolkit

# Clona el repositorio de SageAttention y lo instala
RUN git clone https://github.com/thu-ml/SageAttention.git
WORKDIR /SageAttention
RUN pip install .

# Navega al directorio de nodos personalizados de ComfyUI
WORKDIR /workspace/ComfyUI/custom_nodes

# Clona los repositorios de tus otros nodos personalizados
# NOTA: Los enlaces son una estimación. Si un enlace no funciona,
# por favor busca el repositorio exacto en GitHub.

# ComfyUI-YarvixPA
RUN git clone https://github.com/Yarvix/ComfyUI-YarvixPA.git

# WAS Node Suite
RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui.git

# ComfyUI_ChatterBox_SRT_Voice
RUN git clone https://github.com/diogod/ComfyUI_ChatterBox_SRT_Voice.git

# ComfyUI-MagCache
RUN git clone https://github.com/Zehong-Ma/ComfyUI-MagCache.git

# comfyui_AcademiaSD
RUN git clone https://github.com/Academiasd/comfyui_AcademiaSD.git

# Instala las dependencias de Python para cada nodo.
WORKDIR /workspace/ComfyUI/custom_nodes/ComfyUI-YarvixPA
RUN pip install -r requirements.txt

WORKDIR /workspace/ComfyUI/custom_nodes/was-node-suite-comfyui
RUN pip install -r requirements.txt

WORKDIR /workspace/ComfyUI/custom_nodes/ComfyUI_ChatterBox_SRT_Voice
RUN pip install -r requirements.txt

WORKDIR /workspace/ComfyUI/custom_nodes/ComfyUI-MagCache
RUN pip install -r requirements.txt

WORKDIR /workspace/ComfyUI/custom_nodes/comfyui_AcademiaSD
RUN pip install -r requirements.txt