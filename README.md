# LMU Open Science Center Resources Page

## Overview

This repository hosts the OSC's Resources webpage where content from workshops, other websites, and related information is organized/linked to.

## Updating this Page

A CI/CD pipeline for automatically rendering and redeploying the website has been set up using GitHub Actions. What does this mean? TL;DR only changes to `.qmd` files (and `_quarto.yml`) should be made, and users who wish to make changes will need to make a new branch, push that branch to this repo, and open a pull request for their changes.

### Detailed Explanation

High-level: the GitHub Action is configured to automatically rebuild and redeploy the site whenever a push is made to the `main` branch of this repository. There is a branch protection rule preventing direct pushes to `main` so pull requests for changes are required. The GH Action rebuilds the website on the `gh-pages` branch of this repo, and the GitHub Pages configuration is currently set to deploy the website from this branch in the Settings -> Pages repo section.

### Making Changes

If you don't already have the repository on your system, clone a copy.

```
git clone git@github.com:lmu-osc/resources.git
```

If you cloned a while ago or your copy is otherwise likely to be behind the code on GitHub, you'll want to pull the changes to your computer. (This is equivalent to fetching the changes *and* merging them.)

```
git pull
```

Note that this will only integrate the changes for the branch you currently have checked out. If you want to pull changes for **all** of the branches you have locally and that have changes on GitHub, run `git pull --all` instead.

At this point, your local copy should be synced up with the remote repository on GitHub. To make changes, you will now need to create a new branch and checkout that new branch so you are working on it.

```
git branch <new_branch>
git checkout <new_branch>
```

Make any desired changes and commit them. You can use the template code below or use your GUI for this easily.

```
git add -A
git commit -m "Your message here"
```

If this is a new branch, you will need to push the branch to GitHub.

```
git push -u origin <new_branch>
```

Now, there should be a notification on the repo page that a new branch has been pushed, and it should also ask if you would like to open a pull request. Follow this link, write an informative title and description of the pull request, and open it for review. (Ideally, someone else will be able to review your changes, but self-approvals are also fine if needed.) Following review, there are generally 3 options for pull requests: squashing, merging, and rebasing. I've disabled rebasing in this repo, and one should squash commits. (Squashing basically collapses all of the commits on your working branch e.g. `<new_branch>` into a single commit. It's a method to keep the commit history relatively clean and clear.)

After the PR has been completed, the GH Action will take effect and the website should be updated within 5-10 minutes. You may need to view the page in incognito mode or force refresh multiple times as your browser will likely have an older cached version of the page.

Finally, you'll want to update your own local copy of this repository by returning to the beginning of these instructions (i.e. run `git pull`).


