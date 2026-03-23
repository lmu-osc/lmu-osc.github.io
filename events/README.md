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


# Creating Events

To create a new event item, start by copying an existing file in `events/events/` (preferably a recent one with similar structure) and saving it with a new filename in the same folder.

Use this naming convention:

- `YYYY-MM-DD-short-slug.qmd`

The main fields that drive the Events listing cards are in front matter. A minimal pattern looks like this:

```yaml
title: "Event title"
date: YYYY-MM-DD # NOTE: this appears as the Published Date
categories:
  - Workshop

event:
  start_date: "2026-03-11"
  end_date: "2026-03-12"   # optional
  description: "Short card description shown on /events"
  time: "09:00-17:00"
  location:
    name: "Venue name"
    address: "Street, City"
    map_url: "https://maps.example.org/..."
  format:
    type: "In-Person"
    detail: ""               # optional
  language:
    primary: "English"
    primary-code: "en"
    detail: ""               # optional

event_description: |
  Longer overview text for the event detail page. That is, the content here displays on the event page.

...
```

For the event detail page itself, use `event_description` for the longer overview content and fill optional people/contact blocks (`presenters`, `instructors`, `helpers`, `organizers`, `host`, `contact`) as needed.

Keep `template` and `filters` as shown above so page rendering stays consistent.

Date handling is most reliable when `event.start_date` and `event.end_date` are written in ISO format (`YYYY-MM-DD`). The listing templates then place items in Upcoming or Past sections automatically based on those dates.

After adding or editing an event, run `quarto preview` from the repository root and check both the event detail page and the `/events` listing page.

## Adding Contact, Organizers, Etc.

Use list-based YAML blocks for people fields. A practical pattern is:

```yaml
organizers:
  - name: "Organizer Name"
    url: "https://example.org/profile"
    # note that you can add N people by using the yaml list syntax, i.e. the `-` separator for the name and the url just below
  - name: "Organizer Name Two"
    url: "https://example.org/profile"

presenters:
  - name: "Presenter Name"
    url: "https://example.org/profile"
    affiliation: "Optional affiliation"

instructors:
  - name: "Instructor Name"
    url: "https://example.org/profile"

helpers:
  - name: "Helper Name"
    url: "https://example.org/profile"

host:
  - name: "Host Name"
    url: "https://example.org/profile"

# the contact field only supports inclusion of one contact point. prefer organization emails when available
contact:
  name: "Contact Person or Team"
  email: "contact@example.org"
```

Field reference by entity:

1. `organizers`: supports `name` (required for display) and optional `url`.
2. `presenters`: supports `name`, optional `url`, and optional `affiliation`.
3. `instructors`: supports `name` and optional `url`.
4. `helpers`: supports `name` and optional `url`.
5. `host`: supports `name` and optional `url`.
6. `contact`: supports `name` and `email`.

Conventions:

1. Prefer full names in `name` so cards and detail pages are readable.
2. Use full URLs including `https://` when possible.
3. URLs should generally point to the person's OSC page, LMU page, or personal site.
4. If `url` is omitted, the name still renders as plain text.
5. For `contact`, include both `name` and `email` if you want a linked contact line.

Rendering notes:

1. On the events listing page, names from `organizers`, `presenters`, `instructors`, `helpers`, and `host` can appear on cards.
2. On event detail pages, `url` values are used to make names clickable.
3. The contact section appears when `contact.name` is provided; `contact.email` adds a mailto link.

Only include real entries and omit placeholders. Empty person entries are typically filtered out, but keeping files clean makes maintenance easier.

