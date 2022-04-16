class WarehousesController < ApplicationController
  before_action :find_wh_attrib, only: [:update, :destory]

  def show
    last_attrib = {}
    result = []
    WhAttrib.fuzzy_searching(params[:key_word]).order(:i_wh_attrib_group, :i_index)
            .each_with_index do |attrib, index|
      mapped_record = {
        'key' => attrib.s_key, 'value' => attrib.s_value, 'id' => attrib.id,
        'index' => attrib.i_index, 'whAttribGroup' => attrib.i_wh_attrib_group
      }
      if last_attrib['whAttribGroup'] == attrib[:i_wh_attrib_group]
        last_attrib['attribs'] << mapped_record
      else
        result << last_attrib unless index.zero?
        last_attrib = {}
        last_attrib['whAttribGroup'] = attrib.i_wh_attrib_group
        last_attrib['attribs'] = [mapped_record]
      end
    end
    result << last_attrib if last_attrib.present?
    render json: { result: result.present?, data: result, error: '' }
  end

  def create
    attribs = params[:attribs].map do |a|
       { s_key: a[:key], s_value: a[:value], i_index: a[:index],
         i_wh_attrib_group: params[:whAttribGroup] || (WhAttrib.last&.i_wh_attrib_group || 0) + 1 }
    end
    ids = 
    WhAttrib.insert_all(attribs, returning: %w[id s_key s_value i_index i_wh_attrib_group])
            .rows.each_with_object({ 'attribs' => [] }) do |attrib, result|
              mapped_record = {
                'key' => attrib[1], 'value' => attrib[2], 'id' => attrib[0],
                'index' => attrib[3], 'whAttribGroup' => attrib[4]
              }
              result['whAttribGroup'] = attrib[4] if result['whAttribGroup'].nil?
              result['attribs'] << mapped_record
            end

    render json: { result: true, data: ids, error: '' }
  end

  def update
    @wh_attrib.update(s_key: params[:key], s_value: params[:value],
                      i_index: params[:index], i_wh_attrib_group: params[:whAttribGroup])
    
    render json: { result: true, data: '', error: '' }
  end

  def destory
    @wh_attrib.delete

    render json: { result: true, data: '', error: '' }
  end

  private

  def find_wh_attrib
    begin
      @wh_attrib = WhAttrib.find(params[:id])
    rescue
      render json: { result: false, data: '', error: 'No record found' }, status: :bad_request 
    end
  end
end
