document.addEventListener('DOMContentLoaded', function () {
  function openAccordionForHash() {
    var hash = window.location.hash;
    if (!hash) return;

    var target = document.querySelector(hash);
    if (!target) return;

    var accordionHeader = target.classList.contains('accordion-header')
      ? target
      : target.closest('.accordion-header');
    if (!accordionHeader) return;

    var accordionItem = accordionHeader.closest('.accordion-item');
    if (!accordionItem) return;

    var collapse = accordionItem.querySelector('.accordion-collapse');
    if (!collapse || !window.bootstrap || !window.bootstrap.Collapse) return;

    if (!collapse.classList.contains('show')) {
      collapse.addEventListener('shown.bs.collapse', function onShown() {
        target.scrollIntoView({ block: 'start', behavior: 'auto' });
      }, { once: true });
      window.bootstrap.Collapse.getOrCreateInstance(collapse, { toggle: false }).show();
      return;
    }

    target.scrollIntoView({ block: 'start', behavior: 'auto' });
  }

  openAccordionForHash();
  window.addEventListener('hashchange', openAccordionForHash);
});
