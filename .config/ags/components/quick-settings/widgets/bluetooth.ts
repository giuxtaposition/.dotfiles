const bluetooth = await Service.import("bluetooth");
import { truncate } from "../../../lib/utils";
import { WindowName } from "../../../main";
import ToggleButton from "../toggle-button";

const Bluetooth = () => {
  return ToggleButton({
    icon: Widget.Label({
      className: "icon",
      vpack: "center",
      label: bluetooth.bind("enabled").as((enabled) => {
        return enabled ? "󰂯" : "󰂲";
      }),
    }),
    title: bluetooth.bind("connected_devices").as((devices) => {
      if (devices.length === 1) return truncate(devices[0].alias);
      return `${devices.length} Connected`;
    }),
    connection: [bluetooth, () => bluetooth.enabled],
    deactivate: () => (bluetooth.enabled = false),
    activate: () => (bluetooth.enabled = true),
    secondaryFunction: () => {
      Utils.execAsync(["bash", "-c", "blueman-manager"]);
      App.closeWindow(WindowName.QuickSettings);
    },
  });
};

export default Bluetooth;
