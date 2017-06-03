class LinkedinAccountsController < ApplicationController
  def create
    account = LinkedinAccount.new(clean_params)
    account.applicant = current_applicant
    if account.save
      render json: {message: "Successfully saved LinkedIn account"}
    else
      render json: {errors: account.errors}, status: 400
    end
  end

  private

  def clean_params
    #normalize data on backend
    permitted = params.require(:account).permit(:id, :firstName, :lastName, :numConnections, :industry, :pictureUrl, :publicProfileUrl, location: [:name])
    permitted["location"] ||= {"name":nil}
    {
      linkedin_id: permitted["id"],
      first_name: permitted["firstName"],
      last_name: permitted["lastName"],
      num_connections: permitted["numConnections"],
      industry: permitted["industry"],
      location: permitted["location"]["name"],
      public_profile_url: permitted["publicProfileUrl"],
      picture_url: permitted["pictureUrl"]
    }
  end
end
