local M = {}

local ffi = require('ffi')

local root_dir = vim.fs.normalize(vim.fs.dirname(debug.getinfo(1).source:sub(2)) .. '/..')

local libtypewriter = ffi.load(vim.fs.joinpath(root_dir, 'libtypewriter.so'))

local config = {
  enabled = true,
}

ffi.cdef([[
typedef struct AudioPlayback AudioPlayback;
AudioPlayback *new_audio_playback();
void delete_audio_playback(AudioPlayback *);
void play_sound(AudioPlayback *, const char *);
]])

local AudioPlaybackWrapper = {}
AudioPlaybackWrapper.__index = AudioPlaybackWrapper

local function AudioPlayback()
  local self = { super = libtypewriter.new_audio_playback() }
  ffi.gc(self.super, libtypewriter.delete_audio_playback)
  return setmetatable(self, AudioPlaybackWrapper)
end

function AudioPlaybackWrapper.play_sound(self, filename)
  if config.enabled then
    libtypewriter.play_sound(self.super, filename)
  end
end

local audio_playback = AudioPlayback()

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

  local any_sound = vim.fs.joinpath(root_dir, 'sounds', 'keyany.wav')
  local enter_sound = vim.fs.joinpath(root_dir, 'sounds', 'keyenter.wav')
  local augroup = vim.api.nvim_create_augroup('typewriter_events', {})
  local last_row, last_col = unpack(vim.api.nvim_win_get_cursor(0))

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
        audio_playback:play_sound(any_sound)
      elseif row > last_row and col <= last_col then
        audio_playback:play_sound(enter_sound)
      elseif row < last_row then
        audio_playback:play_sound(any_sound)
      end
      last_row, last_col = row, col
    end,
    group = augroup,
  })
end

return M
