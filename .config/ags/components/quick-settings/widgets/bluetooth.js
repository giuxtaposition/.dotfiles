const bluetooth = await Service.import("bluetooth");
import ToggleButton from "../toggle-button.js";

const Bluetooth = () => {
  const icon = Utils.watch("󰂲", bluetooth, () => {
    if (!bluetooth.enabled) return "󰂲";

    if (bluetooth.connected_devices.length === 0) return "󰂯";

    return "󰂱";
  });

  return ToggleButton({
    icon: Widget.Label({
      className: "icon",
      label: icon,
    }),
    title: bluetooth.bind("connected_devices").as((devices) => {
      if (devices.length === 1) return devices[0].alias;
      return `${devices.length} Connected`;
    }),
    connection: [bluetooth, () => bluetooth.enabled],
    deactivate: () => (bluetooth.enabled = false),
    activate: () => (bluetooth.enabled = true),
    state: bluetooth.bind("enabled"),
  });
};

export default Bluetooth;
