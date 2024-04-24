import dateTimeService from "../../../services/date-time-service";

const time = Widget.Label({
  className: "time",
  label: dateTimeService.bind("time").as((v) => `${v}`),
});

const date = Widget.Label({
  className: "date",
  label: dateTimeService.bind("date").as((v) => `${v}`),
});

const separator = Widget.Label({
  className: "separator",
  label: " | ",
});

const DateTime = () => {
  return Widget.Box({
    className: "time-and-date",
    children: [time, separator, date],
  });
};

export default DateTime;
