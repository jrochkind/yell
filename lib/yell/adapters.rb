# frozen_string_literal: true
module Yell #:nodoc:
  # AdapterNotFound is raised whenever you want to instantiate an
  # adapter that does not exist.
  class AdapterNotFound < StandardError; end

  # This module provides the interface to attaching adapters to
  # the logger. You should not have to call the corresponding
  # classes directly.
  module Adapters
    class Collection #:nodoc:
      def initialize
        @collection = []
      end

      def add(type = :file, *args, &block)
        options = args.inject({}) do |h, c|
          h.merge([String, Pathname].include?(c.class) ? { filename: c } : c)
        end

        add! Yell::Adapters.new(type, options, &block)
      end

      def empty?
        @collection.nil? || @collection.is_a?(Array) && @collection.empty?
      end

      # @private
      def write(event)
        if @collection.respond_to?(:write)
          @collection.write(event)
        else
          @collection.each { |c| c.write(event) }
        end

        true
      end

      # @private
      def close
        if @collection.respond_to?(:close)
          @collection.close
        else
          @collection.each(&:close)
        end
      end

      private

      def add!(adapter)
        # remove possible :null adapters
        if @collection.is_a?(Array) &&
           @collection.first.instance_of?(Yell::Adapters::Base)
          @collection.shift
        end

        # add to collection
        @collection = [adapter, *@collection]
        @collection = @collection.first if @collection.length == 1

        adapter
      end
    end

    # holds the list of known adapters
    @adapters = {}

    # Register your own adapter here
    #
    # @example
    #   Yell::Adapters.register(:myadapter, MyAdapter)
    def self.register(name, klass)
      @adapters[name.to_sym] = klass
    end

    # Returns an instance of the given processor type.
    #
    # @example A simple file adapter
    #   Yell::Adapters.new(:file)
    def self.new(name, options = {}, &block)
      return name if name.is_a?(Yell::Adapters::Base)

      adapter = case name
                when STDOUT then @adapters[:stdout]
                when STDERR then @adapters[:stderr]
                else @adapters[name.to_sym]
                end

      raise(AdapterNotFound, name) if adapter.nil?
      adapter.new(options, &block)
    end
  end
end

# Base for all adapters
require File.dirname(__FILE__) + '/adapters/base'

# IO based adapters
require File.dirname(__FILE__) + '/adapters/io'
require File.dirname(__FILE__) + '/adapters/streams'
require File.dirname(__FILE__) + '/adapters/file'
require File.dirname(__FILE__) + '/adapters/datefile'
