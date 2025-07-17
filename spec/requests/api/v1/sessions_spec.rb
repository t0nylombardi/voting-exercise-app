require "rails_helper"

RSpec.describe "API::V1::Sessions", type: :request do
  let(:email) { "offkeyandy@outofpitch.io" }
  let(:password) { "iForgotMyPwdAgain" }
  let(:zip_code) { "54321" }

  let(:valid_params) do
    { email: email, password: password, zip_code: zip_code }
  end

  describe "POST /api/v1/login" do
    context "when user does not exist" do
      it "creates a new user and sets session" do
        expect {
          post "/api/v1/login", params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:ok)
        expect(session[:user_id]).to eq(User.last.id)

        json = JSON.parse(response.body)
        expect(json["user"]["email"]).to eq(email)
      end
    end

    context "when user already exists" do
      before { User.create!(email: email, password: password, zip_code: zip_code) }

      it "reuses existing user and sets session" do
        expect {
          post "/api/v1/login", params: valid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:ok)
        expect(session[:user_id]).to eq(User.find_by(email: email).id)
      end
    end

    context "when email is missing" do
      it "returns an error" do
        post "/api/v1/login", params: valid_params.except(:email)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(session[:user_id]).to be_nil

        json = JSON.parse(response.body)
        expect(json["error"]).to include("email")
      end
    end

    context "when zip_code is missing" do
      it "returns an error" do
        post "/api/v1/login", params: valid_params.except(:zip_code)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(session[:user_id]).to be_nil

        json = JSON.parse(response.body)
        expect(json["error"]).to include("zip code")
      end
    end
  end

  describe "DELETE /api/v1/logout" do
    let!(:user) { User.create!(email: "out@example.com", password: "x", zip_code: "00000") }

    before do
      post "/api/v1/login", params: { email: user.email, password: "x", zip_code: "00000" }
      expect(session[:user_id]).to eq(user.id)
    end

    it "clears the session" do
      delete "/api/v1/logout"

      expect(response).to have_http_status(:no_content)
      expect(session[:user_id]).to be_nil
    end
  end
end
