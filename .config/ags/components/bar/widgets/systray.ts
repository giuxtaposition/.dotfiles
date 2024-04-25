export const TrayButton = (monitor: number = 0) =>
  Widget.Button({
    className: "tray-button",
    onClicked: () => {
      App.toggleWindow(`systray-${monitor}`);
    },
    child: Widget.Label({
      label: "",
    }),
  });
