import { Excalidraw, MainMenu } from "@excalidraw/excalidraw";
import { StrictMode, useCallback, useEffect, useState } from "react";
import { createRoot } from "react-dom/client";

const debounce = (func, delay) => {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => {
      func(...args);
    }, delay);
  };
};

function Component({ canvas, pushEvent }) {
  const [excalidrawAPI, setExcalidrawAPI] = useState(null);

  const UIOptions = {
    canvasActions: {
      changeViewBackgroundColor: false,
      clearCanvas: false,
      export: false,
      loadScene: false,
      saveToActiveFile: false,
      toggleTheme: false,
      saveAsImage: false,
    },
  };

  const handleChange = useCallback(
    (elements, appState) => {
      pushEvent("save", {
        type: "excalidraw",
        version: 2,
        source: "notebook",
        elements,
        appState,
      });
    },
    [pushEvent],
  );

  const debouncedHandleChange = useCallback(debounce(handleChange, 500), [
    handleChange,
  ]);

  return (
    <Excalidraw
      UIOptions={UIOptions}
      initialData={canvas}
      onChange={debouncedHandleChange}
      excalidrawAPI={(api) => setExcalidrawAPI(api)}
    >
      <MainMenu></MainMenu>
    </Excalidraw>
  );
}

export const ExcalidrawHook = {
  parseCanvas({ canvas = {}, theme } = {}) {
    const data = JSON.parse(canvas);
    return {
      ...data,
      "appState":{
        ...data.appState,
        "collaborators": [],
        "viewBackgroundColor": "transparent",
        "theme": theme
      }
    }
  },
  mounted() {
    const canvas = this.parseCanvas(this.el.dataset);

    this._root = createRoot(this.el);
    this._root.render(
      <StrictMode>
        <Component
          canvas={canvas}
          pushEvent={this.pushEvent.bind(this)}
        />
      </StrictMode>,
    );
  },
  updated() {
    this.mounted();
  }
};
