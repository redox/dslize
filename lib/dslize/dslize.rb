class Object

  def self.method_missing(method_name, *args, &block)
    return DSLize::Methods.send(method_name, *args) if self.name['DSLize::Definition::'] and DSLize::Methods.respond_to?(method_name)
    super.method_missing(method_name, args, &block)
  end

  def self.inherited(subclass)
    if subclass.name['DSLize::Definition::']
      superclass = subclass.superclass
      subclass = subclass.name.split('::').last
      DSLize.objects ||= {}
      DSLize.objects[subclass] = {}
      DSLize.current_object = DSLize.objects[subclass]
      DSLize.superclasses ||= {}
      DSLize.superclasses[subclass] = superclass.name.split('::').last
    end
  end
  
end

module DSLize
  
  class << self
    attr_accessor :objects
    attr_accessor :current_object
    attr_accessor :superclasses
  end  

  module Methods
    
    module Base
      
      def self.included(receiver)
        receiver.extend(ClassMethods)
      end

      module ClassMethods
        
        def string(attr, args = {})
          attribute(:string, attr, args)
        end

        def integer(attr, args = {})
          attribute(:integer, attr, args)
        end        
        
        def double(attr, args = {})
          attribute(:double, attr, args)
        end        
        
        def has_many(attr, args = {})
          relation(:has_many, attr, args)
        end

        def has_one(attr, args = {})
          relation(:has_one, attr, args)
        end

        def root
          DSLize.current_object[:root] = true
        end
        
        def abstract
          DSLize.current_object[:abstract] = true
        end
        
        private
        def attribute(type, name, args)
          args[:type] = type
          DSLize.current_object[:attributes] = {}
          DSLize.current_object[:attributes][name] = args
        end
        
        def relation(type, name, args)
          name = (name.name rescue name.to_s).split('::').last
          args[:type] = name
          if as = args.delete(:as)
            name = as.to_s
          end
          DSLize.current_object[type] ||= {}
          DSLize.current_object[type][name] = args
        end
        
      end
      
    end
  
  end
  
end
