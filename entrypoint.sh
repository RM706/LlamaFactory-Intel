#!/bin/bash
set -e

TARGET_DIR="/opt/LlamaFactory"
BACKUP_DIR="/opt/LlamaFactory-defaults"

# 需要自动初始化的目录
DIRS_TO_CHECK=("data" "saves" "models" "input" "output")

for dir in "${DIRS_TO_CHECK[@]}"; do
    target="$TARGET_DIR/$dir"
    backup="$BACKUP_DIR/$dir"

    # 仅当目标目录存在且为空时才从备份恢复
    if [ -d "$target" ] && [ -z "$(ls -A "$target" 2>/dev/null)" ]; then
        echo "[entrypoint] 目录 $dir 为空，从默认备份恢复..."
        if [ -d "$backup" ]; then
            cp -a "$backup/." "$target/"
            echo "[entrypoint] $dir 恢复完成"
        else
            echo "[entrypoint] 警告：备份目录 $backup 不存在，跳过 $dir"
        fi
    fi
done

exec "$@"
