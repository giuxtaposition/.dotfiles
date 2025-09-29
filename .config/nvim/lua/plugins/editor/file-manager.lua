return {
  {
    "nvim-mini/mini.files",
    version = "*",
    keys = {
      {
        "<leader>e",
        function()
          local bufname = vim.api.nvim_buf_get_name(0)
          local path = vim.fn.fnamemodify(bufname, ":p")
          local current_buffer_dir = vim.fn.fnamemodify(bufname, ":p:h")

          if path and vim.uv.fs_stat(path) then
            require("mini.files").open(bufname, false)
          else
            require("mini.files").open(current_buffer_dir, false)
          end
        end,
        desc = "File explorer",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(nil, false)
        end,
        desc = "File explorer in root dir",
      },
    },
    opts = {
      windows = { width_nofocus = 25 },
    },
    config = function(_, opts)
      local minifiles = require("mini.files")

      minifiles.setup(opts)

      vim.api.nvim_create_autocmd("User", {
        desc = "Notify LSPs that a file was renamed",
        pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
        callback = function(args)
          local changes = {
            files = {
              {
                oldUri = vim.uri_from_fname(args.data.from),
                newUri = vim.uri_from_fname(args.data.to),
              },
            },
          }
          local will_rename_method, did_rename_method =
            vim.lsp.protocol.Methods.workspace_willRenameFiles, vim.lsp.protocol.Methods.workspace_didRenameFiles
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client:supports_method(will_rename_method) then
              local res = client:request_sync(will_rename_method, changes, 1000, 0)
              if res and res.result then
                vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding)
              end
            end
          end

          for _, client in ipairs(clients) do
            if client:supports_method(did_rename_method) then
              client:notify(did_rename_method, changes)
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        desc = "Add minifiles split keymaps",
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local function map_split(buf_id, lhs, direction)
            local function rhs()
              local window = minifiles.get_explorer_state().target_window

              -- Noop if the explorer isn't open or the cursor is on a directory.
              if window == nil or minifiles.get_fs_entry().fs_type == "directory" then
                return
              end

              -- Make a new window and set it as target.
              local new_target_window
              vim.api.nvim_win_call(window, function()
                vim.cmd(direction .. " split")
                new_target_window = vim.api.nvim_get_current_win()
              end)

              minifiles.set_target_window(new_target_window)

              -- Go in and close the explorer.
              minifiles.go_in({ close_on_file = true })
            end

            vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "Split " .. string.sub(direction, 12) })
          end

          local buf_id = args.data.buf_id
          map_split(buf_id, "<C-w>b", "belowright horizontal")
          map_split(buf_id, "<C-w>v", "belowright vertical")
        end,
      })
    end,
  },
}
