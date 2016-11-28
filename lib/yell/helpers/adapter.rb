# frozen_string_literal: true
module Yell #:nodoc:
  module Helpers #:nodoc:
    module Adapter #:nodoc:
      # Define an adapter to be used for logging.
      #
      # @example Standard adapter
      #   adapter :file
      #
      # @example Standard adapter with filename
      #   adapter :file, 'development.log'
      #
      #   # Alternative notation for filename in options
      #   adapter :file, :filename => 'developent.log'
      #
      # @example Standard adapter with filename and additional options
      #   adapter :file, 'development.log', :level => :warn
      #
      # @example Set the adapter directly from an adapter instance
      #   adapter Yell::Adapter::File.new
      #
      # @param type [Symbol] The type of the adapter (default `:file`)
      # @return [Yell::Adapter] The instance
      # @raise [Yell::NoSuchAdapter] Will be thrown when the adapter undefined
      def adapter(type = :file, *args, &block)
        adapters.add(type, *args, &block)
      end

      def adapters
        @__adapters__
      end

      private

      def reset!(options = {})
        # rubocop:disable Style/VariableNumber
        @__adapters__ = Yell::Adapters::Collection.new
        # rubocop:enable Style/VariableNumber

        presets = Yell.__fetch__(options, :adapters, default: [], delete: true)
        presets.each do |preset|
          if preset.is_a?(Hash)
            Array(preset).each { |type, name| adapter(type, name, options) }
          else
            adapters.add(preset, options)
          end
        end

        super(options)
      end
    end
  end
end
