import { Launcher } from "./components/launcher/launcher";
import { QuickSettings } from "./components/quick-settings/quick-settings";
import { PowerMenu } from "./components/powermenu/powermenu";
import { Bar } from "./components/bar/bar";
import { Systray } from "./components/systray/systray";
import { forMonitors } from "./lib/utils";

// main scss file
const scss = `${App.configDir}/scss/style.scss`;

// target css file
const css = `/tmp/style.css`;

Utils.exec(`sassc ${scss} ${css}`);

export enum WindowName {
  Launcher = "launcher",
  QuickSettings = "quick-settings",
  PowerMenu = "powermenu",
  Bar = "bar",
  Systray = "systray",
}

App.config({
  style: css,
  windows: [
    Launcher(),
    QuickSettings(),
    PowerMenu(),
    Systray(),
    ...forMonitors(Bar),
  ],
});

Utils.monitorFile(`${App.configDir}/scss`, function () {
  Utils.exec(`sassc ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
});
