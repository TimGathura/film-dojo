let ScrollHook = {
  mounted() {
    this.setupScrolling();
    this.handleEvent("movie-selected", () => {
      setTimeout(() => this.setupScrolling(), 100);
    });
  },

  updated() {
    this.setupScrolling();
  },

  setupScrolling() {
    this.scrollLeftButton = this.el.querySelector("#scroll-left");
    this.scrollRightButton = this.el.querySelector("#scroll-right");
    this.carousel = this.el.querySelector("#movie-carousel");

    if (this.scrollLeftButton && this.scrollRightButton && this.carousel) {
      this.updateButtonVisibility();

      this.scrollLeftButton.addEventListener("click", () => this.scroll(-200));
      this.scrollRightButton.addEventListener("click", () => this.scroll(200));

      this.carousel.addEventListener("scroll", () => this.updateButtonVisibility());

      // Force a check after a short delay to ensure content has rendered
      setTimeout(() => this.updateButtonVisibility(), 100);
    }
  },

  scroll(amount) {
    this.carousel.scrollBy({ left: amount, behavior: "smooth" });
  },

  updateButtonVisibility() {
    if (!this.carousel || !this.scrollLeftButton || !this.scrollRightButton) return;

    const isAtStart = this.carousel.scrollLeft === 0;
    const isAtEnd = this.carousel.scrollLeft + this.carousel.clientWidth >= this.carousel.scrollWidth;

    this.scrollLeftButton.classList.toggle("hidden", isAtStart);
    this.scrollRightButton.classList.toggle("hidden", isAtEnd);
  }
};

export default ScrollHook;