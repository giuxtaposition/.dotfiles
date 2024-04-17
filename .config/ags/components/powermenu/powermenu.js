export function PowerMenu(monitor = 0) {
  const name = `powermenu-${monitor}`;

  const SysButton = (action, label, icon) =>
    Widget.Box({
      hexpand: true,
      vexpand: true,
      vertical: true,
      vpack: "center",
      className: "powermenu-entry",
      children: [
        Widget.Button({
          on_clicked: () => {
            const cmd = {
              poweroff: ["systemctl poweroff"],
              reboot: ["systemctl reboot"],
              lock: ["sleep 0.1 && swaylock"],
              suspend: ["sleep 0.1 && swaylock & systemctl suspend"],
              signout: ["swaymsg exit"],
            }[action];

            App.closeWindow(name);
            Utils.exec(`bash -c "${cmd}"`);
          },
          child: Widget.Box({
            vertical: true,
            className: "system-button",
            children: [
              Widget.Label({
                label: icon,
              }),
            ],
          }),
        }),
        Widget.Label({
          label: label,
          className: "label",
        }),
      ],
    });

  const launcher = Widget.Box({
    className: "powermenu",
    children: [
      SysButton("poweroff", "Power off", ""),
      SysButton("reboot", "Reboot", "󰜉"),
      SysButton("lock", "Lock", ""),
      SysButton("suspend", "Suspend", "󰤄"),
      SysButton("signout", "Sign out", "󰗼"),
    ],
  });

  return Widget.Window({
    monitor,
    name,
    setup: (self) =>
      self.keybind("Escape", () => {
        App.closeWindow(name);
      }),
    visible: false,
    keymode: "exclusive",
    child: launcher,
  });
}
