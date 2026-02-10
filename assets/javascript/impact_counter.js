document.addEventListener("DOMContentLoaded", () => {
  const counters = document.querySelectorAll(".metric-value");

  const animateCounter = (el) => {
    const rawTarget = el.dataset.target;      // e.g., "100+" or "50k"
    const match = rawTarget.match(/^(\d+)(\D*)$/); // separate number and suffix
    if (!match) return;                        // invalid format

    const target = Number(match[1]);           // numeric part
    const suffix = match[2] || "";             // suffix part (e.g., "+", "k")
    let current = 0;
    const duration = 1200;
    const startTime = performance.now();

    const update = (now) => {
      const progress = Math.min((now - startTime) / duration, 1);
      const value = Math.floor(progress * target);
      el.textContent = value + suffix;

      if (progress < 1) {
        requestAnimationFrame(update);
      } else {
        el.textContent = target + suffix;
      }
    };

    requestAnimationFrame(update);
  };

  const observer = new IntersectionObserver(
    (entries, obs) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          animateCounter(entry.target);
          obs.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.6 }
  );

  counters.forEach(counter => observer.observe(counter));
});
