# Usar la imagen base de RunPod para ComfyUI
FROM runpod/worker-comfyui:5.4.1-base

# Crear el usuario runpod con el UID esperado
RUN useradd -m -u 1000 -s /bin/bash runpod && \
    chown -R runpod:runpod /workspace

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    zip \
    unzip \
    rar \
    wget \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cambiar al usuario runpod
USER runpod

# Establecer el directorio de trabajo
WORKDIR /workspace

# Clonar nodos personalizados
RUN git clone https://github.com/Smirnov75/ComfyUI-mxToolkit.git /workspace/ComfyUI/custom_nodes/ComfyUI-mxToolkit

# Instalar dependencias de los nodos personalizados
WORKDIR /workspace/ComfyUI/custom_nodes/ComfyUI-mxToolkit
RUN pip install --no-cache-dir -r requirements.txt 2>/dev/null || echo "No requirements.txt found, continuing..."

# Volver al directorio principal
WORKDIR /workspace

# Crear estructura de directorios para modelos
RUN mkdir -p /workspace/ComfyUI/models/checkpoints \
    /workspace/ComfyUI/models/loras \
    /workspace/ComfyUI/models/controlnet \
    /workspace/ComfyUI/models/vae

# Configurar variables de entorno
ENV PYTHONUNBUFFERED=1

# Puerto expuesto
EXPOSE 3000

# Comando de inicio para RunPod serverless
CMD ["python", "-u", "/workspace/ComfyUI/main.py", "--listen", "0.0.0.0", "--port", "3000"]
