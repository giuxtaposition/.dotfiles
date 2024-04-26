import { WindowName } from "../../../main";

export const SysButton = (action: string, label: string, icon: string) =>
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

          App.closeWindow(WindowName.PowerMenu);
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
