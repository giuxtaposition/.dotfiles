import { type Application } from "../../../types/service/applications";

export const LauncherItem = (app: Application, monitor: number = 0) =>
  Widget.Button({
    on_clicked: () => {
      App.closeWindow(`launcher-${monitor}`);
      app.launch();
    },
    className: "item",
    attribute: { app },
    child: Widget.Box({
      children: [
        Widget.Icon({
          icon: app.icon_name || "",
          size: 42,
        }),
        Widget.Label({
          className: "title",
          label: app.name,
          xalign: 0,
          vpack: "center",
          truncate: "end",
        }),
      ],
    }),
  });
