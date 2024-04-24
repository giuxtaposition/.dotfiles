const systemtray = await Service.import("systemtray");

const SysTrayItem = (item) =>
  Widget.Button({
    className: "systray-item",
    child: Widget.Icon().bind("icon", item, "icon"),
    tooltipMarkup: item.bind("tooltip_markup"),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
  });

const SysTrayComponent = (monitor: number = 0) => {
  return Widget.Box({
    children: systemtray.bind("items").as((i) => i.map(SysTrayItem)),
  });
};

export function Systray(monitor = 0) {
  const name = `systray-${monitor}`;

  const systray = Widget.Box({
    className: "systray",
    hexpand: true,
    spacing: 16,
    child: SysTrayComponent(monitor),
  });

  return Widget.Window({
    monitor,
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
