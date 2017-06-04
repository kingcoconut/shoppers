require 'rails_helper'

RSpec.describe ApplicantsController, type: :controller do
  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end
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

  describe "#funnels" do
    context "invalid params" do
      it "returns a 400" do
        get :funnels
        expect(response.status).to eq 400
      end

      it "does not allow params that are not dates" do
        get :funnels, start_date: "foo", end_date: [], :format => :json
        expect(response.status).to eq 400
      end
    end

    context "valid params" do
      it "queries applicants for date range" do
        start_date = "1980-01-01"
        end_date = "1990-01-01"
        result = {foo: "bar"}
        expect(Applicant).to receive(:retrieve_weekly_stats).with(start_date, end_date).and_return(result)
        get :funnels, start_date: start_date, end_date: end_date
        expect(response.status).to eq 200
        expect(response.body).to eq result.to_json
      end
    end
  end
end
