import { clock } from "../../../lib/variables";

const DateTime = () => {
  const time = Utils.derive([clock], (c) => c.format("%H:%M") || "");
  const date = Utils.derive([clock], (c) => c.format("%a, %b %d") || "");

  const separator = Widget.Label({
    className: "separator",
    label: " | ",
  });

  return Widget.Box({
    className: "time-and-date",
    children: [
      Widget.Label({
        className: "time",
        label: time.bind(),
      }),
      separator,
      Widget.Label({
        className: "date",
        label: date.bind(),
      }),
    ],
  });
};

export default DateTime;
