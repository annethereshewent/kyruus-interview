require 'rails_helper'


RSpec.describe CheckInsController, type: :controller do
  describe "routing" do
    it { should route(:get, "/check_ins/new").to(action: :new) }
    it { should route(:post, "/check_ins").to(action: :create) }
    it { should route(:get, "/check_ins/1").to(action: :show, id: 1) }
    it { should route(:put, "/check_ins/1").to(action: :update, id: 1) }
  end

  describe "GET #new" do
    it "renders the view" do
      get :new

      expect(response).to render_template(:new)
      expect(response).to render_with_layout(:application)
    end
  end

  describe "POST #create" do
    it "creates a new check_in" do
      allow(KyruusRequest).to receive(:get_patient_info).with(1).and_return({"firstName": "James", "lastName": "Smith"})
      expect { post(:create) }.to change(CheckIn, :count).by(1)
    end

    it "performs an http request" do
      check_in = create(:check_in, id: 1, patient_id: "1")
      patient = create(:patient, id: 1)

      allow(Patient).to receive(:find_or_create_by).and_return(patient)

      url = "https://dummyjson.com/users/#{patient.id}"

      allow(KyruusRequest).to receive(:get_patient_info).with(check_in.patient_id.to_i).and_return({"firstName": "James", "lastName": "Smith"})

      post :create

      expect(patient.first_name).to eq("James")
      expect(patient.last_name).to eq("Smith")

      expect(KyruusRequest).to have_received(:get_patient_info).with(check_in.patient_id.to_i)
    end

    it "redirects to the check_in show page" do
      check_in = create(:check_in, id: 1)
      allow(CheckIn).to receive(:create).and_return(check_in)

      allow(KyruusRequest).to receive(:get_patient_info).with(1).and_return({"firstName": "James", "lastName": "Smith"})

      post :create

      expect(CheckIn).to have_received(:create)
      expect(response).to redirect_to check_in_path(1)
    end

    it "finds or creates the patient from check_in" do
      check_in = create(:check_in, id: 1, patient_id: "1")
      patient = create(:patient, id: 1)

      allow(KyruusRequest).to receive(:get_patient_info).with(1).and_return({"firstName": "James", "lastName": "Smith"})
      allow(Patient).to receive(:find_or_create_by).and_return(patient)

      post :create

      expect(Patient).to have_received(:find_or_create_by).with(id: 1)
      expect(patient.first_name).to eq("James")
      expect(patient.last_name).to eq("Smith")
    end
  end

  describe "GET #show" do
    it "finds the check_in" do
      check_in = create(:check_in, id: 1, patient_id: "1")
      patient = create(:patient, id: 1)

      allow(CheckIn).to receive(:find).with("1").and_return(check_in)

      get :show, params: { id: 1 }

      expect(CheckIn).to have_received(:find).with("1")
    end

    it "finds the patient" do
      check_in = create(:check_in, id: 1, patient_id: "1")
      patient = create(:patient, id: 1)

      allow(Patient).to receive(:find).with(check_in.patient_id.to_i).and_return(patient)

      get :show, params: { id: 1 }

      expect(Patient).to have_received(:find).with(check_in.patient_id.to_i)
    end

    it "shows the current check in" do
      check_in = create(:check_in, id: 1, patient_id: "1")
      patient = create(:patient, id: 1)

      allow(CheckIn).to receive(:create).and_return(check_in)

      get :show, params: { id: 1 }

      expect(response).to render_template(:show)
      expect(response).to render_with_layout(:application)
    end
  end

  describe "PUT #update" do
    it "finds the check_in" do
      check_in = create(:check_in, id: 1)
      allow(CheckIn).to receive(:find).with("1").and_return(check_in)

      put :update, params: { id: 1 }

      expect(CheckIn).to have_received(:find).with("1")
    end

    it "updates the check_in" do
      check_in = create(:check_in, id: 1)
      allow(check_in).to receive(:update).with(
        question_1: 2,
        question_2: 3,
        screening_needed: true
      )
      allow(CheckIn).to receive(:find).with("1").and_return(check_in)

      put :update, params: { id: 1, question_1: "2", question_2: "3"}

      expect(check_in).to have_received(:update).with(
        question_1: 2,
        question_2: 3,
        screening_needed: true
      )
    end

    it "redirects back to the check_in page with results" do
      check_in = create(:check_in, id: 1)
      allow(CheckIn).to receive(:find).with("1").and_return(check_in)

      put :update, params: { id: 1 }

      expect(response).to redirect_to check_in_path(1)
    end

    it "throws an alert on bad validation" do
      check_in = create(:check_in, id: 1)

      put :update, params: { id: 1 }

      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq("Please fill out all of the form.")
    end
  end
end
