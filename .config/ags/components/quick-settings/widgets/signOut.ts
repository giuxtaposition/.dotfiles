import { WindowName } from "../../../main";

const SignOut = () => {
  return Widget.Button({
    onClicked: () => {
      App.openWindow(WindowName.PowerMenu);
    },
    className: "sign-out",
    child: Widget.Label({
      label: "Sign Out",
    }),
  });
};

export default SignOut;
