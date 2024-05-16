<h1 align="center">typewriter.nvim</h1>

Play typewriter sound in Neovim.

## 📦 Installation

💤 [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'v1nh1shungry/typewriter.nvim',
    keys = { { '<Leader>uk', function() require('typewriter').toggle() end, desc = 'Toggle typewriter' } },
    lazy = false,
    opts = {},
}
```

## ⚙️ Configuration

**NOTE: make sure you have called `require('typewriter').setup()` before you use the plugin!**

```lua
{
    -- default ocnfiguration
    enabled = true, -- whether to enable typewriter when enter Neovim
}
```

## 🚀 Usage

* `toggle()`: Enable/Disable typewriter

## Build

### Requirement

* `openal`
* `vorbis`
* `openal`

```bash
cmake -S . -B build
cmake --build build/
# important: you should copy the .so to the root directory so that the plugin can find it
cp build/libtypewriter.so .
```
