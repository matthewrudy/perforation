module Perforation
  class Runner
    
    def self.run(agent_class)
      self.new(agent_class).run(ARGV)
    end
    
    attr_accessor :children
    attr_accessor :agent_class
    
    def initialize(agent_class)
      @agent_class = agent_class
      @children = []
    end

    def run(args)
      process_count = args[0].to_i
      repeat_count = args[1].to_i
      round_robin_size = args[2] ? args[2].to_i : 1
      instance_number = args[3] ? args[3].to_i : 1

      total_agents = process_count * round_robin_size

      offset = (instance_number - 1) * total_agents # with 100 agents, it is 0 for instance 1, 100 for instance 2...
  
      self.children = []
      1.step(total_agents, round_robin_size) do |i| # 1..100, 101..200, ...
        self.children << fork do

          Performer.new(round_robin_size, offset+i) do |agent_index|
            agent_class.new(agent_index)
          end.do!(repeat_count)
          
        end
      end

      Signal.trap('INT')  { Process.kill("INT",  *self.children) }
      Signal.trap('TERM') { Process.kill("TERM", *self.children) }

      Process.waitall
    end
  end
end
