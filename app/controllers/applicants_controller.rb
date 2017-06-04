class ApplicantsController < ApplicationController
  before_filter :authenticate_applicant, only: [:update]
  before_filter :enforce_date_range_params, only: [:funnels]

  def new
    @applicant = Applicant.new
  end

  def create
    applicant = Applicant.new(clean_params)
    if applicant.save
      session[:applicant_id] = applicant.id
      render json: {applicant: applicant}
    else
      render json: {errors: applicant.errors }, status: 400
    end
  end

  def update
    if current_applicant.update_attributes(clean_params)
      render json: {applicant: current_applicant}
    else
      render json: {errors: current_applicant.errors}, status: 400
    end
  end

  def establish_session
    current_applicant ||= Applicant.where(id: params[:id], email: params[:email]).first
    if current_applicant.nil?
      return render json: {message: "unauthorized action"}, status: 401
    else
      session[:applicant_id] = current_applicant.id
      return render json: {message: "session established"}
    end
  end

  def funnels
    render json: Applicant.retrieve_weekly_stats(params[:start_date], params[:end_date])
  end

  private

  def clean_params
    params.require(:applicant).permit(:first_name, :last_name, :email, :cell, :zipcode, :background_consent)
  end
end
