
document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.quarto-listing-category-title').forEach(function(el){
    el.textContent = 'Faculty';
    el.setAttribute('aria-label','Faculty'); // ensures AT reads it
  });
});