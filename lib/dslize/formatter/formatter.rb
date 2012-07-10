module DSLize
  module Formatter
    
    class Base
      attr_accessor :objects
      attr_accessor :superclasses
      
      def initialize
        self.objects = DSLize.objects
        self.superclasses = DSLize.superclasses
      end
    end
    
  end
  
end
