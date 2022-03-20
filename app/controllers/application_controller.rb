class ApplicationController < ActionController::API
  before_action :validate_by_json

  def validate_by_json
    action = params[:action]
    schema = Rails.application.config.json_shcema[controller]["#{action}.json"]
    valid = JSON::Validator.fully_validate(schema)
    unless valid.blank?
      
    end
  end
end
