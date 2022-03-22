class ApplicationController < ActionController::API
  before_action :validate_by_json

  def validate_by_json
    schema = Rails.application.config.json_shcema[params[:controller]]["#{params[:action]}.json"]
    valid = JSON::Validator.fully_validate(schema, params.to_json)
    unless valid.blank?
      render json: { result: '', data: '', error: valid }
    end
  end
end
