#!/bin/bash

echo "=== LMU OSC Website Deployment Diagnostic ==="
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    echo "   Run this script from the lmu-osc.github.io repository directory"
    exit 1
fi

echo "✅ In git repository"

# Check current branch
current_branch=$(git branch --show-current)
echo "📍 Current branch: $current_branch"

if [ "$current_branch" = "main" ]; then
    echo "⚠️  Warning: You're on the main branch"
    echo "   Consider creating a feature branch for new changes"
else
    echo "✅ On feature branch (recommended for new changes)"
fi

echo ""

# Check if there are uncommitted changes
if ! git diff --quiet; then
    echo "⚠️  You have uncommitted changes:"
    git status --porcelain
    echo "   Run 'git add -A && git commit -m \"Your message\"' to commit them"
else
    echo "✅ No uncommitted changes"
fi

echo ""

# Check if current branch is ahead of origin
if git status | grep -q "ahead of"; then
    echo "📤 Your branch has commits that haven't been pushed:"
    git log origin/$current_branch..$current_branch --oneline 2>/dev/null || git log --oneline -n 5
    echo "   Run 'git push' to push your changes"
elif git status | grep -q "up to date"; then
    echo "✅ Branch is up to date with remote"
else
    echo "ℹ️  Branch status:"
    git status -b
fi

echo ""

# Check recent commits on main
echo "📋 Recent commits on main branch:"
git log origin/main --oneline -n 5 2>/dev/null || git log main --oneline -n 5

echo ""

# Check if there are differences between current branch and main
if [ "$current_branch" != "main" ]; then
    commits_ahead=$(git rev-list --count main..$current_branch 2>/dev/null || echo "0")
    if [ "$commits_ahead" -gt 0 ]; then
        echo "📈 Your branch is $commits_ahead commits ahead of main"
        echo "   Your changes will appear on the website after:"
        echo "   1. Opening a pull request"
        echo "   2. Merging the PR into main"
        echo "   3. Waiting 5-10 minutes for deployment"
    else
        echo "📉 Your branch has no new commits compared to main"
    fi
fi

echo ""

# Provide next steps
echo "🔄 Next Steps:"
if [ "$current_branch" = "main" ]; then
    echo "   1. Create a feature branch: git checkout -b feature/your-change-name"
    echo "   2. Make your changes"
    echo "   3. Commit and push your changes"
    echo "   4. Open a pull request on GitHub"
elif git status | grep -q "ahead of" || [ "$commits_ahead" -gt 0 ]; then
    echo "   1. Push your changes: git push"
    echo "   2. Open a pull request on GitHub to merge into main"
    echo "   3. Wait for review and merge"
    echo "   4. Check the website 5-10 minutes after merge"
else
    echo "   1. Make your changes to .qmd files"
    echo "   2. Commit: git add -A && git commit -m 'Description'"
    echo "   3. Push: git push"
    echo "   4. Open a pull request on GitHub"
fi

echo ""
echo "🌐 Live website: https://lmu-osc.github.io/"
echo "🔧 GitHub Actions: https://github.com/lmu-osc/lmu-osc.github.io/actions"
echo "📖 Full troubleshooting guide: TROUBLESHOOTING_DEPLOYMENTS.md"
echo ""
echo "=== End Diagnostic ==="