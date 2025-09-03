# Troubleshooting: Why Can't I See My Push?

## Quick Answer

If you can't see your changes on the live website after pushing to this repository, it's likely due to one of these reasons:

1. **Branch Protection**: You cannot push directly to `main` - all changes must go through pull requests
2. **Wrong Branch**: You pushed to a feature branch, but the website only deploys from `main`
3. **Deployment Time**: After merging to `main`, it takes 5-10 minutes for changes to appear
4. **Browser Caching**: Your browser is showing a cached version of the site

## Understanding the Deployment Process

This repository uses an automated deployment pipeline:

```
Your Changes → Feature Branch → Pull Request → main branch → GitHub Actions → gh-pages branch → Live Website
```

### Step-by-Step Process:

1. **Create Feature Branch**: Work on a separate branch (not `main`)
2. **Push to GitHub**: Push your feature branch to the remote repository
3. **Open Pull Request**: Create a PR to merge your changes into `main`
4. **Review & Merge**: After review, merge the PR into `main`
5. **Automatic Deployment**: GitHub Actions builds and deploys the site (5-10 minutes)
6. **Live Website**: Changes appear on the live site

## Common Issues and Solutions

### Issue 1: "Push was rejected"
**Symptom**: Error message when trying to push to `main`
```
! [remote rejected] main -> main (protected branch hook declined)
```

**Solution**: 
- You cannot push directly to `main` due to branch protection
- Create a feature branch and open a pull request instead
- See the "Making Changes" section in README.md for detailed steps

### Issue 2: "I pushed but don't see changes on the website"
**Possible Causes**:
- You pushed to a feature branch, not `main`
- Changes are in `main` but deployment is still running
- Website is cached in your browser

**Solutions**:
1. Check which branch you pushed to: `git branch`
2. If on feature branch, open a pull request to merge to `main`
3. If merged to `main`, wait 5-10 minutes for deployment
4. Force refresh your browser or use incognito mode

### Issue 3: "Another push from different branch 20 minutes ago"
**Answer**: Previous pushes to other branches do NOT affect your ability to push new changes. Each branch is independent. However:
- Only changes merged to `main` will be deployed
- Multiple feature branches can exist simultaneously
- The website only shows what's currently on `main`

### Issue 4: "Deployment seems stuck"
**Check deployment status**:
1. Go to the [Actions tab](https://github.com/lmu-osc/lmu-osc.github.io/actions) on GitHub
2. Look for "Quarto Publish" workflows
3. Check if any are currently running or failed

## How to Check Your Changes

### 1. Verify Your Branch
```bash
git branch
# Shows current branch with *
git status
# Shows if you have uncommitted changes
```

### 2. Check Remote Branches
```bash
git branch -r
# Shows all remote branches
git log --oneline origin/main
# Shows recent commits on main branch
```

### 3. Compare Your Branch with Main
```bash
git log main..your-branch-name
# Shows commits in your branch that aren't in main
```

### 4. Check if PR is Needed
- If you're on a feature branch, you need to open a pull request
- Go to the repository on GitHub
- Click "Compare & pull request" if available
- Or manually create a PR to merge your branch into `main`

## Proper Workflow for Changes

### For New Contributors:
1. Clone the repository: `git clone git@github.com:lmu-osc/lmu-osc.github.io.git`
2. Create feature branch: `git checkout -b feature/your-change-name`
3. Make your changes to `.qmd` files
4. Commit changes: `git add -A && git commit -m "Description of changes"`
5. Push branch: `git push -u origin feature/your-change-name`
6. Open pull request on GitHub
7. Wait for review and merge
8. Changes will be live 5-10 minutes after merge

### For Existing Contributors:
1. Pull latest changes: `git pull origin main`
2. Create new feature branch: `git checkout -b feature/new-change`
3. Follow steps 3-8 above

## Checking Deployment Status

### GitHub Actions Status:
- Green checkmark ✅: Deployment successful
- Red X ❌: Deployment failed (check logs)
- Yellow circle 🟡: Deployment in progress

### Website Updates:
- Changes appear 5-10 minutes after successful deployment
- Hard refresh browser: `Ctrl+F5` (Windows/Linux) or `Cmd+Shift+R` (Mac)
- Use incognito/private browsing mode to bypass cache

## Still Having Issues?

1. **Check the Actions tab** for failed deployments
2. **Verify your branch** is merged into `main`
3. **Wait longer** - sometimes deployments take up to 15 minutes
4. **Clear browser cache** completely
5. **Ask for help** by opening an issue in this repository

## Technical Details

- **Main Branch**: `main` (protected, requires PRs)
- **Deployment Branch**: `gh-pages` (auto-generated)
- **Build Tool**: Quarto + GitHub Actions
- **Deployment Target**: GitHub Pages
- **Typical Build Time**: 3-7 minutes
- **Cache TTL**: Varies by browser and CDN

---

*Last updated: $(date)*