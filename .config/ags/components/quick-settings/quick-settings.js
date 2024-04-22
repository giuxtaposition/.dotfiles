import Network from "./widgets/network.js";
import Bluetooth from "./widgets/bluetooth.js";
import Avatar from "./widgets/avatar.js";
import DateTime from "./widgets/dateTime.js";
import SignOut from "./widgets/signOut.js";
import { Volume } from "./widgets/volume.js";

export function QuickSettings(monitor = 0) {
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
}

const Header = () => {
  return Widget.Box({
    className: "header",
    children: [
      Widget.Box({ hexpand: true, children: [Avatar(), SignOut()] }),
      DateTime(),
    ],
  });
};

const Row = (children) => {
  return Widget.Box({
    homogeneous: true,
    spacing: 8,
    className: "row",
    children,
  });
};
