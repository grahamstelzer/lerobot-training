#!/usr/bin/env bash
set -e  # fail fast if anything breaks
# set -x   # print each command after expansion

# tokens:
set -a
source .env
set +a

# --------------------------------------
# Activate conda environment
# --------------------------------------
source /opt/conda/etc/profile.d/conda.sh
conda activate lerobot

if ! conda info --envs | grep -q "lerobot"; then
    echo "Error: lerobot conda environment not found"
    exit 1
fi

# --------------------------------------
# Hugging Face authentication
# --------------------------------------
hf auth login --token ${HF_TOKEN}

# --------------------------------------
# Weights & Biases authentication
# --------------------------------------
wandb login ${WANDB_TOKEN}


# get dataset
echo "cloning dataset"
git clone https://huggingface.co/datasets/grahamwichhh/eval_v2_so101_lego-to-mug_50ep /home/csrobot/.cache/huggingface/lerobot/${HF_USER}

# --------------------------------------
# Training: PI0
# --------------------------------------
# IMPORTANT: validators is weird with the filepathing and causes errors with repo_id
#   this only shows up if pushing to hub is set to true, so set to false and manually
#   push after.

lerobot-train --dataset.repo_id=${HF_USER}/eval_v2_so101_lego-to-mug_50ep --policy.type=pi0 --output_dir=./outputs/pi0_training --job_name=pi0_training --policy.pretrained_path=lerobot/pi0_base --policy.repo_id=${HF_USER}/v2_pi0_so101_lego-to-mug_50ep --policy.compile_model=true --policy.gradient_checkpointing=true --policy.dtype=bfloat16 --policy.freeze_vision_encoder=false --policy.train_expert_only=false --steps=3000 --policy.device=cuda --batch_size=8 --wandb.enable=false


# --------------------------------------
# Upload checkpoints 
# --------------------------------------
# pi0 auto-upload should work correctly so no neead to rerun afterwards
# huggingface-cli upload ${HF_USER}/v2_pi0_so101_lego-to-mug_50ep ./outputs/pi0_training
