import { WindowName } from "../../main";

const systemtray = await Service.import("systemtray");

const SysTrayItem = (item) =>
  Widget.Button({
    className: "systray-item",
    child: Widget.Icon().bind("icon", item, "icon"),
    tooltipMarkup: item.bind("tooltip_markup"),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
  });

const SysTrayComponent = () => {
  return Widget.Box({
    children: systemtray.bind("items").as((i) => i.map(SysTrayItem)),
  });
};

export function Systray() {
  const name = WindowName.Systray;

  const systray = Widget.Box({
    className: "systray",
    hexpand: true,
    spacing: 16,
    child: SysTrayComponent(),
  });

  return Widget.Window({
    name,
    anchor: ["top", "right"],
    setup: (self) =>
      self.keybind("Escape", () => {
        App.closeWindow(name);
      }),
    visible: false,
    keymode: "exclusive",
    child: systray,
  });
}
