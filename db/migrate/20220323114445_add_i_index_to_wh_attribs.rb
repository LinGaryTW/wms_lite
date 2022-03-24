class AddIIndexToWhAttribs < ActiveRecord::Migration[7.0]
  def change
    add_column :wh_attribs, :i_index, :integer
  end
end
