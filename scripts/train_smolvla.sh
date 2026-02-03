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

# --------------------------------------
# Hugging Face authentication
# --------------------------------------
hf auth login --token ${HF_TOKEN}

# --------------------------------------
# Weights & Biases authentication
# --------------------------------------
wandb login ${WANDB_TOKEN}

# --------------------------------------
# Training: SMOLVLA
# --------------------------------------
# IMPORTANT: validators is weird with the filepathing and causes errors with repo_id
#   this only shows up if pushing to hub is set to true, so set to false and manually
#   push after.
lerobot-train --policy.path=lerobot/smolvla_base --dataset.repo_id=${HF_USER}/eval_v2_so101_lego-to-mug_50ep --batch_size=4 --steps=20000 --output_dir=./outputs/test-DELETETHIS --job_name=v2_ft_smolvla_so101_lego-to-mug_50ep --policy.device=cuda --wandb.enable=false --policy.push_to_hub=false

# --------------------------------------
# Upload checkpoints
# --------------------------------------
huggingface-cli upload ${HF_USER}/test_training_DELETETHIS ./outputs/test-DELETETHIS/checkpoints/last/pretrained_model
