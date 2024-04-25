import { WindowName } from "../../main";
import { SysButton } from "./widgets/sys-button";

export const PowerMenu = (monitor: number = 0) => {
  const name = `${WindowName.PowerMenu}-${monitor}`;

  const launcher = Widget.Box({
    className: "powermenu",
    children: [
      SysButton("poweroff", "Power off", "", monitor),
      SysButton("reboot", "Reboot", "󰜉", monitor),
      SysButton("lock", "Lock", "", monitor),
      SysButton("suspend", "Suspend", "󰤄", monitor),
      SysButton("signout", "Sign out", "󰗼", monitor),
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
};
