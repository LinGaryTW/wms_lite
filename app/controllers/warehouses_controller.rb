class WarehousesController < ApplicationController
  before_action :find_wh_attrib, only: [:update, :destroy]

  def show
    last_attrib = {}
    result = []
    WhAttrib.fuzzy_searching(params[:key_word]).order(:i_wh_attrib_group, :i_index)
            .each_with_index do |attrib, index|
      if last_attrib['attribGroup'] == attrib[:i_wh_attrib_group]
        last_attrib['attribs'] << { 'key' => attrib.s_key, 'value' => attrib.s_value, 'id' => attrib.id }
      else
        result << last_attrib unless index.zero?
        last_attrib = {}
        last_attrib['attribGroup'] = attrib.i_wh_attrib_group
        last_attrib['attribs'] = [{ 'key' => attrib.s_key, 'value' => attrib.s_value, 'id' => attrib.id }]
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
    WhAttrib.insert_all(attribs)

    render json: { result: true, data: '', error: '' }
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
