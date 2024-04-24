import { Binding } from "../../../types/service";
import Clock from "./clock";
const audio = await Service.import("audio");
const battery = await Service.import("battery");
type Type = "microphone" | "speaker";

const { wifi } = await Service.import("network");
const StateIcon = (
  condition: boolean | Binding<any, string, boolean>,
  text: string | Binding<any, string, string>,
  tooltip: string | Binding<any, string, string>,
) => {
  return Widget.Label({
    vpack: "center",
    className: "indicator-icon",
    visible: condition,
    label: text,
    tooltipText: tooltip,
  });
};

const NetworkIcon = () => {
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
  return StateIcon(
    true,
    icon,
    wifi.bind("ssid").as((ssid) => ssid || "Not Connected"),
  );
};

const VolumeIcon = () => {
  const type: Type = "speaker";
  const icon = Utils.watch("󰸈", audio[type], () => {
    if (audio[type].is_muted) {
      return "󰸈";
    }
    const volume = Math.floor(audio[type].volume * 100);

    if (volume < 33) {
      return "";
    } else if (volume < 67) {
      return "";
    } else {
      return "";
    }
  });

  return StateIcon(
    true,
    icon,
    audio[type].bind("volume").as((v) => `${Math.floor(v * 100)}%`),
  );
};

const MicIcon = () => {
  const type: Type = "microphone";
  const icon = Utils.watch("󰍭", audio[type], () => {
    if (audio[type].is_muted) {
      return "󰍭";
    }
    return "󰍬";
  });

  return StateIcon(
    true,
    icon,
    audio[type].bind("volume").as((v) => `${Math.floor(v * 100)}%`),
  );
};

const BatteryIcon = () => {
  const icon = battery.bind("icon_name").as((iconName) => {
    switch (iconName) {
      case "battery-level-100-charged-symbolic":
        return "󰂅";
      case "battery-level-90-symbolic":
        return "󰂂";
      case "battery-level-80-symbolic":
        return "󰂁";
      case "battery-level-70-symbolic":
        return "󰂀";
      case "battery-level-60-symbolic":
        return "󰁿";
      case "battery-level-50-symbolic":
        return "󰁾";
      case "battery-level-40-symbolic":
        return "󰁽";
      case "battery-level-30-symbolic":
        return "󰁼";
      case "battery-level-20-symbolic":
        return "󰁻";
      case "battery-level-10-symbolic":
        return "󰁺";
      case "battery-level-0-symbolic":
        return "󰂎";
      case "battery-level-90-charging-symbolic":
        return "󰂋";
      case "battery-level-80-charging-symbolic":
        return "󰂊";
      case "battery-level-70-charging-symbolic":
        return "󰂉";
      case "battery-level-60-charging-symbolic":
        return "󰂉";
      case "battery-level-50-charging-symbolic":
        return "󰢝";
      case "battery-level-40-charging-symbolic":
        return "󰂈";
      case "battery-level-30-charging-symbolic":
        return "󰂇";
      case "battery-level-20-charging-symbolic":
        return "󰂆";
      case "battery-level-10-charging-symbolic":
        return "󰢜";
      default:
        return "󰁹";
    }
  });

  return StateIcon(
    battery.bind("available"),
    icon,
    battery.bind("percent").as((p) => (p > 0 ? `${p / 100}` : "0")),
  );
};

const Indicator = (monitor: number = 0) => {
  return Widget.Button({
    className: "indicator",
    hexpand: true,
    onClicked: () => {
      App.toggleWindow(`quick-settings-${monitor}`);
    },
    child: Widget.Box({
      hexpand: true,
      children: [
        NetworkIcon(),
        VolumeIcon(),
        MicIcon(),
        BatteryIcon(),
        Clock(),
      ],
    }),
  });
};

export default Indicator;
