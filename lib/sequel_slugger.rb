require 'stringex'

module Sequel
  module Plugins
    module Slugger
      DEFAULT_TARGET_COLUMN = :slug

      def self.configure(model, opts={})
        model.slugger_options = opts
        model.slugger_options.freeze

        model.class_eval do
          define_method("#{slugger_options[:target]}=") do |value|
            slug = to_slug(value)
            super(slug)
          end
        end
      end

      module ClassMethods
        attr_reader :slugger_options

        def find_by_slug(value)
          self[@slugger_options[:target] => value.chomp]
        end

        def inherited(klass)
          super
          klass.slugger_options = self.slugger_options.dup
        end

        # Set the plugin options
        #
        # Options:
        # @param [Hash] plugin options
        # @option update  [Boolean]:Does slug auto-update? Default to false.
        # @option source  [Symbol] :Column to get value to be slugged from.
        # @option target  [Symbol] :Column to write value of the slug to.
        def slugger_options=(options)
          raise ArgumentError, "Slugger requires :source column" unless options[:source]
          options[:source] = options[:source].to_sym
          options[:target] = options[:target] ? options[:target].to_sym : DEFAULT_TARGET_COLUMN
          options[:update] = options[:update].nil? ? false : !!options[:update]
          @slugger_options = options
        end
      end

      module InstanceMethods
        def before_validation
          super
          target = self.class.slugger_options[:target]
          updateable = self.class.slugger_options[:update]
          set_target_column if updateable or self.send(target).nil?
        end

        private

        def to_slug(value)
          # TODO: use Stringex#to_url without polluting ruby String
          value.to_url if value.respond_to?(:to_url) # Stringex
        end

        def set_target_column
          target = self.class.slugger_options[:target]
          source = self.class.slugger_options[:source]
          self.send("#{target}=", self.send(source))
        end
      end
    end # Slugger
  end # Plugins
end # Sequel
