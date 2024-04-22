import dateTimeService from "../../../services/date-time-service.js";

const time = Widget.Label({
  className: "time",
  label: dateTimeService.bind("time").as((v) => `${v}`),
  setup: (self) =>
    self.hook(
      dateTimeService,
      (self, timeValue) => {
        self.label = timeValue ?? "";
        // self.label = `${DateTimeService["screen-value"]}`;
      },
      "time-changed",
    ),
});

const date = Widget.Label({
  className: "date",
  label: dateTimeService.bind("date").as((v) => `${v}`),
  setup: (self) =>
    self.hook(
      dateTimeService,
      (self, dateValue) => {
        self.label = dateValue ?? "";
        // self.label = `${DateTimeService["screen-value"]}`;
      },
      "date-changed",
    ),
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
