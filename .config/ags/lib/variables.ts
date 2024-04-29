import GLib from "gi://GLib";

export const clock = Variable(GLib.DateTime.new_now_local(), {
  poll: [1000, () => GLib.DateTime.new_now_local()],
});

export const temperature = Variable(0, {
  listen: ['bash -c "wl-gammarelay-rs watch {t}"', (t) => parseInt(t)],
});
