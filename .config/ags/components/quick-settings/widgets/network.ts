const { wifi } = await Service.import("network");
import { fromNetworkIconName } from "../../../lib/icons";
import { truncate } from "../../../lib/utils";
import ToggleButton from "../toggle-button";

const Network = () => {
  const icon = wifi.bind("icon_name").as((iconName) => {
    return fromNetworkIconName(iconName);
  });

  return ToggleButton({
    icon: Widget.Label({
      className: "icon",
      label: icon,
      vpack: "center",
    }),
    title: wifi.bind("ssid").as((ssid) => truncate(ssid || "Not Connected")),
    deactivate: () => (wifi.enabled = false),
    activate: () => {
      wifi.enabled = true;
      wifi.scan();
    },
    connection: [wifi, () => wifi.enabled],
  });
};

export default Network;
