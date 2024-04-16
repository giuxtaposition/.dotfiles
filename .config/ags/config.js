import { Launcher } from "./components/launcher/launcher.js";

// main scss file
const scss = `${App.configDir}/scss/style.scss`;

// target css file
const css = `/tmp/style.css`;

Utils.exec(`sassc ${scss} ${css}`);

App.config({
  style: css,
  windows: [Launcher(0)],
});

Utils.monitorFile(`${App.configDir}/scss`, function () {
  // compile, reset, apply
  Utils.exec(`sassc ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
});
