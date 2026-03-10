
# Folder Structure

The structure of the `people/` folder is as such:

```r
fs::dir_tree("people/", recurse=0)
people/
├── README.md
├── _metadata.yml
├── advisors.qmd
├── fellows.qmd
├── index.qmd
├── listings
├── management.qmd
├── members.qmd
├── people
├── people.css
├── scientific-board.qmd
└── staff.qmd
```

The `staff.qmd`, `scientific-board.qmd`, `members.qmd`, `management.qmd`, `fellows.qmd`, and `advisors.qmd` correspond to their respective pages on the website, and should be relatively straightforward to understand in this regard.

The `_metadata.yml` file applies defaults/presets to all contents of `people/` and its subdirectories. More specifically, it makes sure CSS specific to this part of the website is automatically applied, it sets the default page sizing, turns off the `toc` setting, and turns on the `freeze` feature.

The `listings` folder contains the `.ejs` templates used for different OSC membership types. The `people` subfolder contains all of profile pages for members, as well as the template files to create those pages. The next section will discuss these folders in more detail, and how they fit together.

# The `listings/` and `people/` Directories.

## EJS Files and `listings/`

The files in `people/listings/` are [Quarto listing templates](https://quarto.org/docs/websites/website-listings-custom.html) written in EJS. They control how collections of profile files are rendered on the section pages such as `staff.qmd`, `members.qmd`, `fellows.qmd`, `advisors.qmd`, `management.qmd`, and `scientific-board.qmd`.

Each section page defines one or more `listing:` entries in its YAML front matter. Those entries all point at `contents: people`, meaning Quarto reads the profile files in `people/people/` and passes their front matter fields into the relevant EJS template. The template then decides which records to display and how to format them.

In practice, the listing templates in this directory fall into a few categories:

- `active-*.ejs` templates render current members of a given role or group.
- `alumni-*.ejs` templates render former members of that role or group.
- `general-listing.ejs` is currently not used, but serves as a generic listing layout that could be adapted later.

The naming convention is important because it reflects how the corresponding section page is structured. For example:

- `staff.qmd` uses `active-staff-listing.ejs` and `alumni-staff-listing.ejs`.
- `members.qmd` uses separate templates for active LMU members, active affiliate members, and former members.
- `advisors.qmd` distinguishes between the advisory board, special advisors, and former advisory board members.

Most templates inspect the `memberships` field in each person profile and filter entries based on the membership `type` and `status`. This means the profile files are the single source of truth, while the listing templates determine which subset of profiles appears on which page.

As a consequence, when someone appears on the wrong page, the first things to check are usually:

1. Whether the person has the correct `memberships` entry in their profile file.
2. Whether the membership uses the expected `type` and `status` values.
3. Whether the relevant listing template is filtering for those exact values.

## People Profiles and `people/`

The `people/people/` directory contains one `.qmd` file per person. These files define the metadata for a person and, when rendered, also become that person's individual profile page.

In other words, each person file has two responsibilities at once:

1. It supplies structured metadata for the listing pages.
2. It provides the content for the standalone profile page.

Most of the useful information for listings lives in the YAML front matter. Important fields include:

- `title`, `academic_title`, `name`, `first_name`, and `surname` for display and sorting.
- `memberships`, which determines where a person appears across the different people pages.
- `photo`, `email`, `links`, and `social_media` for profile and card display.
- `personal`, which is the short preview text used on some listing cards.
- `mission_statement`, `research_interests`, and `publications` for the full profile page.

The `memberships` field is the most important part of the data model. It is a list because one person can belong to multiple OSC groups over time. For example, a person may simultaneously be active staff and an alumni fellow, or may have multiple historical roles recorded in the same file.

Each membership entry typically includes:

- `type`: the role or membership category, such as `staff`, `management`, `scientific board`, `advisory board`, `special advisor`, `fellow`, `lmu-individual`, or `affiliate`.
- `status`: usually `active` or `alumni`.
- `start` and optionally `end`: used to document the time span of the role.
- Optional role-specific metadata such as `position`, `faculty`, `affiliation`, `title`, or `notes`.

Because Quarto listings can sort by front matter fields, some profiles also define explicit sort helper variables such as `display_weight_staff` or `display_weight_management`. These are used when a section needs a custom ordering that is not purely alphabetical.

The `people/people/images/` directory stores the headshots referenced by the `photo` field. If no `photo` is supplied, the shared profile template falls back to a default image.

The `people/people/templates/` directory holds the reusable files that standardize how person pages are rendered. These are discussed in the next section.

### Lua Filter and HTML Template in `people/templates/`

All current profile files point to the shared template and Lua filter at the end of their YAML front matter:

```yaml
template: templates/people-template.html
filters:
	- templates/people_filter.lua
```

These two files handle a large part of the automation for individual profile pages.

The HTML template, `people/people/templates/people-template.html`, defines the overall page layout. It is responsible for:

- The profile header with photo, derived position, faculty/affiliation, contact links, and social icons.
- The mission statement section.
- Rendering any body content written below the YAML front matter.
- Optional research interests and selected publications sections.

The Lua filter, `people/people/templates/people_filter.lua`, preprocesses metadata before the HTML template sees it. In particular, it:

- Derives a best `position` and `faculty` value from the available memberships.
- Prioritizes active memberships over alumni memberships when choosing what to show on the profile page.
- Sorts `links` so certain labels such as `LMU Profile` and `Personal Website` appear in a consistent order.
- Transforms `social_media` entries into a format the HTML template can render as icon links.


The file `people/people/templates/_people_template.qmd` serves as a contributor template and reference document for creating a new person page. It documents the expected fields, provides example YAML, and notes where additional body content can be inserted.

## How the Pieces Fit Together

The rendering flow for this part of the site is:

1. A profile is defined in `people/people/<name>.qmd`.
2. The profile's YAML front matter stores the structured metadata used everywhere else.
3. The profile page itself is rendered through `templates/people-template.html` plus `templates/people_filter.lua`.
4. Section pages such as `staff.qmd` or `members.qmd` read the profile files through Quarto listings.
5. The matching EJS template filters and formats those profile records into cards or grouped lists.

That means a single update to a person's front matter can affect both their dedicated profile page and multiple overview pages at once.

## Practical Editing Notes

When adding a new person, the usual workflow is:

1. Copy `people/people/templates/_people_template.qmd` to a new file in `people/people/`.
2. Fill in the core identity fields and at least one valid `memberships` entry.
3. Add a `photo` file to `people/people/images/` if one is available.
4. Confirm that the membership `type` and `status` match the listing page where the person should appear.
5. Render or preview the site and verify both the standalone profile page and the relevant overview page.

Finally, note again that `_metadata.yml` applies shared styling and Quarto defaults throughout `people/`, so individual profile or section files generally only need to specify options that are unique to that page.

