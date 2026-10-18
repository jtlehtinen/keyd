# keyd

My personal [keyd](https://github.com/rvaiya/keyd) configuration.

## Layout

- **CapsLock** toggles a `nav` layer. Press it again to leave the layer.
- Inside `nav`:
  - `i` / `j` / `k` / `l` are Up / Left / Down / Right
  - `u` / `o` are Home / End
  - `y` / `p` are PageUp / PageDown
  - `h` is Backspace
  - `;` is Delete
  - `Esc` runs `clear()`

## Installation

```sh
sudo cp default.config /etc/keyd/default.conf
sudo keyd reload
```

## Omarchy bar indicator

`omarchy/keyd-mode.qml` is a custom Omarchy bar widget that shows a
four-arrows icon, dimmed while the `nav` layer is off and in the theme's
green while it is on.
It runs `keyd listen` and updates on `+nav` / `-nav` events.

1. Give your user access to keyd's socket, then log out and back in:

   ```sh
   sudo usermod -aG keyd $USER
   ```

2. Add the widget to a section of `bar.layout` in `~/.config/omarchy/shell.json`,
   for example in `center` just above `omarchy.clock`:

   ```json
   { "id": "keyd-mode", "type": "qml", "source": "~/Projects/keyd/omarchy/keyd-mode.qml" },
   ```

   The shell reloads `shell.json` on save. Optional settings: `"layer"`
   watches a different layer, `"icon"` sets the Nerd Font glyph and
   `"activeColor"` overrides the on color.
