# News Section

This folder controls the top-level News page: listing behavior, article defaults, and News article rendering.

## Key Files

The page structure is defined in `index.qmd`. It creates the News listing table and category filters.

Section-level Quarto defaults for News articles are in `_metadata.yml`.

Per-article rendering is handled by the files in `news/templates/`:

- `news-template.html`
- `process-news-yaml.lua`

Article source files live in `news/` and follow date-based filenames.

## How It Fits Together

`index.qmd` defines the listing configuration (`contents: news`) and controls sorting/fields for the `/news` page.

`_metadata.yml` applies defaults to News articles in this section (for example page navigation and sidebar behavior).

Each News article is a `.qmd` file in `news/` with YAML front matter plus content body. For consistent article rendering, each file should include the shared template and Lua filter in its front matter.

The Lua filter (`process-news-yaml.lua`) preprocesses selected metadata before the HTML template (`news-template.html`) renders the page. At the time of creating this, it is only used to process the `flyer:` field, but can be expanded to other yaml values as needed.

## Maintenance Workflow

When you make changes in this folder:

1. Update `index.qmd`, `_metadata.yml`, or files in `news/templates/` as needed.
2. Run `quarto preview` from the repository root.
3. Verify `/news`:
   - Listing table renders correctly.
   - Date order is descending.
   - Categories filter behaves as expected.
4. Open one or more article pages and confirm template-level rendering still works (including optional flyer preview when used).

# Creating News Items

To create a new News item, add a new `.qmd` file in `news/news/`.

Use this naming convention:

- `YYYY-MM-DD-short-slug.qmd`

A practical YAML front matter pattern is:

```yaml
title: "News title"
date: YYYY-MM-DD
categories: ["Announcements"]
description: "Short summary used in metadata and previews."

# optional: supports single path or list syntax
flyer:
  - file: "assets/example-flyer.pdf"
    title: "Optional flyer label"

template: templates/news-template.html
filters:
  - templates/process-news-yaml.lua
```

After the front matter, add the article body in markdown or HTML as needed.

## Flyers in News

The `flyer` field is optional and can be written either as a single path or as a list. If list syntax is used, only the first entry is currently used.

Each flyer entry may include:

1. `file`: path to image/PDF flyer asset.
2. `title`: optional label used in flyer preview UI.

The Lua filter normalizes this field into `flyer_data`, which is then consumed by `news-template.html` and `assets/javascript/flyer_preview.js`.

## Conventions

1. Keep `date` in ISO format (`YYYY-MM-DD`) for predictable sorting.
2. Keep filenames and slugs lowercase and hyphenated.
3. Use concise `description` text for metadata clarity.
4. Keep `template` and `filters` in all News items to ensure consistent rendering.
5. Use relative flyer paths from the article location.

After adding or editing a News item, run `quarto preview` from the repository root and check both the `/news` listing page and the article detail page.
