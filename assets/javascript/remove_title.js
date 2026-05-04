// This script removes the title from the title banner on the index page. It is a one-off
// solution to hide the title without affecting other pages.

document.addEventListener("DOMContentLoaded", function () {
  // Try multiple selectors to find the title
  const selectors = [
    "div.quarto-title-banner h1.title",
  ];
  
  let title = null;
  for (const selector of selectors) {
    title = document.querySelector(selector);
    if (title) {
      console.log("Found title with selector:", selector);
      break;
    }
  }

  if (title) {
    title.remove();
    console.log("Title removed successfully");
  } else {
    console.log("Title element not found");
  }
});
