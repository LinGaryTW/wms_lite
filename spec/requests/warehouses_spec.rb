require 'rails_helper'

RSpec.describe WarehousesController, type: [:controller, :request] do
  describe 'POST' do
    it 'validation_fail' do
      post '/warehouses', params: { key: 'aaa', value: 'aaa', whAttribGroup: 'aaa' }, as: :json
      expect(response.content_type).to eq("application/json; charset=utf-8")
      error_body = JSON.parse(response.body)['error']
      expect(error_body).to be_an_instance_of(Array) 
      expect(error_body.size).to eq(1)
      expect(error_body.all?(String)).to be true 
    end
  end
end
