class DashboardController < ApplicationController
  before_filter :enforce_date_range_params, only: [:funnels, :applicants]

  def index
    render layout: "dashboard"
  end

  def funnels
    render json: Applicant.retrieve_admin_stats(params[:start_date], params[:end_date])
  end

  def applicants
    end_date = Date.parse(params[:end_date]) + 1.day
    render json: Applicant.includes(:linkedin_account).where("created_at BETWEEN ? AND ?", params[:start_date], end_date).to_json(include: [:linkedin_account])
  end
end
