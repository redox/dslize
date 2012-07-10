# DSLize #

## Summary ##

Finally an way to generate code with a custom DSL the ruby way !

### In brief: ###

*  Use real ruby classes to define your DSL
*  Add custom behaviors defining ruby methods
*  Create custom formatters/generators extending a base class
*  Module `DSLize::Methods` defines your attributes types, include `DSLize::Methods::Base` to import the standard attributes
*  Module `DSLize::Definition` defines your classes

## Installation ##

    gem install dslize

then:

    require "dslize"

## Sample ##

    #! /usr/bin/env ruby
    
    require 'dslize'
    
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
    
    class MyCustomFormatter < DSLize::Formatter::Base
      def do_stuff
        # with self.object
        # and self.superclasses
      end
    end
    
    DSLize::Formatter::XSD.new.generate!("/tmp/schema.xsd")
    MyCustomFormatter.new.do_stuff
    
## About me ##

Sylvain UTARD - http://sylvain.utard.info
