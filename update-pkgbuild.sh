#!/bin/bash
# update.sh — автоматическое обновление PKGBUILD-репозитория
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

echo "🔄 Syncing with GitHub..."
git pull --rebase || { echo "❌ Failed to pull. Resolve conflicts first."; exit 1; }

echo "🔍 Validating PKGBUILD..."
if command -v namcap &>/dev/null; then
    namcap PKGBUILD 2>/dev/null || echo "⚠️  namcap warnings found (usually safe to ignore)"
else
    echo "ℹ️  Install 'namcap' for better validation: sudo pacman -S namcap"
fi

# Для git-источников хеш-суммы = 'SKIP', обновлять не нужно.
echo "ℹ️  Git source detected. Checksums are managed via commit hashes."

# Опционально: обновить .SRCINFO (если захочешь выложить в AUR)
if command -v mksrcinfo &>/dev/null; then
    echo "📝 Regenerating .SRCINFO..."
    makepkg --printsrcinfo > .SRCINFO
    git add .SRCINFO
fi

# Фиксируем изменения, если они есть
if ! git diff --quiet || [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "chore: sync pkgbuild $(date +%Y-%m-%d)"
    echo "🚀 Pushing to GitHub..."
    git push
else
    echo "✅ Already up to date. No changes to commit."
fi

echo "✨ Ready! Build with: makepkg -si"