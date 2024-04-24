const Logo = (monitor: number = 0) => {
  return Widget.Button({
    className: "logo",
    onClicked: () => {
      App.openWindow(`launcher-${monitor}`);
    },
    child: Widget.Label({
      label: "",
    }),
  });
};

export default Logo;
