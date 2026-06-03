document.addEventListener("DOMContentLoaded", function () {
  const input = document.getElementById("global-filter");
  const items = document.querySelectorAll(".search-item");

  input.addEventListener("input", function () {
    const q = this.value.toLowerCase().trim();

    items.forEach(el => {
      const name = el.dataset.name || "";
      const faculty = el.dataset.faculty || "";

      const match =
        name.includes(q) ||
        faculty.includes(q) ;

      el.style.display = match ? "" : "none";
    });
  });
});
