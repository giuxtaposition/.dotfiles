import env from "../env";

enum Layout {
  IT = "it",
  EN = "en",
}

class KeyboardService extends Service {
  KEYBOARD_NAME = env.KEYBOARD_NAME;
  static {
    Service.register(
      this,
      {},
      {
        layout: ["string", "rw"],
        enabled: ["string", "rw"],
      },
    );
  }

  constructor() {
    super();

    this.#layout =
      Utils.exec(
        `swaymsg -t get_inputs | grep -E "\"${this.KEYBOARD_NAME}\"" -A 12 | grep -oP '(?<=xkb_active_layout_name": ").*?(?=",)'`,
      ) === "Italian"
        ? Layout.IT
        : Layout.EN;

    this.#enabled = Utils.exec(
      `swaymsg -t get_inputs | grep -E "\"${this.KEYBOARD_NAME}\"" -A 15 | grep -oP '(?<=send_events": ").*?(?=")'`,
    );
  }

  #layout = Layout.EN;
  #enabled = false;

  get layout() {
    return this.#layout;
  }

  get enabled() {
    return this.#enabled;
  }

  toggleEnabled() {
    Utils.exec(
      `swaymsg input "${this.KEYBOARD_NAME}" events toggle enabled disabled`,
    );
    this.#enabled = !this.#enabled;
    this.emit("changed");
    this.notify("enabled");
  }

  switchLayout() {
    Utils.exec(`swaymsg input "${this.KEYBOARD_NAME}" xkb_switch_layout next`);
    this.#layout = this.#layout === Layout.IT ? Layout.EN : Layout.IT;
    this.emit("changed");
    this.notify("layout");
  }
}

// the singleton instance
const keyboardService = new KeyboardService();

// export to use in other modules
export default keyboardService;
