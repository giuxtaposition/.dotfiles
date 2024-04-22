const ToggleButton = ({
  icon,
  title,
  state,
  activate,
  deactivate,
  connection: [service, condition],
}) =>
  Widget.Button({
    className: "toggle-button",
    setup: (self) =>
      self.hook(service, () => {
        self.toggleClassName("active", condition());
      }),

    onClicked: () => {
      if (condition()) {
        deactivate();
      } else {
        activate();
      }
    },
    child: Widget.Box({
      children: [
        typeof icon === "string"
          ? Widget.Icon({
              className: "icon",
              icon,
            })
          : icon,
        Widget.Box({
          vertical: true,
          className: "text",
          children: [
            Widget.Label({
              className: "title",
              label: title,
            }),
            Widget.Label({
              hpack: "start",
              className: "state",
              label: state ? "On" : "Off",
            }),
          ],
        }),
      ],
    }),
  });

export default ToggleButton;
