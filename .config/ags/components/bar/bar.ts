import Keyboard from "./widgets/keyboard.js";
import Logo from "./widgets/logo.js";
import { TrayButton } from "./widgets/systray.js";
import Indicator from "./widgets/indicator.js";
import Workspaces from "./widgets/workspaces.js";

export function Bar(monitor: number = 0) {
  const name = `bar-${monitor}`;

  const bar = Widget.Box({
    className: "bar",
    hexpand: true,
    spacing: 16,
    child: Widget.CenterBox({
      startWidget: Widget.Box({
        spacing: 12,
        hexpand: true,
        children: [Logo(monitor), Workspaces()],
      }),
      centerWidget: Widget.Box({
        hexpand: true,
      }),
      endWidget: Widget.Box({
        hexpand: true,
        hpack: "end",
        children: [TrayButton(monitor), Keyboard(), Indicator(monitor)],
      }),
    }),
  });

  return Widget.Window({
    monitor,
    name,
    anchor: ["top", "left", "right"],
    visible: true,
    exclusivity: "exclusive",
    child: bar,
  });
}
