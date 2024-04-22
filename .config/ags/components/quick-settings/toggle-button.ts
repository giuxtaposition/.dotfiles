import Gtk from "../../types/@girs/gtk-3.0/gtk-3.0";
import { Binding } from "../../types/service";
import { type LabelProps } from "../../types/widgets/label";
import type GObject from "gi://GObject?version=2.0";

const ToggleButton = ({
  icon,
  title,
  state,
  activate,
  deactivate,
  connection: [service, condition],
}: {
  icon: string | Gtk.Widget;
  title: LabelProps["label"];
  state: Binding<any, "enabled", boolean>;
  activate: () => void;
  deactivate: () => void;
  connection: [GObject.Object, () => boolean];
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
