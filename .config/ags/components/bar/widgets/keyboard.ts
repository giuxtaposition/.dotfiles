import keyboardService from "../../../services/keyboard-service";
import { Binding } from "../../../types/service";
import { LabelProps } from "../../../types/widgets/label";

const Revealer = (
  label: LabelProps["label"],
  condition: Binding<any, string, boolean> | boolean,
) => {
  return Widget.Revealer({
    revealChild: condition,
    transitionDuration: 200,
    transition: "slide_left",
    child: Widget.Label({ label: label }),
  });
};

const Keyboard = () => {
  const isEnLayout = Utils.watch(true, keyboardService, () => {
    return keyboardService.layout === "en" && keyboardService.enabled;
  });
  const isItLayout = Utils.watch(false, keyboardService, () => {
    return keyboardService.layout === "it" && keyboardService.enabled;
  });

  return Widget.Button({
    className: "keyboard",
    onClicked: () => {
      keyboardService.switchLayout();
    },
    onSecondaryClick: () => {
      keyboardService.toggleEnabled();
    },
    child: Widget.Box({
      vpack: "center",
      children: [
        Revealer(
          "󰌌 ",
          keyboardService.bind("enabled").as((v) => v),
        ),
        Revealer(
          "󰌐 ",
          keyboardService.bind("enabled").as((v) => !v),
        ),
        Revealer("en", isEnLayout),
        Revealer("it", isItLayout),
      ],
    }),
  });
};

export default Keyboard;
