class WhAttrib < ApplicationRecord
  def self.fuzzy_searching(key_word)
    group = WhAttrib.where("s_key like ? or s_value like ?", "%#{key_word}%", "%#{key_word}%")
                    .pluck('distinct i_wh_attrib_group')

    WhAttrib.where(i_wh_attrib_group: group)
  end
end
