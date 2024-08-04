#!/bin/bash

# 设置 Hugo 博客的源目录和部署目录
SOURCE_DIR="D:/Atoposx"
PUBLIC_DIR="D:/Atoposx/public"
GITHUB_REPO="https://github.com/Atopos-x/Atopos-x.github.io.git"
DEPLOY_BRANCH="main" # 使用 main 分支

# 确保在 Hugo 博客源目录中
cd "$SOURCE_DIR"

# 构建 Hugo 博客
hugo

# 如果构建成功，则切换到部署目录
if [ $? -eq 0 ]; then
    cd "$PUBLIC_DIR"

    # 检查是否在正确的分支
    if git rev-parse --abbrev-ref HEAD != "$DEPLOY_BRANCH"; then
        git checkout "$DEPLOY_BRANCH"
    fi

    # 拉取最新的更改
    git pull origin "$DEPLOY_BRANCH"

    # 添加所有更改的文件到 Git
    git add -A

    # 检查是否有更改需要提交
    if git diff --cached --exit-code &> /dev/null; then
        echo "No changes to commit."
    else
        # 提交更改
        git commit -m "Incremental update: $(date)"

        # 设置 GitHub 仓库的 URL
        git remote set-url origin "$GITHUB_REPO"

        # 推送到远程仓库的 main 分支
        git push origin "$DEPLOY_BRANCH"

        echo "Deployment to GitHub Pages completed successfully."
    fi
else
    echo "Hugo build failed."
    exit 1
fi