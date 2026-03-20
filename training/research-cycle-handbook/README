# STRUCTURE OF THE HANDBOOK

Within the training folder, the landing page of the handbook is the file research-cycle-handbook.qmd.

Every other material for the handbook is in the folder training/research-cycle-handbook:
- assets contains e.g. checklists for readers to download as word documents, a lua function to remove unnecessary anchors to specific titles
- handbook-style.css for custom css (hero, pills, checklist, cards, internal link formatting)
- one qmd file per chapter

# WHAT IS THE STYLE OF WRITING?

I tried to be recipe-like, i.e. using the imperative form: 
- **Do this** because.
- **Do that** because.

When using a specialized term in a new chapter, I have used bold and underlining formatting and then defined that term in a callout information box repeating the bold and underlined formatting.

I’ve used callout tip boxes for tips to research groups (to develop SOPs).

I’ve used callout important note for important things to avoid.

I've only hyperlinked support services in otherwise plain text and did not add another kind of callout box to avoid too many types of formatting within the text. We could however consider adding a new row of cards for support services (not urgent).


# WHAT ARE THE TOOLS AND RESOURCES INCLUDED IN THE HANDBOOK?

- tools and tutorials of ours, or 
- essential tools we use in our own teaching (e.g. re3data, open policy finder), or 
- those that fill a gap in our current material but would be needed in our teaching (e.g. how to write an inform consent form)
- well established, discipline agnostic or interdisciplinary, maintained tools


# HOW TO ADD CARDS?

We've used Bootstrap structure and custom css to create a responsive card layout.
- The main .container div must always be present.
- Each section (Learn More / Tools & Resources) is wrapped in a .row.
- If one of the section is not needed, remove the entire .row block and its downstream .col divs.
- Each card should always be placed inside a .col div. Please put the html tags within html chunk to avoid any odd spacing issues.
- To add a new card, copy an existing .col block and edit the links, img, title, and text.
- Add as many .col blocks as needed within the .row, the cards are automatically laid out 3 cards per row and any additional cards will wrap to the next row.

template: 

::: {.container .my-4 }

<!-- row for Learn More section -->
<h4 class="fs-5"><i class="bi bi-mortarboard"></i> LEARN MORE</h4>
::: {.row .row-cols-1 .row-cols-md-2 .row-cols-lg-3 .g-4}

::: {.col}
<!-- card -->
:::

::: {.col}
<!-- card -->
:::
:::

<!-- row for Tools & Resources section -->
<h4 class="fs-5 mt-3"><i class="bi bi-tools"></i> TOOLS & RESOURCES</h4>
::: {.row .row-cols-1 .row-cols-md-2 .row-cols-lg-3 .g-4}

::: {.col}
<!-- card -->
:::

::: {.col}
<!-- card -->
:::
:::
:::



# HOW TO ADD CROSS-REFERENCES TO PAGES, SECTIONS, AND TABS OF THE HANDBOOK?

Note that:
- I want the text displayed to be [X.X.X. Title] which isn't native to quarto so I currently type that text manually.
- I want the internal cross reference links to be de-emphasize (we chose italic grey), so I currently use the custom css {.mark}
- titles of tabs in "::: {.panel-tabset}" aren't true markdown titles and therefore 
    - do not get applied the autonumbering so I currently number those titles by hand, and 
    - do not get assigned an anchor so I currently cross ref their container instead (which is good enough)

Examples of how I currently cross-ref:

- pages: see [3. Analyze & Collaborate](03-analyze-and-collaborate.qmd){.mark}

- sections: the section title needs to have a custom label e.g. "{#sec-study-design-analysis-plan}"
    - see [1.4. Study Design & Analysis Plan](#sec-study-design-analysis-plan){.mark} if in same page, or 
    - see [1.4. Study Design & Analysis Plan](01-plan-and-design.qmd#sec-study-design-analysis-plan){.mark} if on another page.

- tabs: see [1.4.1. Pre-analysis planning](#sec-study-design-analysis-plan){.mark} i.e. cross referencing their container instead.

Also note that I would prefer the annotation X.X. with the final dot (and this is how I wrote in manually for the text to be displayed), but this isn't native to quarto which writes X.X for autonumbered titles.


# HOW TO REMOVE ANCHOR?

Adding the class 'no-anchor' to html title remove their anchors, e.g.:

<h5 class="fs-5 no-anchor">Title</h5>

This is feature already provided by Quarto.


# HOW TO FORMAT LISTS AND CALLOUT BOXES OCCURRING BETWEEN SECTION TITLE AND panel-tabset IN orc-details-panel?

Riya and I are not sure why the bullet points or callout boxes are in the margin when a list is in this location. I suppose the orc-details-panel custom css should be adjusted - I do not know. 

Currently, to add a margin to lists in such location, I use:

::: {.ms-1} 
- item 1
- item 2
:::

Currently, to add a margin to callout boxes in such location, I use:

::: {.callout-note .mx-4}

:::

However, while this adds a margin, the border of the callout boxes stay 'exploded' including white spaces all around the header and text. If that could be fixed that would be nice. 


# HOW TO CUSTOMIZE CHAPTERS?

So far, the Hero, Pills, and Checklist and Download button for the checklist of Chapter 1 and 2 were customized using the following lines and associated custom css: 

<div class="orc-phase-hero-compact phase-2">
<div class="orc-hero-cycle phase-2">
<div class="orc-hero-pills phase-2">
<div class="orc-hero-checkpoint phase-2">

::: {.orc-gradient-box .collect-manage-checklist}
:::

::: {.d-flex .justify-content-center .mt-4 .orc-checklist-download .phase-2}

Chapter 4 was not yet customized. 
Chapter 3 need work to make a yellow-brown-ish tone background to white text accessible.

These lines were commented with e.g. <!-- RL still working on <div class="orc-phase-hero-compact phase-3"> --> in chapters 3 and 4 pages.

