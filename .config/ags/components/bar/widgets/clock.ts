import { clock } from "../../../lib/variables";

const time = Utils.derive([clock], (c) => c.format("%H:%M") || "");

const Clock = () => {
  return Widget.Label({
    className: "clock",
    hexpand: true,
    label: time.bind(),
  });
};

export default Clock;
