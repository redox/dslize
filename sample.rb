#! /usr/bin/env ruby

begin
  # dev mode
  require File.dirname(__FILE__) + '/lib/dslize'
rescue
  require 'dslize'
end

module DSLize::Methods
  include DSLize::Methods::Base
  
  def self.my_first_custom_method(attr, args = {})
    args[:type] = :custom
    DSLize.current_object[attr] = args
  end
  
  def self.my_second_custom_method
    DSLize.current_object['baz'] = true
  end
  
end

module DSLize::Definition
  
  class City
    string :name
    integer :population, :default => 42
  end
  
  class Country
    string :name, :default => 'France'
    
    has_many City, :as => :cities
    
    has_one City, :as => :capital
  end
  
  class World
    root
    
    has_many Country
    
    my_first_custom_method :foo, :default => 'bar'
    
    my_second_custom_method
  end
  
  class Planet
    abstract
  end
  
  class GazPlanet < Planet
  end
  
  class WaterPlanet < Planet
  end
  
end

DSLize::Formatter::XSD.new.generate!(ARGV[0])
