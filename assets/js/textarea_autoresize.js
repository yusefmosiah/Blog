function autoResize(textarea, maxHeight) {
    textarea.style.height = "auto";
    const newHeight = Math.min(textarea.scrollHeight, maxHeight);
    textarea.style.height = newHeight + "px";
}


document.addEventListener("DOMContentLoaded", function () {
    const textareas = document.querySelectorAll(".autoresize");

    textareas.forEach((textarea) => {
        const maxHeight = window.innerHeight * 0.42; // Set the maximum height to 42% of the viewport height
        autoResize(textarea, maxHeight);
        textarea.addEventListener("input", () => autoResize(textarea, maxHeight));
    });
});
