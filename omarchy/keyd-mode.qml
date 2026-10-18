// Omarchy bar widget that shows whether a keyd layer (nav by default) is active.
// Requires the user to be in the `keyd` group to read /run/keyd.socket.
import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root
  property var bar
  property string moduleName
  property var settings

  function setting(name, fallback) {
    var value = settings ? settings[name] : undefined
    return value === undefined || value === null || value === "" ? fallback : value
  }

  // Layer to watch, the Nerd Font glyph to draw and an optional color override.
  readonly property string layerName: setting("layer", "nav")
  readonly property string icon: setting("icon", "󰁁")
  readonly property string activeColor: setting("activeColor", themeGreen)

  property bool layerActive: false
  property string themeGreen: "#9ece6a"

  implicitWidth: bar ? bar.barSize : 28
  implicitHeight: 27

  // `keyd listen` prints `+<layer>` / `-<layer>` on every layer change.
  Process {
    id: listen
    command: ["keyd", "listen"]
    running: true
    stdout: SplitParser {
      onRead: line => {
        if (line === "+" + root.layerName) root.layerActive = true
        else if (line === "-" + root.layerName) root.layerActive = false
      }
    }
    // keyd restarted or the socket went away: clear the indicator and reconnect.
    onExited: {
      root.layerActive = false
      retry.start()
    }
  }

  Timer {
    id: retry
    interval: 3000
    onTriggered: listen.running = true
  }

  // The bar only exposes foreground/accent/urgent, so read `green` from the
  // current theme. Re-read whenever the bar's colors change on a theme swap.
  FileView {
    id: themeColors
    path: Quickshell.env("HOME") + "/.local/state/omarchy/current/theme/colors.toml"
    onLoaded: {
      var match = /^\s*green\s*=\s*"(#[0-9a-fA-F]{6})"/m.exec(text())
      if (match) root.themeGreen = match[1]
    }
  }

  property color themeForeground: bar ? bar.foreground : "white"
  onThemeForegroundChanged: themeColors.reload()

  Text {
    anchors.centerIn: parent
    text: root.icon
    color: root.layerActive ? root.activeColor : (root.bar ? root.bar.foreground : "white")
    opacity: root.layerActive ? 1 : 0.35
    font.family: root.bar ? root.bar.fontFamily : "monospace"
    font.pixelSize: 15

    Behavior on color { ColorAnimation { duration: 120 } }
    Behavior on opacity { NumberAnimation { duration: 120 } }
  }

  HoverHandler {
    onHoveredChanged: {
      if (!root.bar) return
      if (hovered) root.bar.showTooltip(root, "keyd " + root.layerName + (root.layerActive ? ": on" : ": off"))
      else root.bar.hideTooltip(root)
    }
  }
}
