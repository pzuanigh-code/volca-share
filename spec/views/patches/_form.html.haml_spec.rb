# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'patches/_form.html.haml', type: :view do
  context 'when patch has an audio sample' do
    let!(:user) { build(:user) }
    let(:user_patch) do
      VolcaShare::PatchViewModel.wrap(create(:user_patch, user: user))
    end

    it 'shows a preview of the audio sample' do
      @patch = user_patch
      render partial: 'patches/form.html.haml', locals: { current_user: user }
      expect(rendered).to have_css('.sample')
    end
  end

  it 'shows tag input placeholders' do
    @patch = VolcaShare::PatchViewModel.wrap(Patch.new)
    render partial: 'patches/form.html.haml'
    expect(rendered).to have_selector(
      'input[placeholder="tags, separated, by, commas"]'
    )
  end
end
