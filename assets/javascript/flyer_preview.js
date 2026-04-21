const FLYER_STYLE_ID = "flyer-preview-styles";

function injectFlyerStyles() {
  if (document.getElementById(FLYER_STYLE_ID)) {
    return;
  }

  const style = document.createElement("style");
  style.id = FLYER_STYLE_ID;
  style.textContent = `
    .flyer-wrapper {
      width: min(80%, 1000px);
      margin: 0 auto;
      text-align: center;
    }

    .flyer-preview {
      margin-bottom: 10px;
    }

    .flyer-media {
      display: block;
      width: 100%;
      max-width: 80%;
      margin: 0 auto;
      max-height: 70vh;
      object-fit: contain;
      border: 2px solid #000;
      border-radius: 10px;
      background: #fff;
    }

    .flyer-pdf {
      height: 420px;
    }

    .flyer-unsupported {
      padding: 1rem;
      background: #eee;
      border: 2px solid #000;
      border-radius: 10px;
    }

    .flyer-link {
      display: inline-flex;
      align-items: center;
      gap: 0.45rem;
      padding: 0.6rem 1rem;
      border: 2px solid #000;
      border-radius: 999px;
      text-decoration: none;
      color: #111;
      background: #f7f7f7;
      font-weight: 700;
      letter-spacing: 0.01em;
      box-shadow: 0 2px 0 #000;
      transition: transform 0.15s ease, box-shadow 0.15s ease, background-color 0.15s ease;
    }

    .flyer-link:hover,
    .flyer-link:focus-visible {
      transform: translateY(-1px);
      box-shadow: 0 3px 0 #000;
      background-color: #fff;
      color: #111;
      text-decoration: none;
    }
  `;

  document.head.appendChild(style);
}

document.addEventListener("DOMContentLoaded", () => {
  const flyers = document.querySelectorAll(".flyer[data-src]");
  if (!flyers.length) {
    return;
  }

  injectFlyerStyles();

  flyers.forEach((container) => {
    const src = container.dataset.src;
    if (!src) {
      return;
    }

    const flyerLabel = (
      container.dataset.label ||
      container.dataset.title ||
      container.dataset.alt ||
      "Flyer preview"
    ).trim();

    const ext = src.split(".").pop().toLowerCase();
    let preview = "";

    if (["jpg", "jpeg", "png", "webp", "gif"].includes(ext)) {
      preview = `<img src="${src}" loading="lazy" class="flyer-media" alt="${flyerLabel}" />`;
    } else if (ext === "pdf") {
      preview = `<iframe src="${src}" loading="lazy" class="flyer-media flyer-pdf" title="${flyerLabel}"></iframe>`;
    } else {
      preview = '<div class="flyer-unsupported">Preview not available</div>';
    }

    container.innerHTML = `
      <div class="flyer-wrapper">
        <div class="flyer-preview">${preview}</div>
        <a href="${src}" target="_blank" rel="noopener noreferrer" class="flyer-link" title="${flyerLabel}">
          Open Full Flyer ↗
        </a>
      </div>
    `;
  });
});
