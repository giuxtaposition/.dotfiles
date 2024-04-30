import {
  micRecording,
  screenSharing,
  webcamRecording,
} from "../../../lib/variables";

export const ScreenSharingIndicator = () => {
  return Widget.Label({
    // hpack: "start",
    className: "sharing",
    label: screenSharing.bind().as((sharing) => {
      if (sharing) {
        return "󱄄";
      } else {
        return "";
      }
    }),
  });
};

export const MicRecordingIndicator = () => {
  return Widget.Label({
    // hpack: "start",
    className: "sharing",
    label: micRecording.bind().as((recording) => {
      if (recording) {
        return "";
      } else {
        return "";
      }
    }),
  });
};

export const WebcamRecordingIndicator = () => {
  return Widget.Label({
    // hpack: "start",
    className: "sharing",
    label: webcamRecording.bind().as((recording) => {
      if (recording) {
        return "";
      } else {
        return "";
      }
    }),
  });
};
