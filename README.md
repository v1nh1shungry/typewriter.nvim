<h1 align="center">typewriter.nvim</h1>

Play typewriter sound in Neovim.

## ⚡️ Requirement

* Linux only
* [SDL2](https://libsdl.org/)
* [SDL_mixer 2.0](https://www.libsdl.org/projects/old/SDL_mixer/)

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
    volume = 100,
    libs = { -- you can specify the library path manually if not found
        sdl = nil, -- path to libSDL2.so
        mixer = nil, -- path to libSDL2_mixer.so
    },
}
```

## 🚀 Usage

* `toggle()`: Enable/Disable typewriter
