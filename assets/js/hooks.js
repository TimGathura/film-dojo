// assets/js/hooks.js
import ScrollHook from "./scroll_hook"
import InfiniteScrollHook from "./infinite_scroll_hook";


let Hooks = {
  Scroll: ScrollHook,
  InfiniteScroll: InfiniteScrollHook,
}

Hooks.ChunkedUpload = {
  mounted() {
    ChunkedUploader.init(this.el, this.pushEvent.bind(this))
  }
}

export default Hooks;