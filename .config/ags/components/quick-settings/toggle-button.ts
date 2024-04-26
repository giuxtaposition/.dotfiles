import Gtk from "../../types/@girs/gtk-3.0/gtk-3.0";
import { type LabelProps } from "../../types/widgets/label";
import type GObject from "gi://GObject?version=2.0";

const ToggleButton = ({
  icon,
  title,
  activate,
  deactivate,
  connection: [service, condition],
  secondaryFunction,
}: {
  icon: string | Gtk.Widget;
  title: LabelProps["label"];
  activate: () => void;
  deactivate: () => void;
  connection: [GObject.Object, () => boolean];
  secondaryFunction?: () => void;
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

    onSecondaryClick: () => {
      if (secondaryFunction) {
        secondaryFunction();
      }
    },
    child: Widget.Box({
      vpack: "center",
      children: [
        typeof icon === "string"
          ? Widget.Icon({
              vpack: "center",
              className: "icon",
              icon,
            })
          : icon,
        Widget.Box({
          vpack: "center",
          className: "text",
          children: [
            Widget.Label({
              vpack: "center",
              className: "title",
              label: title,
            }),
          ],
        }),
      ],
    }),
  });

export default ToggleButton;
