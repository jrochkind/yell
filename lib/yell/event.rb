require 'time'
require 'socket'
require 'English'

module Yell #:nodoc:
  # Yell::Event.new( :info, 'Hello World', { :scope => 'Application' } )
  # #=> Hello World scope: Application
  class Event
    # Accessor to the log level
    attr_reader :level

    # Accessor to the log message
    attr_reader :messages

    # Accessor to the time the log event occured
    attr_reader :time

    # Accessor to the logger's name
    attr_reader :name

    # Accessor to the hostname
    attr_reader :hostname

    def initialize(logger, level, *messages)
      @time = Time.now
      @hostname = Socket.gethostname

      @name = logger.name
      @level = level
      @messages = messages
    end

    # Accessor to the progname
    def progname
      $PROGRAM_NAME
    end

    # Accessor to the PID
    def pid
      $PROCESS_ID
    end

    # Accessor to the thread's id
    def thread_id
      Thread.current.object_id
    end
  end
end
