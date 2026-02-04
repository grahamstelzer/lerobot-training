FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    CONDA_ALWAYS_YES=true \
    PATH=/opt/conda/bin:$PATH

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

RUN wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh \
    -O /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm /tmp/miniforge.sh

RUN conda create -y -n lerobot python=3.10 && \
    conda clean -afy

SHELL ["/bin/bash", "-c"]

RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda activate lerobot && \
    conda install -y -c conda-forge ffmpeg=7.1.1 && \
    conda clean -afy

WORKDIR /workspace

# lerobot
RUN git clone https://github.com/huggingface/lerobot.git

# install lerobot
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda activate lerobot && \
    cd lerobot && \
    pip install --upgrade pip && \
    pip install -e .

# install pi0 dependencies
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda activate lerobot && \
    cd lerobot && \
    pip install --upgrade pip && \
    pip install -e ".[pi]"

COPY train_pi0.sh /workspace/lerobot/train_pi0.sh
RUN chmod +x /workspace/lerobot/train_pi0.sh