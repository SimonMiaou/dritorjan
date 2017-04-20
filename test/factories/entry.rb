require 'dritorjan/models/entry'

FactoryGirl.define do
  factory :entry, class: 'Dritorjan::Models::Entry' do
    path nil
    dirname nil
    basename nil
    mtime { Time.now }
    size { rand(999) }
    scanned_at { Time.now }
  end

  factory :dir_entry, parent: :entry, class: 'Dritorjan::Models::DirEntry' do
  end

  factory :file_entry, parent: :entry, class: 'Dritorjan::Models::FileEntry' do
  end
end
