require 'rails_helper'

RSpec.describe ApplicantsController, type: :controller do
  describe "#create" do
    context "valid params" do
      let(:applicant){double('applicant', save: true, id: 1)}
      it "sets the applicant_id in the session" do
        allow(Applicant).to receive(:new).and_return(applicant)
        post :create, applicant: FactoryGirl.attributes_for(:applicant)
        expect(session[:applicant_id]).to eq 1
        expect(response.status).to eq 200
      end
    end
    context "invalid params" do
      it "responds with an error" do
        user = double('user', save: false, errors: [])
        allow(Applicant).to receive(:new).and_return(user)
        post :create, applicant: FactoryGirl.attributes_for(:applicant)
        expect(response.status).to eq 400
      end
    end
  end

  describe "#update" do
    context "session is set" do
      before :each do
        session[:applicant_id] = FactoryGirl.create(:applicant).id
        expect(Applicant).to receive(:find).with(session[:applicant_id]).and_call_original
      end
      context "valid params" do
        it "succeeds" do
          expect_any_instance_of(Applicant).to receive(:update_attributes).and_return(true)
          put :update, applicant: {background_consent: true}
          expect(response.status).to eq 200
        end
      end

      context "invalid params" do
        it "fails" do
          expect_any_instance_of(Applicant).to receive(:update_attributes).and_return(false)
          put :update, applicant: {background_consent: true}
          expect(response.status).to eq 400
        end
      end
    end

    context "session not set" do
      it "returns a 401" do
        put :update
        expect(response.status).to be 401
      end
    end
  end
end
