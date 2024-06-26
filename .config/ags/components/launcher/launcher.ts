import { WindowName } from "../../main";
import { LauncherItem } from "./widgets/launcher-item";

const { query } = await Service.import("applications");

export const Launcher = () => {
  const windowName = WindowName.Launcher;
  const width = 400;
  const height = 400;
  const spacing = 12;

  let applications = query("").map(LauncherItem);

  const list = Widget.Box({
    vertical: true,
    children: applications,
    spacing,
  });

  // repopulate the box, so the most frequent apps are on top of the list
  function repopulate() {
    applications = query("").map(LauncherItem);
    list.children = applications;
  }

  const search = Widget.Entry({
    hexpand: true,
    // to launch the first item on Enter
    on_accept: () => {
      // make sure we only consider visible (searched for) applications
      const results = applications.filter((item) => item.visible);

      if (results[0]) {
        results[0].attribute.app.launch();
        App.toggleWindow(windowName);
      }
    },

    // filter out the list
    on_change: ({ text }) =>
      applications.forEach((item) => {
        item.visible = item.attribute.app.match(text ?? "");
      }),
  });

  const searchIcon = Widget.Icon({
    icon: "system-search",
    size: 30,
  });

  const searchBar = Widget.Box({
    hexpand: true,
    className: "search",
    css: `margin-bottom: ${spacing}px;`,
    children: [searchIcon, search],
  });

  const launcher = Widget.Box({
    vertical: true,
    className: "launcher",
    children: [
      searchBar,

      Widget.Scrollable({
        hscroll: "never",
        css: `min-width: ${width}px;` + `min-height: ${height}px;`,
        child: list,
      }),
    ],
    setup: (self) =>
      self.hook(App, (_, windowName, visible) => {
        if (windowName !== windowName) return;

        // when the applauncher shows up
        if (visible) {
          repopulate();
          search.text = "";
          search.grab_focus();
        }
      }),
  });

  return Widget.Window({
    name: windowName,
    anchor: ["top", "left"],
    setup: (self) =>
      self.keybind("Escape", () => {
        App.closeWindow(windowName);
      }),
    visible: false,
    keymode: "exclusive",
    child: launcher,
  });
};
