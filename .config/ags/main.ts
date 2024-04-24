import { Launcher } from "./components/launcher/launcher";
import { QuickSettings } from "./components/quick-settings/quick-settings";
import { PowerMenu } from "./components/powermenu/powermenu";
import { Bar } from "./components/bar/bar";
import { Systray } from "./components/systray/systray";

// main scss file
const scss = `${App.configDir}/scss/style.scss`;

// target css file
const css = `/tmp/style.css`;

Utils.exec(`sassc ${scss} ${css}`);

App.config({
  style: css,
  windows: [Launcher(0), QuickSettings(0), PowerMenu(0), Bar(0), Systray(0)],
});

Utils.monitorFile(`${App.configDir}/scss`, function () {
  Utils.exec(`sassc ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
});
