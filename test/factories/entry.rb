require 'dritorjan/models/entry'

FactoryGirl.define do
  factory :entry, class: 'Dritorjan::Models::Entry' do
    type 'Dritorjan::Models::Entry'
    path nil
    dirname nil
    basename nil
    mtime { Time.now }
    size { rand(999) }
    scanned_at { Time.now }

    after(:build) do |entry|
      regex = %r{(.*)/([^/]+)\z}
      entry.path ||= Faker::File.file_name(entry.dirname)
      entry.dirname = entry.path.match(regex)[1]
      entry.basename = entry.path.match(regex)[2]
      puts entry.inspect
    end
  end

  factory :dir_entry, parent: :entry, class: 'Dritorjan::Models::DirEntry' do
    type 'Dritorjan::Models::DirEntry'
  end

  factory :file_entry, parent: :entry, class: 'Dritorjan::Models::FileEntry' do
    type 'Dritorjan::Models::FileEntry'
  end
end
