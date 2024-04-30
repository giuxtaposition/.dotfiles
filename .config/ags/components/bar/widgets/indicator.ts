import { WindowName } from "../../../main";
import { Binding } from "../../../types/service";
import Clock from "./clock";
import {
  Type,
  fromBatteryIconName,
  fromNetworkIconName,
  fromVolume,
  volumeIcons,
} from "../../../lib/icons";
const audio = await Service.import("audio");
const battery = await Service.import("battery");

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
    return fromNetworkIconName(iconName);
  });
  return StateIcon(
    true,
    icon,
    wifi.bind("ssid").as((ssid) => ssid || "Not Connected"),
  );
};

const VolumeIcon = (type: Type) => {
  return StateIcon(
    true,
    Utils.merge(
      [audio[type].bind("is_muted"), audio[type].bind("volume")],
      (isMuted, volume) => {
        if (isMuted) {
          return volumeIcons[type].muted;
        }

        return fromVolume(volume * 100, type);
      },
    ),
    audio[type].bind("volume").as((v) => `${Math.floor(v * 100)}%`),
  );
};

const BatteryIcon = () => {
  const icon = battery.bind("icon_name").as((iconName) => {
    return fromBatteryIconName(iconName);
  });

  return StateIcon(
    battery.bind("available"),
    icon,
    battery.bind("percent").as((p) => (p > 0 ? `${p}%` : "0")),
  );
};

const Indicator = () => {
  return Widget.Button({
    className: "indicator",
    onClicked: () => {
      App.toggleWindow(WindowName.QuickSettings);
    },
    child: Widget.Box({
      children: [
        NetworkIcon(),
        VolumeIcon(Type.speaker),
        VolumeIcon(Type.microphone),
        BatteryIcon(),
        Clock(),
      ],
    }),
  });
};

export default Indicator;
