# GitHub Automation

This folder contains GitHub Actions workflows and supporting files that automate maintenance tasks for the site and repository.

## Workflows

### `add-new-year-to-events.yml`
Creates an issue at the start of each year to remind maintainers to update the events section for the new year. This workflow can also be triggered manually.

### `auto-assign-issues.yml`
Adds newly assigned issues to the assignee's GitHub Projects board. It reads the issue assignees from the event payload, looks up the matching project, and adds the issue to that project.

Note: this workflow has been manually disabled for several months, and will likely be deleted in the future.

### `check-lmu-pages-reminder.yml`
Creates a reminder issue twice a year to check LMU pages. This workflow runs on a schedule and can also be triggered manually.

### `check-profile-names.yml`
Checks naming conventions for profile files in `people/people/` on push and pull request events, and can also be run manually.

### `link-checker.yml`
Runs a link check across markdown, HTML, reStructuredText, and Quarto files. If broken links are found, it creates an issue with the report.

### `publish.yml`
Builds and publishes the Quarto site to GitHub Pages on push to `main`, and can also be triggered manually or on a schedule.

### `spell-check.yml`
Runs cspell on site source content that appears on the website. The check enforces American English spellings, allows German, and fails on configured British variants to maintain spelling consistency.

## Supporting Files

- `add-new-year-to-events.md` is the issue template used by the year reminder workflow.
- `reminder-to-check-lmu-pages-template.md` is the issue template used by the LMU pages reminder workflow.
- `_name_checker.py` contains the logic used by the profile naming workflow.

## Notes

- Some workflows create GitHub issues automatically. Review the issue templates before changing the workflows that use them.
- The issue assignment workflow depends on a repository or organization secret named `PROJECT_ISSUES_PAT`.
- If you add a new workflow, document its trigger and purpose here so the folder stays easy to maintain.
