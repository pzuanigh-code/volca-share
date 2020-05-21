# frozen_string_literal: true

module AudioSample
  extend ActiveSupport::Concern

  def audio_sample_code
    return unless audio_sample.present?

    @audio_sample_code ||=
      begin
        if audio_sample.include?('soundcloud')
          ::OEmbed::Providers::SoundCloud.get(audio_sample, maxheight: 81).html
        elsif /youtu\.?be/ === audio_sample
          video_id = audio_sample.match(/[a-zA-Z0-9]{11}/)
          return unless video_id.present?

          '<iframe width="480" height="270" ' \
          "src=\"https://www.youtube.com/embed/#{video_id}?feature=oembed\" " \
          'frameborder="0" allowfullscreen></iframe>'
        elsif audio_sample.include?('freesound')
          freesound_id = /\d{2,7}/.match(audio_sample).to_s
          return unless freesound_id.present?

          "<iframe frameborder='0' scrolling='no' src='http://www.freesound."\
          "org/embed/sound/iframe/#{freesound_id}/simple/small/' width='375'"\
          " height='30'></iframe>"
        end
      rescue OEmbed::NotFound
        nil
      end
  end
end