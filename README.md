<h1 align="center">typewriter.nvim</h1>

Play typewriter sound in Neovim.

## ⚡️ Requirement

* Linux only
* [SFML](https://github.com/SFML/SFML)
* cmake

## 📦 Installation

💤 [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'v1nh1shungry/typewriter.nvim',
    build = 'cmake -S . -B build && cmake --build build && cmake --install build --prefix build',
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
    volume = 100.0,
}
```

## 🚀 Usage

* `toggle()`: Enable/Disable typewriter
