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
directory here is a vendored, pinned copy of its `ui/` (currently `v0.1.0`, commit
`152320a42e7efd72f0c85dab3d455f96bec3c668`), and `Service.qml` is what Omarchy's plugin loader needs to start it. Nothing is
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

Open the editor with a key:

```
bind = SUPER, G, exec, qs ipc call desktopWidgets toggle
```

(`qs ipc call desktopWidgets <edit|done|toggle|add|theme|…>`; the list is in the
[upstream README](https://github.com/lunanoir21/desktop-widget-control#scripting).)

## What it reads and writes

- **Reads** CPU, memory, network, disk and temperature counters from `/proc` and `/sys`
  (only while a widget needs them), the playing track over MPRIS, and `cava` output if
  `cava` is installed.
- **Network:** only the weather widget, which asks Open-Meteo for a forecast and a city search.
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
