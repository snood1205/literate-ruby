require 'minitest/autorun'
require 'literate-ruby'

describe File do
  describe 'test file conversion' do
    literate_file = LiterateRuby::File.new('first_file.lrb', 'r')
    file_name = literate_file.parse
    lr = File.new(file_name, 'r').read
    compp = File.new('first_file_actual.rb', 'r').read
    it 'must show that the conversion works' do
      lr.must_equal compp
    end
  end
end
