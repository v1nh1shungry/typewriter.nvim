#include <SFML/Audio.hpp>

#include <string>
#include <unordered_map>

class AudioPlayback {
public:
  AudioPlayback() = default;
  AudioPlayback(const AudioPlayback &) = delete;
  AudioPlayback(AudioPlayback &&) = delete;
  ~AudioPlayback() = default;

  void load(const std::string &filename) {
    if (sound_buffers_.count(filename) == 0) {
      sound_buffers_[filename].loadFromFile(filename);
    }
    sound_.setBuffer(sound_buffers_[filename]);
  }

  void play(const std::string &filename) {
    sound_.stop();
    load(filename);
    sound_.play();
  }

  bool is_playing() const { return sound_.getStatus() == sf::Sound::Playing; }

private:
  sf::Sound sound_;
  std::unordered_map<std::string, sf::SoundBuffer> sound_buffers_;
};

extern "C" void *new_audio_playback() { return new AudioPlayback; }

extern "C" void delete_audio_playback(AudioPlayback *self) { delete self; }

extern "C" void play_sound(AudioPlayback *self, const char *filename) {
  self->play(filename);
}
