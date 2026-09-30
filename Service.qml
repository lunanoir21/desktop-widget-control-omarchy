import QtQuick
import Quickshell
import "./desktop-widget-control/ui" as Dwc

// Omarchy entry point for the "service" kind. Desktop Widget Control owns its
// own layer-shell windows (the widgets on the desktop, the full-screen editor,
// the first-run tour), so the host only has to exist once. Open the editor with
// a key:
//   qs ipc call desktopWidgets toggle
Scope {
    Dwc.DwcHost {}
}
