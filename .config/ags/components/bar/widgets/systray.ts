import { WindowName } from "../../../main";

export const TrayButton = () =>
  Widget.Button({
    className: "tray-button",
    onClicked: () => {
      App.toggleWindow(WindowName.Systray);
    },
    child: Widget.Label({
      label: "",
    }),
  });
