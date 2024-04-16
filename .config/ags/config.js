import { applauncher } from "./components/applauncher.js";

App.config({
  windows: [applauncher],
});

Utils.monitorFile(
  // directory that contains the scss files
  `${App.configDir}/style`,

  // reload function
  function () {
    // main scss file
    const scss = `${App.configDir}/style.scss`;

    // target css file
    const css = `/tmp/my-style.css`;

    // compile, reset, apply
    Utils.exec(`sassc ${scss} ${css}`);
    App.resetCss();
    App.applyCss(css);
  },
);
