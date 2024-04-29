export enum Type {
  microphone = "microphone",
  speaker = "speaker",
}

export const volumeIcons = {
  [Type.speaker]: {
    muted: "󰸈",
    volume: ["", "", ""],
  },
  [Type.microphone]: {
    muted: "󰍭",
    volume: ["󰍬", "󰍬", "󰍬"],
  },
};

export const fromVolume = (volume: number, type: Type) => {
  const i = volumeIcons[type];

  if (volume < 33) {
    return i.volume[0];
  } else if (volume < 67) {
    return i.volume[1];
  } else {
    return i.volume[2];
  }
};

export const fromNetworkIconName = (iconName: string) => {
  switch (iconName) {
    case "network-wireless-acquiring-symbolic":
      return "󰤯";
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
};

export const fromBatteryIconName = (iconName: string) => {
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
};
