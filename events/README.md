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

To create a new event item, start by copying the [_event_template.qmd](events/_event_template.qmd) file and saving it with a new filename in the same folder.

Use this naming convention:

- `YYYY-MM-DD-short-slug.qmd`

The main fields that drive the Events listing cards are in the YAML front matter of that file, and include some guidance on how to fill-in a new event. Additional information is provided here:

```yaml
title: "Event title"
date: YYYY-MM-DD # NOTE: this appears as the Published Date
# choose one of the categories
categories: ['Discussion', 'Hacky Hour', 'ReproducibiliTea Journal Club', 'Workshop', 'Lecture', 'Symposium', 'Conference', 'Summer School', 'Panel Discussion Series', 'Application call'] 

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
  flyer:
    - file: images/example-flyer.pdf
      title: "Example event flyer"

event_description: |
  Longer overview text for the event detail page. That is, the content here displays on the event page.

...
# people section described below

template: templates/event-template.html
filters:
    - templates/process-event-yaml.lua
```

For the event detail page itself, use `event_description` for the longer overview content and fill optional flyer, people, and contact blocks (`flyer`, `presenters`, `instructors`, `helpers`, `organizers`, `host`, `contact`) as needed (described below).

Keep `template` and `filters` as shown above so page rendering stays consistent. The Lua filter processes some of the YAML variables, and all of the variables are then passed to the HTML template file, `templates/event-template.html` which creates a consistent look for all of the Events pages.

Date handling is most reliable when `event.start_date` and `event.end_date` are written in ISO format (`YYYY-MM-DD`). The listing templates then place items in Upcoming or Past sections automatically based on those dates.

Flyers can be written as a single path or as a list. If you use list syntax, only the first entry is used. Each flyer entry may include `file` and optional `title`. The detail page renders the flyer preview from `file`, and uses `title` as the label when available.

After adding or editing an event, run `quarto preview` from the repository root and check both the event detail page and the `/events` listing page.

## Adding Contact, Organizers, Etc.

Use list-based YAML blocks for people fields. A practical pattern is:

```yaml
# note that you can add N people by using the yaml list syntax, i.e. the `-` separator for the name and the url just below
organizers:
  - name: "Organizer Name"
    url: "https://example.org/profile"
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

Flyers use a similar list pattern when you need more than one item, although only the first flyer entry is currently rendered on the event page:

```yaml
event:
  flyer:
    - file: images/example-flyer.pdf
      title: "Example event flyer"
    - file: images/example-poster.pdf
      title: "Example event poster"
```

Field reference by entity:

1. `flyer`: supports a single path or a list of entries. Each entry may include `file` and optional `title`.
2. `organizers`: supports `name` (required for display) and optional `url`.
3. `presenters`: supports `name`, optional `url`, and optional `affiliation`.
4. `instructors`: supports `name` and optional `url`.
5. `helpers`: supports `name` and optional `url`.
6. `host`: supports `name` and optional `url`.
7. `contact`: supports `name` and `email`.

Conventions:

1. Prefer full names in `name` so cards and detail pages are readable.
2. Use full URLs including `https://` when possible.
3. URLs should generally point to the person's OSC page, LMU page, or personal site.
4. If `url` is omitted, the name still renders as plain text.
5. For `contact`, include both `name` and `email` if you want a linked contact line.

Rendering notes:

1. On the events listing page, names from `organizers`, `presenters`, `instructors`, `helpers`, and `host` can appear on cards.
2. On event detail pages, `url` values are used to make names clickable.
3. The flyer preview appears on the event detail page when `flyer` is provided.
4. The contact section appears when `contact.name` is provided; `contact.email` adds a mailto link.

Only include real entries and omit placeholders. Empty person entries are typically filtered out, but keeping files clean makes maintenance easier.

