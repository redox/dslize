require File.dirname(__FILE__) + '/formatter'

module DSLize
  module Formatter
    
    class XSD < Base
      
      def generate!(*args)
        schema = XPain::Builder.new do |xsd|
          xsd.schema do
            objects.each do |name, options|
              parent = superclasses[name]
              
              xsd.element(name, :type => (options[:type] or name))
              
              xsd.complexType({ :name => name, :abstract => options[:abstract], :mixed => false }.select { |k,v| !v.nil? }) do
                extends_base_if_needed(xsd, parent) do
                  
                  # relations
                  xsd.sequence do
                    { :has_one => nil, :has_many => "unbounded"}.each do |relation, max_occurs|
                      (options[relation] or []).each do |k, v|
                        named_object_if_needed(xsd, k, v) do
                          clazz = v[:type] or k
                          subclasses = get_subclasses(clazz)
                          if subclasses.empty?
                            xsd.element(nil, { :ref => clazz, :maxOccurs => max_occurs }.select { |k,v| !v.nil? })
                          else
                            xsd.choice({ :maxOccurs => max_occurs }.select { |k,v| !v.nil? }) do
                              subclasses.each do |sub_type|
                                xsd.element(nil, :ref => sub_type)
                              end
                              if !objects[clazz][:abstract]
                                xsd.element(nil, :ref => clazz)
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                
                  # attributes
                  (options[:attributes] or []).each do |k, v|
                    xsd.attribute({ :name => k, :default => v[:default], :type => xsd_type(v[:type]) }.select { |k,v| !v.nil? })
                  end
                  
                end
              end
              
            end
          end
        end
        
        File.open(args[0], "w") do |f|
          f << schema.to_xml.gsub(' name=""', '') # xpain is buggy and always write a name on <element>
        end
      end
      
      private
      def extends_base_if_needed(xsd, parent)
        if parent != "Object"
          xsd.complexContent :mixed => false do
            xsd.extension :base => parent do
              yield
            end
          end
        else
          yield
        end
      end
      
      def named_object_if_needed(xsd, name, options)
        if options[:type] and name != options[:type]
          xsd.element name, :contains => 'none' do
            xsd.complexType do
              xsd.sequence do
                yield
              end
            end
          end
        else
          yield
        end
      end
      
      def xsd_type(type)
        case type
        when :float
          "xsd:double"
        when :integer
          "xsd:int"
        when :string
          "xsd:string"
        else
          type
        end
      end
      
    end
  
  end
  
end
