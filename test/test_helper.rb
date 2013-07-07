ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require_relative '../app'
require_relative 'fixtures'

module TestHelpers
  module ClassMethods
    
    def test(name, &block)
      test_name = name.split.unshift('test').join('_')
      define_method test_name, &block
    end
    
    def setup(&block)
      define_method 'setup', &block
    end
    
  end
  def self.included(base)
    base.extend ClassMethods
  end
end

class Test < MiniTest::Unit::TestCase
  include TestHelpers
end