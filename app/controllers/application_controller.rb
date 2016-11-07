require 'httparty'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def ask_chiquito
    query_string = params[:query].gsub(' ','%20')
    space_id = '0oukhz971j01'
    ms_bot_access_token = 'dd8fa5d22dab7adbf2190c2ba368d0cb20f8dc6119e5f516c3eb42a7846c2c83'
    @api_response = HTTParty.get("https://cdn.contentful.com/spaces/#{space_id}/entries?access_token=#{ms_bot_access_token}&query=#{query_string}")
    search_pair = {}
    JSON.parse(@api_response)['items'].each do |content|
      search_pair[content['sys']['id']] = content['fields']
    end
    search_pair = search_pair.values[0]
    if search_pair.present?
      response = search_pair['replies']
    end
    render json: { response: response.present? ? response : 'What?', request: params[:query] }
  end
end
