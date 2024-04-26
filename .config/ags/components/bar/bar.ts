import Keyboard from "./widgets/keyboard";
import Logo from "./widgets/logo";
import { TrayButton } from "./widgets/systray";
import Indicator from "./widgets/indicator";
import Workspaces from "./widgets/workspaces";
import { WindowName } from "../../main";

export function Bar(monitor: number = 0) {
  const name = `${WindowName.Bar}-${monitor}`;

  const bar = Widget.Box({
    className: "bar",
    hexpand: true,
    spacing: 16,
    child: Widget.CenterBox({
      startWidget: Widget.Box({
        spacing: 12,
        hexpand: true,
        children: [Logo(), Workspaces()],
      }),
      centerWidget: Widget.Box({
        hexpand: true,
      }),
      endWidget: Widget.Box({
        hexpand: true,
        hpack: "end",
        children: [TrayButton(), Keyboard(), Indicator()],
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
