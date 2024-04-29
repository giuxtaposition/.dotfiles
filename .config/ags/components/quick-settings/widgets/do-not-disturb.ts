import ToggleButton from "../toggle-button";

const n = await Service.import("notifications");
const dnd = n.bind("dnd");

export const DND = () =>
  ToggleButton({
    icon: Widget.Label({
      className: "icon",
      label: dnd.as((dnd) => (dnd ? "󰂛" : "󰂚")),
      vpack: "center",
    }),
    title: dnd.as((dnd) => (dnd ? "Silent" : "Noisy")),
    activate: () => (n.dnd = true),
    deactivate: () => (n.dnd = false),
    connection: [n, () => n.dnd],
  });
