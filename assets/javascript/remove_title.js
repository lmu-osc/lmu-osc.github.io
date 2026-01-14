// This script removes the title from the title banner on the index page. It is a one-off
// solution to hide the title without affecting other pages.

document.addEventListener("DOMContentLoaded", function () {
  const title = document.querySelector(
    "div.quarto-title-banner.page-columns.page-full div.quarto-title.column-body h1.title"
  );

  if (title) {
    title.remove();
  }
});
