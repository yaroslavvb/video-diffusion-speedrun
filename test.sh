#!/bin/bash
L=8
D=512
bs=2
lr=0.0003
compile=False
dataset=fake

[ -z "$HF_HUB_TOKEN" ] && echo "warning: HF_HUB_TOKEN is not set"
[ -z "$HF_HOME" ] && echo "warning: HF_HOME is not set"
export HF_HUB_USE_HF_TRANSFER=1
export WANDB_MODE=offline

# FileNotFoundError: [Errno 2] No such file or directory: './cache/train/continuous/train/index.json' -> './cache/train/index.json'
. .venv/bin/activate
OMP_NUM_THREADS=32 torchrun --nproc_per_node=8 train.py \
    --batch_size $bs \
    --run_name lr${lr}_width512 \
    --num_epochs 100 \
    --learning_rate ${lr} \
    --max_steps 5004 \
    --evaluate_every 500 \
    --model_width $D \
    --model_depth $L \
    --model_head_dim 128 \
    --optimizer_type mup_adam \
    --lr_scheduler_type linear \
    --project_name openvid-diffusion-ci \
    --dataset $dataset \
    --compile_models $compile