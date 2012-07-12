module DSLize
  module Formatter
    
    class Base
      attr_accessor :objects
      attr_accessor :superclasses
      
      def initialize
        self.objects = DSLize.objects
        self.superclasses = DSLize.superclasses
      end
      
      protected
      def get_subclasses(type)
        superclasses.select { |k,v| v.to_s == type.to_s }.keys
      end
    end
    
  end
  
end
