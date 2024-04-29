import ToggleButton from "../toggle-button";
import { temperature } from "../../../lib/variables";

const MAX_TEMP = 6500 as const;
const SHIELD_TEMP = 5000 as const;

const setTemperature = (temp: number) => {
  Utils.execAsync(
    `busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q ${temp}`,
  );
};

export const EyeShield = () =>
  ToggleButton({
    icon: Widget.Label({
      className: "icon",
      label: temperature
        .bind()
        .as((temperature) => (temperature === MAX_TEMP ? "󰈈" : "󰈈")),
      vpack: "center",
    }),
    title: temperature
      .bind()
      .as((temperature) => (temperature === MAX_TEMP ? "Disabled" : "Enabled")),
    activate: () => setTemperature(SHIELD_TEMP),
    deactivate: () => setTemperature(MAX_TEMP),
    connection: [temperature, () => temperature.value === SHIELD_TEMP],
  });
