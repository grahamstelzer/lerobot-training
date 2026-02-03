# ============================================================
# Base image: CUDA runtime
# ------------------------------------------------------------
# IMPORTANT:
# - CUDA version here must be COMPATIBLE with the host driver
# - Host driver must be >= the CUDA version in this image
# ============================================================
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# ------------------------------------------------------------
# Environment variables
# ------------------------------------------------------------
# DEBIAN_FRONTEND: avoids interactive apt prompts
# PATH: ensures conda is found first
# ------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive \
    CONDA_ALWAYS_YES=true \
    PATH=/opt/conda/bin:$PATH

# ------------------------------------------------------------
# System dependencies
# ------------------------------------------------------------
# - "building Python wheels"
# - ffmpeg support
# - USB / serial access (/dev/ttyACM*)
# - common ML tooling
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    wget \
    ca-certificates \
    ffmpeg \
    libglib2.0-0 \
    libegl1 \
    libusb-1.0-0 \
    cmake \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# (from hf docs) Install Miniforge (conda-forge distribution)
# ------------------------------------------------------------
RUN wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh \
    -O /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm /tmp/miniforge.sh

# ------------------------------------------------------------
# (from hf docs) Create conda environment for lerobot
# ------------------------------------------------------------
# We explicitly match the docs:
#   conda create -n lerobot python=3.10
# ------------------------------------------------------------
RUN conda create -y -n lerobot python=3.10 && \
    conda clean -afy

# ------------------------------------------------------------
# (from hf docs) Make conda activation work in non-interactive shells
# ------------------------------------------------------------
SHELL ["/bin/bash", "-c"]

# ------------------------------------------------------------
# (from hf docs) Activate env + install ffmpeg from conda-forge
# ------------------------------------------------------------
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda activate lerobot && \
    conda install -y -c conda-forge ffmpeg=7.1.1 && \
    conda clean -afy

# ------------------------------------------------------------
# Working directory
# ------------------------------------------------------------
WORKDIR /workspace

# ------------------------------------------------------------
# Clone lerobot repository
# ------------------------------------------------------------
RUN git clone https://github.com/huggingface/lerobot.git

# ------------------------------------------------------------
# Install lerobot + dependencies (editable as suggested by hf docs)
# ------------------------------------------------------------
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda activate lerobot && \
    cd lerobot && \
    pip install --upgrade pip && \
    pip install -e .

# ------------------------------------------------------------
# Install smolvla in editable mode  
# ------------------------------------------------------------
# ASSUMPTION:
# - smolvla lives inside lerobot/smolvla
# - adjust path if repo layout changes
# ------------------------------------------------------------
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda activate lerobot && \
    cd lerobot && \
    pip install -e ".[smolvla]"

# ------------------------------------------------------------
# Copy training entrypoint script
# ------------------------------------------------------------
COPY scripts/train_smolvla.sh /workspace/lerobot/train_smolvla.sh
COPY scripts/train_pi0.sh /workspace/lerobot/train_pi0.sh

RUN chmod +x /workspace/lerobot/train_smolvla.sh
RUN chmod +x /workspace/lerobot/train_pi0.sh




# ------------------------------------------------------------
# - Container starts
# - Script runs automatically
# - Container exits when training finishes
# ------------------------------------------------------------
# CMD ["/workspace/run_training.sh"]




