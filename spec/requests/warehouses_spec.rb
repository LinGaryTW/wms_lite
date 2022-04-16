require 'rails_helper'

RSpec.describe WarehousesController, type: [:controller, :request] do
  describe 'GET' do
    it 'order and group by i_whattrib_group' do
      attrib1 = create(:wh_attrib, s_key: 'title', s_value: 'book', i_index: 1)
      attrib2 = create(:wh_attrib, s_key: 'count', s_value: '10', i_index: 2)
      create(:wh_attrib, s_key: 'target', s_value: 'no one', i_wh_attrib_group: 2, i_index: 1)
      get '/warehouses/i'
      expected_data =
      [
        { 
          'whAttribGroup' => 1,
          'attribs' => [
            { 'key' => 'title', 'value' => 'book', 'id' => attrib1.id,
              'whAttribGroup' => attrib1.i_wh_attrib_group, 'index' => attrib1.i_index },
            { 'key' => 'count', 'value' => '10', 'id' => attrib2.id,
              'whAttribGroup' => attrib2.i_wh_attrib_group, 'index' => attrib2.i_index }
          ]
        }
      ]
      expect(json_result['data'].size).to be(1)
      expect(json_result['data']).to include_json(expected_data)
    end
  end

  describe 'POST' do
    it 'validation_fail' do
      post '/warehouses', params: { attribs: [ { key: 'aaa', value: 'aaa', index: 'aa' }], whAttribGroup: 1 }, as: :json
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:bad_request)
      expect(json_result['error']).to be_an_instance_of(Array) 
      expect(json_result['error'].size).to eq(1)
      expect(json_result['error'].all?(String)).to be true 
    end

    it 'defult create' do
      create(:wh_attrib)
      param = { attribs: [{ key: 'title', value: 'tt', index: 0 }, { key: 'count', value: '10', index: 1 }],
                whAttribGroup: nil }
      post '/warehouses', params: param, as: :json
      expect(response).to have_http_status(:ok)
      expect(WhAttrib.count).to be(3)
      expect(WhAttrib.where(i_wh_attrib_group: 2).count).to be(2)
      expect(WhAttrib.find_by(i_wh_attrib_group: 2, i_index: 0).s_key).to eq('title')
      expect(WhAttrib.find_by(i_wh_attrib_group: 2, i_index: 1).s_key).to eq('count')
    end

    it 'add to current group' do
      create(:wh_attrib)
      param = { attribs: [{ key: 'add to existed group', value: 'record', index: 100 }],
                whAttribGroup: 1 }
      post '/warehouses', params: param, as: :json
      expect(response).to have_http_status(:ok)
      expect(WhAttrib.find_by(s_key: 'add to existed group', s_value: 'record').present?).to be(true)
    end
  end

  describe 'PUT' do
    it 'update existed record' do
      existed_record = create(:wh_attrib, id: 10)
      param = { key: 'update key', value: 'update value', index: 5, whAttribGroup: 1 }
      put '/warehouses/10', params: param, as: :json
      existed_record.reload
      expect(existed_record.s_key).to eq('update key')
      expect(existed_record.s_value).to eq('update value')
      expect(existed_record.i_index).to eq(5)
    end

    it 'no record found' do
      param = { key: 'update key', value: 'update value', index: 5, whAttribGroup: 1 }
      put '/warehouses/10', params: param, as: :json
      expect(response).to have_http_status(:bad_request)
      expect(json_result['error']).to eq('No record found')
    end 
  end

  describe 'DELETE' do
    it 'delete existed record' do
      target = create(:wh_attrib)
      delete "/warehouses/#{target.id}"
      expect(WhAttrib.count).to be(0)
    end

    it 'delete but no record found' do
      create(:wh_attrib, id: 100)
      delete '/warehouses/1'
      expect(response).to have_http_status(:bad_request)
      expect(json_result['error']).to eq('No record found')
    end
  end

  def json_result
    @json_result ||= JSON.parse(response.body)
  end
end
