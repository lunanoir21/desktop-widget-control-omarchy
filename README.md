# Desktop Widget Control for Omarchy

> **This repo is only packaging.** The project itself lives at
> **[lunanoir21/desktop-widget-control](https://github.com/lunanoir21/desktop-widget-control)** —
> source, [changelog](https://github.com/lunanoir21/desktop-widget-control/blob/main/CHANGELOG.md),
> [website](https://lunanoir21.github.io/desktop-widget-control/), screenshots and the issue
> tracker are all there. Please open bugs and feature requests upstream; issues here are
> limited to the Omarchy wrapper itself (manifest, `Service.qml`, vendoring). If it is
> useful to you, a ⭐ on [desktop-widget-control](https://github.com/lunanoir21/desktop-widget-control)
> is the best way to say so.

[Desktop Widget Control](https://github.com/lunanoir21/desktop-widget-control) packaged as an
Omarchy shell plugin: live widgets on the Wayland desktop and a full-screen editor to place and
style them — sixteen modules (six clocks, five system monitors, a music player with a live
cava spectrum, calendar, weather, pomodoro, notes), nine themes, Turkish and English.

This repo is a thin wrapper. All behaviour lives upstream; the `desktop-widget-control/`
directory here is a vendored, pinned copy of its `ui/` (currently `v0.2.0`, commit
`9f6f32d87bb8f786d0fdf8477be7b95d4fb64496`), and `Service.qml` is what Omarchy's plugin loader needs to start it. Nothing is
developed here.

`manifest.json` declares `kinds: ["service"]` with `keepLoaded: true`, the same shape as
Omarchy's built-in `background`, `lock` and `notifications` plugins. The widgets sit on the
desktop's bottom layer and the editor is a full-screen overlay, so nothing needs a place in
Omarchy's bar.

## Install

```bash
omarchy plugin add https://github.com/lunanoir21/desktop-widget-control-omarchy.git --enable
```

There is nothing else to build: it is plain QML with bundled fonts, and it downloads nothing
except the weather forecast if you add the weather widget. A short tour opens on the first
start; it can be skipped.

The first-run tour offers to add a key for the editor (press the keys you want, or take `SUPER + G` or the first free one like it) and writes it into your `bindings.conf` / `bindings.lua` (`ui/scripts/bind.sh`, which you can also run yourself). To do it by hand:

```
bind = SUPER, G, exec, qs ipc call desktopWidgets toggle
```

(`qs ipc call desktopWidgets <edit|done|toggle|add|theme|…>`; the list is in the
[upstream README](https://github.com/lunanoir21/desktop-widget-control#scripting).)

## What it reads and writes

- **Reads** CPU, memory, network, disk and temperature counters from `/proc` and `/sys`
  (only while a widget needs them), the playing track over MPRIS, and `cava` output if
  `cava` is installed.
- **AI limits widget** (only if you add it): reads the newest rate-limit line in `~/.codex/sessions`, and a status line capture in `~/.local/state/desktop-widget-control/` if you set that up (`ui/scripts/claude-statusline.sh`, which only saves what Claude Code pipes to it). A switch that is **off by default**, "Claude: official API", additionally reads the token in `~/.claude/.credentials.json` (never sent when expired, passed to `curl` on stdin) and asks `api.anthropic.com/api/oauth/usage` every five minutes.
- **Network:** the weather widget asks Open-Meteo for a forecast and a city search; the AI limits widget, only with that switch on, asks api.anthropic.com. Every request is HTTPS only, with a time limit and a size cap on the answer (128 KiB for the weather requests, 64 KiB for the usage one).
- **Writes** its layout to `~/.config/desktop-widget-control/layout.json` and a cava config
  under `$XDG_RUNTIME_DIR`. It never touches `~/.config/omarchy/shell.json` or any other
  configuration.

## Uninstall

```bash
omarchy plugin remove io.github.lunanoir21.desktop-widget-control
```

Your layout stays in `~/.config/desktop-widget-control/`; delete it if you want it gone.

## Requirements

- Quickshell 0.3+ with Qt 6.6+ on a Wayland compositor with layer-shell (Hyprland on Omarchy)
- Optional: `cava` (the music visualizer), `curl` (weather), `notify-send` (pomodoro)

## Updating the vendored copy

`desktop-widget-control/` is a plain copy, not a git submodule: Omarchy's marketplace clones a
single ref of this repo, and a submodule would need an extra `--recurse-submodules` step outside
the plugin loader's control. To pick up a new release, copy its `ui/` over
`desktop-widget-control/ui`, bump `version` in `manifest.json` and the commit above, and
commit. Watch the
[upstream releases](https://github.com/lunanoir21/desktop-widget-control/releases).

## License

MIT, same as upstream — see [LICENSE](LICENSE). The bundled fonts keep their own SIL OFL 1.1
licenses, in `desktop-widget-control/ui/fonts`.

---

<sub>Maintainer note — marketplace submission: category `Widgets`, tags `Desktop`, `Hyprland`,
`Quickshell`. `preview.png` is the project's cover image (1280×640).</sub>
