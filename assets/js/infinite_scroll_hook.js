const InfiniteScrollHook = {
    mounted() {
      this.setupScroll();
    },
  
    updated() {
      this.setupScroll();
    },
  
    setupScroll() {
      this.carousel = this.el.querySelector("#movie-carousel");
      this.movieCards = Array.from(this.carousel.querySelectorAll(".movie-card"));
      this.cardWidth = this.movieCards[0].offsetWidth;
      this.visibleCount = Math.ceil(this.el.offsetWidth / this.cardWidth);
  
      this.el.querySelector("#scroll-left").addEventListener("click", () => this.scroll(-1));
      this.el.querySelector("#scroll-right").addEventListener("click", () => this.scroll(1));
  
      this.currentIndex = 0;
      this.updateCarousel();
    },
  
    scroll(direction) {
      this.currentIndex = (this.currentIndex + direction + this.movieCards.length) % this.movieCards.length;
      this.updateCarousel();
    },
  
    updateCarousel() {
      const totalCards = this.movieCards.length;
      const newOrder = [];
  
      for (let i = 0; i < totalCards; i++) {
        const index = (this.currentIndex + i) % totalCards;
        newOrder.push(this.movieCards[index]);
      }
  
      newOrder.forEach((card, index) => {
        card.style.order = index;
        card.style.transform = `translateX(${-this.currentIndex * this.cardWidth}px)`;
      });
  
      // Update visibility
      newOrder.forEach((card, index) => {
        if (index < this.visibleCount + 1) {
          card.style.visibility = 'visible';
          card.style.opacity = '1';
        } else {
          card.style.visibility = 'hidden';
          card.style.opacity = '0';
        }
      });
    }
  };
  
  export default InfiniteScrollHook;