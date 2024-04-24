import dateTimeService from "../../../services/date-time-service";

const Clock = () => {
  return Widget.Label({
    className: "clock",
    hexpand: true,
    label: dateTimeService.bind("time").as((v) => `${v}`),
  });
};

export default Clock;
