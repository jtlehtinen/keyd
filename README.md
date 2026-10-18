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
