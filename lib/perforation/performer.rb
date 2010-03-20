module Perforation
  class Performer
    
    def initialize(round_robin_size, i)
      @round_robin = []

      (0...round_robin_size).each do |j|
        @round_robin << yield(i+j)
      end
    end
    attr_accessor :round_robin

    def do!(repeat_count)
      done = false # done must be declared in scope before the Signal blocks

      Signal.trap('INT')  { done = true }
      Signal.trap('TERM') { exit }

      started_at = Time.now

      perform() do |agent|
        agent.start
      end

      repeats = 0
      while repeats < repeat_count && !done
        repeats += 1
        perform() do |agent|
          agent.perform
        end
        puts repeats
      end

      perform() do |agent|
        agent.stop
      end

      puts "pid:#{Process.pid} repeats:#{repeats} round_robin:#{self.round_robin.length} time:#{Time.now - started_at}"
    end

    def perform
      begin
        self.round_robin.each do |agent|
          yield(agent)
        end
      rescue RuntimeError => e
        puts "encountered an exception #{e.message}"
      end
    end
    
  end
end