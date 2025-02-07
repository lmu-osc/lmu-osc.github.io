function addButtonAndLink() {
  // Find the target div by class name
  const targetDiv = document.querySelector('.quarto-listing-category.category-unnumbered');

  // Create a new div to insert
  const newDiv = document.createElement('div');
  
  // Add a margin-top to the div to give space above the button
  // newDiv.style.marginTop = '20px';  // Adjust this value to change the space above
  newDiv.classList.add('mt-3'); // Adds margin-top with a Bootstrap class


  // Create a new button inside the div with Bootstrap classes
  const button = document.createElement('button');
  button.classList.add('btn', 'btn-primary');  // Add Bootstrap button styles
  button.innerHTML = 'Clear Filter';

  // Add an event listener to the button to simulate a click on the h5 when clicked
  button.addEventListener('click', function() {
    const targetH5 = document.querySelector('.quarto-listing-category-title');
    if (targetH5) {
      targetH5.click(); // Simulate a click on the h5
    }
  });

  // Append the button to the new div
  newDiv.appendChild(button);

  // Insert the new div after the target div
  if (targetDiv) {
    targetDiv.insertAdjacentElement('afterend', newDiv);
  }
}

// Wait for the DOM content to load and then execute the function
document.addEventListener('DOMContentLoaded', addButtonAndLink);
