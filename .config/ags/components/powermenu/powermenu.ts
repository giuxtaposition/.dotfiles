import { WindowName } from "../../main";
import { SysButton } from "./widgets/sys-button";

export const PowerMenu = () => {
  const name = WindowName.PowerMenu;

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
