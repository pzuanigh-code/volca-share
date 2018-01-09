require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe PatchesController, type: :controller do
  login_user
  # This should return the minimal set of attributes required to create a valid
  # Patch. As you add validations to Patch, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:patch, secret: false)
  end

  let(:invalid_attributes) do
    attributes_for(:patch, attack: 'bort')
  end

  let(:tags_string) do
    'aaa,bbb,ccc'
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PatchesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all patches as @patches' do
      patch = Patch.create! valid_attributes.merge(user_id: '123')
      get :index
      expect(assigns(:patches)).to eq([patch])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested patch as @patch' do
      patch = Patch.create!(valid_attributes)
      get :show, { slug: patch.to_param }, valid_session
      expect(assigns(:patch)).to eq(patch)
    end
  end

  describe 'GET #new' do
    it 'assigns a new patch as @patch' do
      get :new, {}, valid_session
      expect(assigns(:patch)).to be_a_new(VolcaShare::PatchViewModel)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested patch as @patch' do
      patch = create(:patch)
      get :edit, { slug: patch.to_param }, valid_session
      expect(assigns(:patch)).to eq(patch)
    end
  end

  describe 'GET #oembed' do
    it 'assigns the requested patch as @patch' do
      patch = create(:patch)
      get :oembed, { slug: patch.to_param, format: :json }, valid_session
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['name']).to eq(patch.name)
      expect(JSON.parse(response.body)['audio_sample_code'])
        .to eq(
                '<iframe width="100%" height="81" scrolling="no"'\
                ' frameborder="no" src="https://w.soundcloud.com/player/'\
                '?visual=true&url=https%3A%2F%2Fapi.soundcloud.com%2Ftracks'\
                '%2F258722704&show_artwork=true&maxheight=81"></iframe>'
              )
      expect(JSON.parse(response.body)['patch_location'])
        .to eq("/patch/#{patch.id}")
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Patch' do
        expect do
          post(
                :create,
                {patch: valid_attributes.merge(tags: tags_string)},
                valid_session
              )
        end.to change(Patch, :count).by(1)
      end

      it 'assigns a newly created patch as @patch' do
        post(
          :create,
          {patch: valid_attributes.merge(tags: tags_string)},
          valid_session
        )
        expect(assigns(:patch)).to be_a(Patch)
        expect(assigns(:patch)).to be_persisted
      end

      it 'redirects to the created patch' do
        post(
          :create,
          {patch: valid_attributes.merge(tags: tags_string)},
          valid_session
        )
        expect(response).to redirect_to(
          user_patch_url(User.first.slug, Patch.last.slug)
        )
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved patch as @patch' do
        post(
          :create,
          {patch: invalid_attributes.merge(tags: tags_string)},
          valid_session
        )
        expect(assigns(:patch)).to be_a_new(VolcaShare::PatchViewModel)
      end

      it "re-renders the 'new' template" do
        post(
          :create,
          {patch: invalid_attributes.merge(tags: tags_string)},
          valid_session
        )
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let!(:user) do
        FactoryBot.create(:user, id: '123')
      end

      let(:new_attributes) do
        attributes_for(:patch, name: 'New Weird Patch', user_id: user.id)
      end

      it 'updates the requested patch' do
        patch = user.patches.build(valid_attributes)
        patch.save
        put(
          :update,
          {slug: patch.slug, patch: new_attributes.merge(tags: tags_string)},
          valid_session
        )
        patch.reload
        expect(patch.name).to eq(new_attributes[:name])
      end

      it 'assigns the requested patch as @patch' do
        patch = user.patches.build(valid_attributes)
        patch.save
        put(
          :update,
          {slug: patch.slug, patch: valid_attributes.merge(tags: tags_string)},
          valid_session
        )
        expect(assigns(:patch)).to eq(patch)
      end

      it 'redirects to the patch' do
        patch = user.patches.build(valid_attributes)
        patch.save
        put(
          :update,
          {slug: patch.slug, patch: valid_attributes.merge(tags: tags_string)},
          valid_session
        )
        expect(response).to redirect_to(user_patch_path(user.slug, patch.slug))
      end
    end

    context 'with invalid params' do
      it 'assigns the patch as @patch' do
        patch = Patch.create! valid_attributes
        put(
          :update,
          {
            slug: patch.to_param,
            patch: invalid_attributes.merge(tags: tags_string)
          },
          valid_session
        )
        expect(assigns(:patch)).to eq(patch)
      end

      it "re-renders the 'edit' template" do
        patch = Patch.create! valid_attributes
        put(
          :update,
          {
            slug: patch.to_param,
            patch: invalid_attributes.merge(tags: tags_string)
          },
          valid_session
        )
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is author' do
      it 'destroys the requested patch' do
        patch = Patch.create! valid_attributes.merge(user_id: User.first.id)
        expect do
          delete :destroy, { slug: patch.to_param }, valid_session
        end.to change(Patch, :count).by(-1)
      end

      it 'redirects to the patches index' do
        patch = Patch.create! valid_attributes.merge(user_id: User.first.id)
        delete :destroy, { slug: patch.to_param }, valid_session
        expect(response).to redirect_to(patches_url)
      end
    end

    context 'when user is not author' do
      it 'is disallowed' do
        patch = Patch.create! valid_attributes.merge(user_id: 'abc123')
        delete :destroy, { slug: patch.to_param }, valid_session
        expect(response).to redirect_to(patch_url(patch))
      end
    end
  end
end
