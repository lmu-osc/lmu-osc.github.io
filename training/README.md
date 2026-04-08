# Training Section

This folder contains the OSC training content and landing pages. It combines three user-facing tracks:

- Training Overview: entry page for the section
- Self-Learning Catalog: browseable tutorials grouped by topic
- Research Cycle Handbook and Educator Toolkit: dedicated long-form resources

The section is built with Quarto listings, category index pages, and tutorial metadata in YAML.

## High-Level Structure

```text
training/
├── README.md
├── _metadata.yml
├── training.css
├── index.qmd
├── self-learning.qmd
├── educator-toolkit.qmd
├── research-cycle-handbook.qmd
├── research-cycle-handbook/
├── images/
├── _template_tutorial_post.qmd
├── _template_embedded_video.qmd
├── data-management/
├── study-planning/
├── reproducible-processes/
├── publishing-outputs/
├── principles/
└── preregistration/
```

## How The Pages Fit Together

1. `index.qmd` is the section entry page.

It presents card links to:
- `self-learning.qmd`
- `research-cycle-handbook.qmd`
- `educator-toolkit.qmd`

2. `self-learning.qmd` is the catalog hub.

It defines two Quarto listings:
- `tutorial_categories` (grid): pulls `*/index.qmd` from each topic folder.
- `all_tutorials` (table): aggregates tutorial entries from topic files and topic YAML files.

3. Each topic folder (for example `data-management/`) has an `index.qmd`.

That file defines a local listing and typically reads from:
- topic `.qmd` tutorial pages in the folder
- a `*-tutorials.yaml` file for metadata-only entries

4. Tutorial detail pages are either:
- local `.qmd` pages in this repository (for example videos, lectures, or written pages), or
- external tutorials represented in `*-tutorials.yaml` with a `path` URL.

## How YAML Tutorial Files Are Used

Files like `data-management/data-management-tutorials.yaml` store list items with metadata such as:

- `title`
- `description`
- `image`
- `categories`
- `content_category`
- `within_cat_order`
- `path`
- `type`

Quarto reads these YAML records directly into listings.

In practice, this means:

- The YAML item appears in the topic page listing and in the global self-learning table.
- If a `path` is provided, the listing title links to that target.
- For external URLs, users are taken to that external tutorial page.

This is the main mechanism used to list self-paced tutorials that live outside this repository while still surfacing them in the OSC catalog.

Note: the `principles/principles-tutorials.yaml` file is currently empty, but is included for consistent structuring and in the event that more tutorials are added to that section later.

## Shared Dependencies In This Folder

- `_metadata.yml` applies section-wide defaults (shared CSS and layout defaults).
- `training.css` provides section-level styling.
- `images/` contains artwork used by cards and listing entries.
- `self-learning.qmd` includes `/assets/javascript/clear_filter_button.js` in the page header for listing filter UX.

## Authoring Patterns

Use the templates in this folder when creating new tutorial content:

- `_template_tutorial_post.qmd`: for redirect/link-style tutorial entries and standard metadata structure.
- `_template_embedded_video.qmd`: for embedded video/resource pages.

Most tutorial ordering is controlled by `within_cat_order`.
Category card ordering on `self-learning.qmd` is controlled by `tutorial-home-order` in each topic `index.qmd`.

## Maintenance Notes

- Keep metadata field names consistent across `.qmd` and YAML tutorial entries to ensure stable listings.
- Prefer adding external tutorials through topic `*-tutorials.yaml` files when there is no local content page.
- Use local `.qmd` files when OSC hosts explanatory content directly on this site.
- If a topic YAML file is intentionally excluded from the global table, document the reason inline in `self-learning.qmd` (as currently done for `principles`).
