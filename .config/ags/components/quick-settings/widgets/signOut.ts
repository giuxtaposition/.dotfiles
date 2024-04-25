const SignOut = (monitor: number = 0) => {
  return Widget.Button({
    onClicked: () => {
      App.openWindow();
    },
    className: "sign-out",
    child: Widget.Label({
      label: "Sign Out",
    }),
  });
};

export default SignOut;
