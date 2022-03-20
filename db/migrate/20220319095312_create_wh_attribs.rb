class CreateWhAttribs < ActiveRecord::Migration[7.0]
  def change
    create_table :wh_attribs do |t|
      t.text :s_key
      t.text :s_value
      t.integer :i_wh_attrib_group

      t.timestamps
    end
  end
end
