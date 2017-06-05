class ApplicantsController < ApplicationController
  before_filter :authenticate_applicant, only: [:update, :edit]
  before_filter :enforce_date_range_params, only: [:funnels]

  def new
    @applicant = Applicant.new
  end

  def edit
    @applicant = current_applicant
    render layout: "edit"
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
    @applicant = current_applicant
    if @applicant.update_attributes(clean_params)
      respond_to do |format|
        format.json { render json: {applicant: current_applicant} }
        format.html { render layout: "edit" }
      end
    else
      respond_to do |format|
        format.json { render json: {errors: current_applicant.errors}, status: 400}
        format.html {
          render :edit, layout: "edit"
        }
      end
    end
  end

  def establish_session
    # We are using like for the cell phone lookup to handle the case when they signed up with a international code prepended on their number
    # but are now supplying their numbr without the code added. Therefore we must enforce that the cell value is atleast length 10 to prevent abuse
    current_applicant ||= Applicant.where("cell LIKE ?", "%#{params[:cell]}%").where(email: params[:email]).first if params[:cell].length >= 10
    if current_applicant.nil?
      @invalid = true
      respond_to do |format|
        format.json { render json: {message: "unauthorized action"}, status: 401 }
        format.html { render :login, layout: "edit" }
      end
    else
      session[:applicant_id] = current_applicant.id
      respond_to do |format|
        format.json { render json: {message: "session established"} }
        format.html { redirect_to applicant_edit_path }
      end
    end
  end

  def destroy_session
    session.delete(:applicant_id)
    render json: {}
  end

  def funnels
    render json: Applicant.retrieve_weekly_stats(params[:start_date], params[:end_date])
  end

  private

  def clean_params
    params.require(:applicant).permit(:first_name, :last_name, :email, :cell, :zipcode, :background_consent)
  end
end
