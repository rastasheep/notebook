import { Excalidraw as ed } from "@excalidraw/excalidraw";
import { createElement } from 'react';
import { createRoot } from 'react-dom/client';

export const Excalidraw = {
  mounted(args) {
    console.log('hi', this)
    createRoot(this.el).render(createElement(ed))
  }
}
