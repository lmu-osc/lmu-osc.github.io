document.addEventListener('DOMContentLoaded', function() {
  const tooltip = document.createElement('div');
  tooltip.className = 'people-tooltip';
  document.body.appendChild(tooltip);

  document.querySelectorAll('.people-img-link').forEach(link => {
    link.addEventListener('mouseenter', e => {
      tooltip.textContent = link.getAttribute('data-title');
      tooltip.style.opacity = '1';
    });
    link.addEventListener('mousemove', e => {
      tooltip.style.left = (e.clientX + 16) + 'px';
      tooltip.style.top = (e.clientY + 8) + 'px';
    });
    link.addEventListener('mouseleave', e => {
      tooltip.style.opacity = '0';
    });
  });
});
