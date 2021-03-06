require 'rails_helper'

describe UsersController do
  describe 'GET new' do
    it "renders the registration template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    context 'with missing inputs' do
      it "renders the registration template" do
        post :create, user: {email: '', password: ''}
        expect(response).to render_template :new
      end
    end

    context "with a matching email address from QuickBase" do
      before do
        @user = User.new(email: 'test@example.com', password: 'password')
        allow(User).to receive(:where).and_return([@user])
      end

      it "creates a new User" do
        expect_any_instance_of(User).to receive(:save)
        post :create, user: {email: @user.email, password: @user.password}
      end

      it "sets the user's encrypted password" do
        allow_any_instance_of(User).to receive(:save)
        post :create, user: {email: @user.email, password: @user.password}
        expect(assigns(:user).encrypted_password).to be_present
      end

      it "sets the user's token" do
        allow_any_instance_of(User).to receive(:save)
        post :create, user: {email: @user.email, password: @user.password}
        expect(assigns(:user).token).to be_present
      end
    end

    context "with a non-matching email address from QuickBase" do
      it "renders the registration template" do
        user = User.new(email: 'not_a_match@example.com', password: 'password')
        post :create, user: {email: user.email, password: user.password}
        expect(response).to render_template :new
      end
    end
  end
end