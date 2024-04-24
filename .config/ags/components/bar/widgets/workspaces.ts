import { swayService } from "../../../services/sway-service";

const WorkspacesComponent = () => {
  return Widget.Box({
    className: "workspaces",
    children: Array.from({ length: 10 }, (_, i) => {
      i += 1;

      return Widget.Button({
        className: "workspace",
        setup: (btn) => {
          btn.hook(
            swayService,
            (btn) => {
              const ws = swayService.getWorkspace(`${i}`);
              btn.toggleClassName("occupied", ws !== undefined);
              btn.toggleClassName("empty", !ws);
            },
            "notify::workspaces",
          );

          btn.hook(swayService.active.workspace, (btn) => {
            btn.toggleClassName(
              "active",
              swayService.active.workspace.name == i.toString(),
            );
          });
        },
        on_clicked: () => swayService.msg(`workspace ${i}`),
      });
    }),
  });
};

const Workspaces = () =>
  Widget.EventBox({
    class_name: "workspaces panel-button",
    child: Widget.Box({
      child: Widget.EventBox({
        on_scroll_up: () => swayService.msg("workspace next"),
        on_scroll_down: () => swayService.msg("workspace prev"),
        class_name: "eventbox",
        child: WorkspacesComponent(),
      }),
    }),
  });

export default Workspaces;
