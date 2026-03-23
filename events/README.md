# Events Section

This folder controls the top-level Events page: layout, section rendering, and section-specific styling.

## Key Files

The page structure is defined in `index.qmd`. It creates listing blocks for Upcoming Events and Past Events by year.

Rendering for those blocks is handled by:

- `upcoming-events-template.ejs`
- `past-events-template.ejs`

Styling is handled by:

- `upcoming-events-styles.css`
- `past-events-styles.css`

Section-level Quarto defaults are in `_metadata.yml`.

## How It Fits Together

`index.qmd` defines the listing IDs and points each listing to an EJS template. The templates are responsible for filtering/sorting behavior and card markup. The CSS files then style each section separately.

## Maintenance Workflow

When you make changes in this folder:

1. Update `index.qmd`, template files, or CSS files as needed.
2. Run `quarto preview` from the repository root.
3. Verify `/events`:
	- Upcoming list renders correctly
	- Year sections render in the expected order
	- Card spacing, labels, and links look correct


