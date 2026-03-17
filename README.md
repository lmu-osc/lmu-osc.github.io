# LMU Open Science Center Website

TL;DR: Run these commands to download the project, and build the first time.

```bash
git clone git@github.com:lmu-osc/lmu-osc.github.io.git
R -e "renv::restore()"  
quarto preview
```

The `renv:restore()` and `quarto preview` processes will take a bit to run the first time so go brew a ☕.

## Overview

This repository contains the source for the LMU Open Science Center website.

The site is built with [Quarto](https://quarto.org/) as a multi-page website and combines hand-authored content, reusable templates, custom styling, and a small amount of automation for publishing and maintenance.

At a high level, this repository contains the public-facing OSC website content, the navigation and page structure across the main site sections, the reusable templates and styling that support them, and the automation used for publishing and lightweight repository checks.

## Tech Stack

The site is built with [Quarto](https://quarto.org/) and uses R with `renv` for reproducible dependency management. Content is primarily authored in YAML, Markdown, and `.qmd` files, with styling handled through SCSS and CSS. Deployment and repository checks are automated through GitHub Actions. The main Quarto configuration lives in `_quarto.yml`, rendered output is written to `_site/`, and Quarto caching is stored in `_freeze/`.

## Repository Structure

The most important top-level directories are:

- `about/`: About pages and organizational information
- `assets/`: shared images, JavaScript, Bootstrap, and Font Awesome assets
- `events/`: event pages, templates, and helper scripts
- `footer/`: footer markup and footer-specific styling
- `news/`: news pages and metadata
- `partners/`: partner and institutional member pages
- `people/`: people pages, profile data, and listing templates
- `training/`: training catalog, tutorials, and training-track content
- `scripts/`: helper scripts used during site maintenance
- `renv/`: project-local R environment management
- \*`_site/`: rendered website output
- \*`_freeze/`: Quarto execution cache

The main entry point for the site is `index.qmd`.

\* These files will appear locally, but do not and should not be on the GitHub repo.

## Content Organization

Most pages in the repository are written as `.qmd` files. Section folders typically contain a landing page such as `index.qmd`, individual content pages, and any templates, metadata files, stylesheets, or helper scripts that are specific to that section. Some areas have their own internal documentation or specialized workflows. For example, `people/` contains profile pages, listing templates, and its own README for the people-page data model, while `events/` and `news/` include helper scripts for creating, migrating, or transferring content. In general, source content should be edited in the section folders rather than in `_site/`.

## Local Development

### Prerequisites

To work on this site locally, you should have Quarto, R, the project dependencies restored via `renv`, and `curl` available on your system. An IDE such as RStudio or VS Code is helpful, but not required.

### Initial Setup

Clone the repository, open the project, and restore the R dependencies.

In R:

```r
renv::restore()
```

This project uses a project-local `renv` library so builds are reproducible across machines and CI.

### Previewing the Site

To preview the site locally, run:

```bash
quarto preview
```

This starts a local preview server so you can inspect changes before committing them. Quarto writes the rendered output to `_site/`.

### Notes on Styling

\*The Quarto configuration includes a pre-render step that downloads `lmu-osc-custom.scss` from the `lmu-osc/branding-resources` repository using `curl`. In practice, that means an internet connection is helpful when rendering from a clean checkout and that branding-related styling may be refreshed automatically during render. Additional local styles are defined in files such as `styles.css`, `custom-navbar.css`, and section-specific stylesheets.

\* This step has been slated for deprecation in [#536](https://github.com/lmu-osc/lmu-osc.github.io/issues/536)

## Contribution Guidance

When contributing to the site, edit source files such as `.qmd`, `.yml`, `.css`, and templates—not directly in `_site/`, which is rendered output and should not be treated as the source of truth. Changes made directly to `_site/` will not be reflected in the final published website.

Preview the affected pages locally using `quarto preview` before opening a pull request, and keep section-specific changes inside the relevant folder when possible. If working on structured sections such as `people/`, check whether that directory already has its own README or templates before inventing a new pattern.


## Deployment

On pushes to `main`, the `publish.yml` workflow restores dependencies, renders the site, and publishes to GitHub Pages. The repository also includes automated checks for links, profile naming conventions, and other maintenance tasks.




