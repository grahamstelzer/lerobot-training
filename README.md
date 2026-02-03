# LeRobot Policy Training Docker Setup

This repository provides a pre-configured Docker environment and training script to fine-tune LeRobot policies on a custom dataset.

---

## Prerequisites

- Docker installed with GPU support (nvidia-container-toolkit)
- Git
- A Hugging Face account and API token
- (Optional) Weights & Biases account and API token

---


## Docker Image

Stored on Docker Hub, pull with:

```bash
docker pull grahamwichhh/lerobot-train:latest
```



## Repository Setup

1. Clone the repository:

```bash
git clone https://github.com/grahamstelzer/lerobot-training.git
cd lerobot-training
```

2. Create a .env file in the subdirectory of the intended training folder. For example, if you want to run training on RunPod:

```bash
cd runpod/
touch .env
```

The format of the .env file should be like the one below:
```bash
#.env example:
HF_TOKEN=<your_huggingface_token>
HF_USER=<your_huggingface_username>
WANDB_TOKEN=<your_wandb_token>   # optional if using W&B
```

## Build the Docker Image

```bash
docker build -t lerobot-train:latest .
```

## Run the Docker Container

```bash
docker run -it --rm \
    --gpus all \
    --shm-size=8g \
    -v "${PWD}/outputs:/workspace/lerobot/outputs" \
    -v "$HOME/.cache/huggingface:/root/.cache/huggingface" \
    -v "${PWD}/.env:/workspace/lerobot/.env:ro" \
    -w /workspace/lerobot \
    lerobot-train:latest \
    /bin/bash
```

## Training

Inside the container, run the desired training bash script:

### SmolVLA:
```bash
./train_smolvla.sh
```

### PI0:
```bash
./train_pi0.sh
```