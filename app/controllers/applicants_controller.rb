class ApplicantsController < ApplicationController
  before_filter :authenticate_applicant, only: [:update]
  def new
    @applicant = Applicant.new
  end

  def create
    applicant = Applicant.new(clean_params)
    if applicant.save
      session[:applicant_id] = applicant.id
      render json: {message: "Successfully created application"}
    else
      render json: {errors: applicant.errors }, status: 400
    end
  end

  def update
    if current_applicant.update_attributes(clean_params)
      render json: {message: "Successfully updated application"}
    else
      render json: {errors: current_applicant.errors}, status: 400
    end
  end

  private

  def clean_params
    params.require(:applicant).permit(:first_name, :last_name, :email, :cell, :zipcode, :background_consent)
  end

  def authenticate_applicant
    return render json: {message: "Unauthorized access"}, status: 401 if !session[:applicant_id]
  end

  def current_applicant
    @applicant ||= Applicant.find(session[:applicant_id])
  end
end
