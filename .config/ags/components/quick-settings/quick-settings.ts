import Network from "./widgets/network";
import Bluetooth from "./widgets/bluetooth";
import Avatar from "./widgets/avatar";
import DateTime from "./widgets/dateTime";
import SignOut from "./widgets/signOut";
import { Volume } from "./widgets/volume";
import Gtk from "../../types/@girs/gtk-3.0/gtk-3.0";

export const QuickSettings = (monitor: number = 0) => {
  const name = `quick-settings-${monitor}`;

  const quickSettings = Widget.Box({
    className: "quick-settings",
    vertical: true,
    spacing: 16,
    children: [Header(), Row([Network(), Bluetooth()]), Volume()],
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
    child: quickSettings,
  });
};

const Header = () => {
  return Widget.Box({
    className: "header",
    children: [
      Widget.Box({ hexpand: true, children: [Avatar(), SignOut()] }),
      DateTime(),
    ],
  });
};

const Row = (children: Array<Gtk.Widget> = []) => {
  return Widget.Box({
    homogeneous: true,
    spacing: 8,
    className: "row",
    children,
  });
};
