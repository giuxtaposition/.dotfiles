import { WindowName } from "../../../main";

const Logo = (monitor: number = 0) => {
  return Widget.Button({
    className: "logo",
    onClicked: () => {
      App.openWindow(`${WindowName.Launcher}-${monitor}`);
    },
    child: Widget.Label({
      label: "",
    }),
  });
};

export default Logo;
