local M = {}

local ffi = require('ffi')

local config = {
  enabled = true,
  volume = 100,
  libs = {
    sdl = nil,
    mixer = nil,
  },
}

ffi.cdef([[
typedef struct Mix_Chunk Mix_Chunk;
int SDL_Init(unsigned int);
int Mix_OpenAudio(int, unsigned short, int, int);
Mix_Chunk *Mix_LoadWAV(const char *);
int Mix_PlayChannel(int, Mix_Chunk *, int);
int Mix_Volume(int, int);
void Mix_FreeChunk(Mix_Chunk *);
void Mix_Quit();
void SDL_Quit();
]])

local sdl
local mixer

local bank = {}

local function play_sound(filename, channel)
  if config.enabled then
    local sample = bank[filename]
    if sample == nil then
      sample = mixer.Mix_LoadWAV(filename)
      bank[filename] = sample
    end
    return mixer.Mix_PlayChannel(channel, sample, 0)
  end
  return channel
end

function M.toggle()
  config.enabled = not config.enabled
  vim.notify(
    (config.enabled and 'Enable ' or 'Disable ') .. 'typewriter',
    vim.log.levels.INFO,
    { title = 'typewriter.nvim' }
  )
end

function M.setup(opts)
  config = vim.tbl_extend('force', config, opts)

  sdl = ffi.load(config.libs.sdl or 'libSDL2')
  mixer = ffi.load(config.libs.mixer or 'libSDL2_mixer')

  sdl.SDL_Init(0x00000010)
  mixer.Mix_OpenAudio(44100, 0x8010, 2, 1024)

  mixer.Mix_Volume(-1, math.floor(config.volume * 128 / 100))

  local root_dir = vim.fs.normalize(vim.fs.dirname(debug.getinfo(1).source:sub(2)) .. '/..')
  local any_sound = vim.fs.joinpath(root_dir, 'sounds', 'keyany.wav')
  local enter_sound = vim.fs.joinpath(root_dir, 'sounds', 'keyenter.wav')
  local augroup = vim.api.nvim_create_augroup('typewriter_events', {})
  local last_row, last_col = unpack(vim.api.nvim_win_get_cursor(0))
  local channel_any = 0
  local channel_enter = 1

  vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
      last_row, last_col = unpack(vim.api.nvim_win_get_cursor(0))
    end,
    group = augroup,
  })
  vim.api.nvim_create_autocmd('TextChangedI', {
    callback = function()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      if row == last_row and col ~= last_col then
        channel_any = play_sound(any_sound, channel_any)
      elseif row > last_row and col <= last_col then
        channel_enter = play_sound(enter_sound, channel_enter)
      elseif row < last_row then
        channel_any = play_sound(any_sound, channel_any)
      end
      last_row, last_col = row, col
    end,
    group = augroup,
  })

  vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
      for _, b in ipairs(bank) do
        mixer.Mix_FreeChunk(b)
      end
      mixer.Mix_Quit()
      sdl.SDL_Quit()
    end,
    group = augroup,
  })
end

return M
