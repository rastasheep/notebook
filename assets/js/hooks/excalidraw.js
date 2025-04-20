import { StrictMode, useCallback, useEffect, useState } from "react";
import { createRoot } from "react-dom/client";

import { Tldraw, setUserPreferences } from 'tldraw'

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
  // const [excalidrawAPI, setExcalidrawAPI] = useState(null);

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

  setUserPreferences({ colorScheme: 'light', id: 'notebook' })

  return (
    <div style={{ position: 'fixed', inset: 0 }}>
			<Tldraw forceMobile options={{ maxPages: 1 }} 				onMount={(editor) => {
					editor.updateInstanceState({ isGridMode: true })

					// [1]
					editor.sideEffects.registerBeforeChangeHandler('instance', (prev, next) => {
						if (!next.isGridMode) {
							return prev
						}
						return next
					})
				}}/>
		</div>
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
