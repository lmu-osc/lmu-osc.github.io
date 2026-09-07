(function () {
          function equalizeCards(selector) {
            var cards = Array.prototype.slice.call(document.querySelectorAll(selector));

            if (!cards.length) return;

            // Reset previous heights before measuring
            cards.forEach(function (card) {card.style.minHeight = '';});

            // Find tallest card
            var maxHeight = 0;

            cards.forEach(function (card) {
              maxHeight = Math.max(
                maxHeight,
                card.getBoundingClientRect().height
              );
            });

            // Apply tallest height to all cards
            var heightPx = Math.ceil(maxHeight) + 'px';

            cards.forEach(function (card) {
              card.style.minHeight = heightPx;
            });
          }

          //same as previous logic: when the media width is greater than or equal to 992 (lg breakpoint bootstrap)i.e. when two sections are side by side,  each cards' height should stay same in both sections. When the screen gets smaller and the cards are stacked vertically, equalize or make the height of cards within each section the same height.

          function runEqualization() {

            window.requestAnimationFrame(function () {

              var isSideBySide =
                window.matchMedia('(min-width: 992px)').matches;

              if (isSideBySide) {

                // News + Events together
                equalizeCards(
                  '#newsCard > .card-body > .news-card, ' +
                  '#eventsCard > .card-body > .events-card'
                );

              } else {

                // Equalize each section independently
                equalizeCards(
                  '#newsCard > .card-body > .news-card'
                );

                equalizeCards(
                  '#eventsCard > .card-body > .events-card'
                );
              }

            });
          }


          document.addEventListener(
            'DOMContentLoaded',runEqualization
          );

          window.addEventListener(
            'load', runEqualization
          );

          window.addEventListener(
            'resize',runEqualization
          );

        })();