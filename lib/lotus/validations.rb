require 'lotus/utils/kernel'
require 'lotus/validations/version'

module Lotus
  module Validations
    def self.included(base)
      base.extend ClassMethods
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def valid?
      self.class.attributes.all? do |attribute, options|
        if value = @attributes.fetch(attribute) { nil }

          if coercer = options.fetch(:type) { nil }
            value = Lotus::Utils::Kernel.send(coercer.to_s, value)
          end

          @attributes[attribute] = value
        end

        if options.fetch(:presence) { nil }
          !send(attribute).nil?
        else
          true
        end
      end
    end

    module ClassMethods
      def attribute(name, options = {})
        attributes[name] = options

        class_eval %{
          def #{ name }
            @attributes[:#{ name }]
          end
        }
      end

      # FIXME make this private
      def attributes
        @attributes ||= Hash.new
      end
    end
  end
end
