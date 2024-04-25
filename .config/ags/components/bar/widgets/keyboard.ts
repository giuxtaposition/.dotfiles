import env from "../../../env";
import swayService, { Layout } from "../../../services/sway-service";
import { LabelProps } from "../../../types/widgets/label";

const Revealer = (
  label: LabelProps["label"],
  setup: (revealer: any) => void,
) => {
  return Widget.Revealer({
    setup,
    transitionDuration: 200,
    transition: "slide_left",
    child: Widget.Label({ label: label }),
  });
};

const Keyboard = () => {
  return Widget.Button({
    className: "keyboard",
    onClicked: () =>
      swayService.msg(`input "${env.KEYBOARD_NAME}" xkb_switch_layout next`),
    onSecondaryClick: () =>
      swayService.msg(
        `input "${env.KEYBOARD_NAME}" events toggle enabled disabled`,
      ),
    child: Widget.Box({
      vpack: "center",
      children: [
        Revealer("󰌌 ", (revealer) => {
          revealer.hook(swayService, (revealer) => {
            revealer.reveal_child = swayService.keyboard.enabled;
          });
        }),
        Revealer("󰌐 ", (revealer) => {
          revealer.hook(swayService, (revealer) => {
            revealer.reveal_child = !swayService.keyboard.enabled;
          });
        }),
        Revealer("it", (revealer) => {
          revealer.hook(swayService, (revealer) => {
            revealer.reveal_child =
              swayService.keyboard.enabled &&
              swayService.keyboard.layout === Layout.IT;
          });
        }),
        Revealer("en", (revealer) => {
          revealer.hook(swayService, (revealer) => {
            revealer.reveal_child =
              swayService.keyboard.enabled &&
              swayService.keyboard.layout === Layout.EN;
          });
        }),
      ],
    }),
  });
};

export default Keyboard;
