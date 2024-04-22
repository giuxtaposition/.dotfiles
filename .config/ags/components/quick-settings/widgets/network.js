const { wifi } = await Service.import("network");
import ToggleButton from "../toggle-button.js";

const Network = () => {
  const icon = wifi.bind("icon_name").as((iconName) => {
    switch (iconName) {
      case "network-wireless-acquiring-symbolic":
        return "wifi";
      case "network-wireless-disabled-symbolic":
        return "󰤭";
      case "network-wireless-offline-symbolic":
        return "󰤩";
      case "network-wireless-signal-excellent-symbolic":
        return "󰤨";
      case "network-wireless-signal-good-symbolic":
        return "󰤥";
      case "network-wireless-signal-ok-symbolic":
        return "󰤢";
      case "network-wireless-signal-weak-symbolic":
        return "󰤟";
      case "network-wireless-signal-none-symbolic":
        return "󰤯";
      default:
        return "󰤯";
    }
  });

  return ToggleButton({
    icon: Widget.Label({
      className: "icon",
      label: icon,
    }),
    state: wifi.bind("enabled"),
    title: wifi.bind("ssid").as((ssid) => ssid || "Not Connected"),
    deactivate: () => (wifi.enabled = false),
    activate: () => {
      wifi.enabled = true;
      wifi.scan();
    },
    connection: [wifi, () => wifi.enabled],
  });
};

export default Network;
