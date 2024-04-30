import GLib from "gi://GLib";

export const clock = Variable(GLib.DateTime.new_now_local(), {
  poll: [1000, () => GLib.DateTime.new_now_local()],
});

export const temperature = Variable(0, {
  listen: ['bash -c "wl-gammarelay-rs watch {t}"', (t) => parseInt(t)],
});

export const screenSharing = Variable(false, {
  poll: [
    1000,
    'bash -c "pactl -f json list clients"',
    (result) => {
      const clients = JSON.parse(result);
      const clientsScreenSharing = clients.filter(
        (client) => client.properties["pipewire.access"] === "portal",
      );

      return clientsScreenSharing.length > 0;
    },
  ],
});

export const micRecording = Variable(false, {
  poll: [
    1000,
    'bash -c "pactl -f json list source-outputs"',
    (result) => {
      const sources = JSON.parse(result);
      return sources.length > 0;
    },
  ],
});

export const webcamRecording = Variable(false, {
  poll: [
    1000,
    'bash -c "lsof /dev/video0"',
    (result) => {
      const lines = result.split("\n");
      let processes: string[] = [];

      for (let i = 1; i < lines.length; i++) {
        const parts = lines[i].split(/\s+/);
        if (parts.length > 1) {
          processes.push(parts[0]);
        }
      }
      const clients = processes.filter(
        (process) => !["wireplumb", "pipewire"].includes(process),
      );

      return clients.length > 0;
    },
  ],
});
