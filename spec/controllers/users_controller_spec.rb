require 'rails_helper'
require 'support/basic_user'
require 'support/routes'

describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:id) { user.id }
  it_should_behave_like 'routes', {
    new: {},
    show: { id: true, login: true },
    edit: { id: true, login: true }
  }

  describe 'GET auto_complete' do
    include_context 'basic user'

    let(:data) { JSON.parse(response.body)['data'] }

    it 'returns successful match' do
      get :auto_complete, q: controller.current_user.name
      expect(data.length).to eq 1
    end

    it 'returns nothing for unsuccessful match' do
      get :auto_complete, q: '#'
      expect(data.length).to eq 0
    end
  end

  describe 'GET activate' do
    let(:user) { create(:user, password: 'valid_password') }
    subject { get :activate, id: user.activation_token }

    context 'when valid' do
      it 'logs in user from correct token' do
        subject
        expect(controller.current_user).to eq user.reload
      end

      it 'redirects to the user groups' do
        expect(subject).to redirect_to user_groups_path
      end
    end

    context 'when invalid' do
      it 'fails to activate user from invalid token' do
        get :activate, id: user.id
        expect(controller.current_user).to eq nil
      end
    end
  end

  describe 'POST create' do
    context 'when valid' do
      subject { post :create, user: attributes_for(:user) }
      it 'should create the user' do
        expect { subject }.to change(User, :count).by 1
      end

      it 'should redirect to homepage' do
        expect(subject).to redirect_to root_path
      end
    end

    context 'when invalid' do
      subject { post :create, user: { name: '' } }

      it 'should not create a user' do
        expect { subject }.to_not change(User, :count)
      end

      it 'should render the new user template' do
        expect(subject).to render_template :new
      end
    end
  end

  describe 'PATCH update' do
    include_context 'basic user'

    it 'should update the user when valid' do
      patch :update, id: controller.current_user, user: { name: 'Updated User' }
      expect(controller.current_user.reload.name).to eq 'Updated User'
    end

    it 'should render edit when invalid' do
      patch :update, id: controller.current_user, user: { name: '' }
      expect(response).to render_template :edit
    end
  end
end
