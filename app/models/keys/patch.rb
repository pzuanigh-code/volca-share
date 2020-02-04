# frozen_string_literal: true

module Keys
  class Patch
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Document::Taggable
    include ActiveModel::Validations

    field :name, type: String
    field :secret, type: Boolean, default: false
    field :notes, type: String
    field :slug, type: String

    field :voice, type: Integer, default: 57
    field :octave, type: Integer, default: 57
    field :detune, type: Integer, default: 0
    field :portamento, type: Integer, default: 0
    field :vco_eg_int, type: Integer, default: 0
    field :cutoff, type: Integer, default: 63
    field :peak, type: Integer, default: 0
    field :vcf_eg_int, type: Integer, default: 0
    field :lfo_rate, type: Integer, default: 0
    field :lfo_pitch_int, type: Integer, default: 0
    field :lfo_cutoff_int, type: Integer, default: 0
    field :attack, type: Integer, default: 0
    field :decay_release, type: Integer, default: 63
    field :sustain, type: Integer, default: 127
    field :delay_time, type: Integer, default: 0
    field :delay_feedback, type: Integer, default: 0
    field :lfo_shape, type: String, default: 'triangle'
    field :lfo_trigger_sync, type: Boolean, default: false
    field :step_trigger, type: Boolean, default: false
    field :tempo_delay, type: Boolean, default: true

    belongs_to :user,
               class_name: 'User',
               inverse_of: :keys_patches,
               optional: true

    midi_validation_options = {
      numericality: {
        only_integer: true,
        greater_than_or_equal_to: 0,
        less_than_or_equal_to: 127
      }
    }

    validates_presence_of :name, :slug
    validates :voice, inclusion: { in: [10, 30, 50, 70, 100, 120] }
    validates :octave, inclusion: { in: [10, 30, 50, 70, 100, 120] }
    validates :detune, midi_validation_options
    validates :portamento, midi_validation_options
    validates :vco_eg_int, midi_validation_options
    validates :cutoff, midi_validation_options
    validates :peak, midi_validation_options
    validates :vcf_eg_int, midi_validation_options
    validates :lfo_rate, midi_validation_options
    validates :lfo_pitch_int, midi_validation_options
    validates :lfo_cutoff_int, midi_validation_options
    validates :attack, midi_validation_options
    validates :decay_release, midi_validation_options
    validates :sustain, midi_validation_options
    validates :delay_time, midi_validation_options
    validates :delay_feedback, midi_validation_options
    validates :lfo_shape, inclusion: { in: %w(saw triangle square) }
  end
end

