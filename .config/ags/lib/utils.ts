import Gtk from "gi://Gtk?version=3.0";
import Gdk from "gi://Gdk";

export function forMonitors(widget: (monitor: number) => Gtk.Window) {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return range(n, 0).map(widget).flat(1);
}

export function truncate(string: string) {
  return string.length > 18 ? string.slice(0, 18) + "…" : string;
}

function range(length: number, start = 1) {
  return Array.from({ length }, (_, i) => i + start);
}
