{
  programs.zed-editor.enable = true;
  programs.zed-editor.userSettings = {
    base_keymap = "VSCode";
    vim_mode = true;
    relative_line_numbers = true;
    agent = {
      default_model = {
        model = "claude-sonnet-4-thinking-latest";
        provider = "zed.dev";
      };
      dock = "left";
      inline_assistant_model = {
        model = "claude-sonnet-4-thinking-latest";
        provider = "zed.dev";
      };
    };
    edit_predictions = {
      mode = "subtle";
    };
    theme = "Carbonfox - opaque";
    ui_font_size = 18;
    buffer_font_size = 18;
    project_panel = {
      dock = "right";
      indent_size = 10;
    };
    outline_panel = {
      dock = "right";
    };
    format_on_save = "on";
    prettier = {
      allowed = true;
      plugins = [
        "prettier-plugin-organize-imports"
        "prettier-plugin-tailwindcss"
      ];
    };
    languages = {
      YAML = {
        formatter = "language_server";
      };
      JavaScript = {
        code_actions_on_format = {
          "source.fixAll.eslint" = true;
        };
      };
    };
    lsp = {
      pyright = {
        settings = {
          python = {
            analysis = {
              diagnosticMode = "workspace";
              typeCheckingMode = "strict";
            };
            pythonPath = "/Users/ajit/code/platform/workflows/.venv/bin/python";
          };
        };
      };
    };
  };
  programs.zed-editor.userKeymaps = [
    {
      context = "Workspace";
      bindings = {
        "shift shift" = "file_finder::Toggle";
        cmd-b = "workspace::ToggleRightDock";
        cmd-r = "workspace::ToggleLeftDock";
        cmd-shift-x = null;
        cmd-ctrl-x = "zed::Extensions";
      };
    }
    {
      context = "ProjectPanel";
      bindings = {
        shift-r = null;
        f2 = null;
        cmd-shift-x = "project_panel::Rename";
      };
    }
    {
      context = "Editor";
      bindings = {
        f2 = null;
        cmd-shift-x = "editor::Rename";
      };
    }
  ];
  programs.zed-editor.extensions = [ "nix" "nvim-nightfox" "html" "git-firefly" "toml" "csv" ];
}
