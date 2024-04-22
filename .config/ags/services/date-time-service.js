class DateTimeService extends Service {
  static {
    Service.register(
      this,
      {
        "date-changed": ["string"],
        "time-changed": ["string"],
      },
      {
        time: ["string", "r"],
        date: ["string", "r"],
      },
    );
  }

  #time = undefined;
  #date = undefined;

  get time() {
    return this.#time;
  }

  get date() {
    return this.#date;
  }

  constructor() {
    super();

    const date = `date +"%a, %b %d"`;
    Utils.monitorFile(date, () => this.#onDateChange());

    const time = `date +%H:%M`;
    Utils.monitorFile(time, () => this.#onTimeChange());

    this.#onDateChange();
    this.#onTimeChange();
  }

  #onDateChange() {
    this.#date = Utils.exec(`date +"%a, %b %d"`);
    this.emit("changed");
    this.notify("date");
    this.emit("date-changed", this.#date);
  }

  #onTimeChange() {
    this.#time = Utils.exec(`date +%H:%M`);
    this.emit("changed");
    this.notify("time");
    this.emit("time-changed", this.#time);
  }
}

// the singleton instance
const dateTimeService = new DateTimeService();

// export to use in other modules
export default dateTimeService;
