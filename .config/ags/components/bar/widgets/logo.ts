import { WindowName } from "../../../main";

const Logo = () => {
  return Widget.Button({
    className: "logo",
    onClicked: () => {
      App.toggleWindow(WindowName.Launcher);
    },
    child: Widget.Label({
      label: "",
    }),
  });
};

export default Logo;
