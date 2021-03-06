class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_applicant

  private

  def enforce_date_range_params
    begin
      return render_400 unless params[:start_date].to_date && params[:end_date].to_date
    rescue
      return render_400
    end
  end

  def authenticate_applicant
    unless session[:applicant_id]
      respond_to do |format|
        format.json {render json: {message: "Unauthorized access"}, status: 401}
        format.html {redirect_to applicant_login_path}
      end
    end
  end

  def current_applicant
    @current_applicant ||= Applicant.find(session[:applicant_id]) if session[:applicant_id]
  end

  rescue_from ActiveRecord::RecordNotFound do
    render_404
  end

  rescue_from ActiveRecord::RecordNotUnique do
    render_400
  end

  rescue_from ActiveRecord::InvalidForeignKey do
    render_400
  end

  rescue_from ActionController::ParameterMissing do
    render_400
  end

  def render_404
    respond_to do |format|
      format.json {
        render json: { error: "Not found" }.to_json, status: 404
      }
      format.html{
        render :file => "public/404.html", status: :not_found, layout: false
      }
    end
  end

  def render_400
    respond_to do |format|
      format.json {
        render json: { error: "Client sent a poorly formed request" }.to_json, status: 400
      }
      format.html{
        redirect_to root_path
      }
    end
  end


end
