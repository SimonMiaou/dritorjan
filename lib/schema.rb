ActiveRecord::Schema.define do
  unless table_exists? :entries
    create_table :entries do |t|
      t.string   :file_path, null: false
      t.string   :dirname,   null: false
      t.string   :basename,  null: false
      t.datetime :mtime,     null: false
      t.bigint   :size,      null: false
    end
    add_index :entries, :file_path
  end
end
