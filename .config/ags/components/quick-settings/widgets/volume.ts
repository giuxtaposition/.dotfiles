import { Type, fromVolume, volumeIcons } from "../../../lib/icons";

const audio = await Service.import("audio");

const VolumeIndicator = (type: Type) => {
  return Widget.Label({
    hpack: "start",
    label: Utils.merge(
      [audio[type].bind("is_muted"), audio[type].bind("volume")],
      (isMuted, volume) => {
        if (isMuted) {
          return volumeIcons[type].muted;
        }

        return fromVolume(volume * 100, type);
      },
    ),
    className: audio[type]
      .bind("is_muted")
      .as((isMuted) => `${isMuted ? "volume-icon less" : "volume-icon more"}`),
  });
};

const VolumeSlider = (type: Type) =>
  Widget.Overlay({
    hexpand: true,
    passThrough: true,
    child: Widget.Slider({
      drawValue: false,
      on_change: ({ value, dragging }) => {
        if (dragging) {
          audio[type].volume = value;
          audio[type].is_muted = false;
        }
      },
      value: audio[type].bind("volume"),
      className: audio[type]
        .bind("is_muted")
        .as(
          (isMuted) => `${isMuted ? "volume-slider muted" : "volume-slider"}`,
        ),
    }),

    overlays: [VolumeIndicator(type)],
  });

const VolumeMute = (type: Type) => {
  return Widget.Button({
    onClicked: () => {
      audio[type].is_muted = !audio[type].is_muted;
    },
    className: audio[type]
      .bind("is_muted")
      .as((isMuted) => `${isMuted ? "volume-mute active" : "volume-mute"}`),
    child: Widget.Label({
      label: volumeIcons[type].muted,
    }),
  });
};

export const Speaker = () =>
  Widget.Box({
    class_name: "volume",
    children: [VolumeSlider(Type.speaker), VolumeMute(Type.speaker)],
  });

export const Mic = () =>
  Widget.Box({
    class_name: "volume",
    children: [VolumeSlider(Type.microphone), VolumeMute(Type.microphone)],
  });
