require 'rails_helper'

RSpec.describe WhAttrib, type: :model do
  it 'fuzzy searching' do
    create(:wh_attrib, s_key: 'key1')
    create(:wh_attrib, s_key: 'key2')
    create(:wh_attrib, i_wh_attrib_group: 2)
    result = WhAttrib.fuzzy_searching('y1')
    expect(result.count).to be(2)
    expect(result.map(&:s_key).include?('key2'))
  end
end
