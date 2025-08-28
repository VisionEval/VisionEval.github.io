// This assumes that you're using Rouge; if not, update the selector
// It also assumes there is a one-to-one relationship between
// codeBlocks and copyCodeButtons on the current page.
const codeBlocks = document.querySelectorAll('.language-R.highlighter-rouge');
const copyCodeButtons = document.querySelectorAll('.copy-code-button');

copyCodeButtons.forEach((copyCodeButton, index) => {
        const code = codeBlocks[index].innerText; // just grabs the first one...

        copyCodeButton.addEventListener('click', () => {
    // Copy the code to the user's clipboard
                window.navigator.clipboard.writeText(code);

    // Update the button text visually
                const { innerText: originalText } = copyCodeButton;
                copyCodeButton.innerText = 'Copied!';

    // (Optional) Toggle a class for styling the button
                copyCodeButton.classList.add('copied');

    // After 2 seconds, reset the button to its initial UI
                setTimeout(() => {
                        copyCodeButton.innerText = originalText;
                        copyCodeButton.classList.remove('copied');
                }, 2000);
        });
});
