---
title: Add new year to events page
labels: Events
---

Each year, a new listing for Past events needs to be added to the Events page here:

https://github.com/lmu-osc/lmu-osc.github.io/blob/main/events/index.qmd

The code that needs to be added looks like this:

```yaml
listing:
  - id: upcoming-events
    template: upcoming-events-template.ejs
    contents: events/
    sort-ui: [title, date]
    sort: "date desc"
    filter-ui: true
    page-size: 999
    categories: unnumbered
  - id: year_2025
    contents: events/ 
    sort: "date desc"
    page-size: 999
    template: past-events-template.ejs
    template-params:
      year: 2025
  - id: year_2024
    contents: events/ 
    sort: "date desc"
    page-size: 999
    template: past-events-template.ejs
    template-params:
        year: 2024
...
```

Simply insert another chunk of this code with updated years:

```yaml
  - id: year_2024
    contents: events/ 
    sort: "date desc"
    page-size: 999
    template: past-events-template.ejs
    template-params:
        year: 2024
```

And then updated the page below to look like this:

```
## Past Events

### New year here

::: {#year_YYYY}
:::

...
```