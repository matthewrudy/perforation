module Perforation
  class Actor

    def initialize(options={})
      @agent = Mechanize.new
      @agent.user_agent = 'fake Firefox (really mechanize)'
      @agent.max_history=1 # save memory
      @options = options.with_indifferent_access
    end
    attr_reader :agent
    class_inheritable_accessor :domain

    class << self
      def subclass_variables(*vars)
        @subclass_variables = vars

        vars.each do |var|
          define_method(var) do # def login
            @options[var]       #   @options[:login]
          end                   # end
        end
      end
    end

    # the "focus" is the page we care about right now
    # - perhaps we're opening multiple unrelated pages
    #   but we only care about the "queue" page
    #
    def set_focus!(page=nil)
      @focus = page || @agent.current_page
    end
    attr_reader :focus

    def verbose?
      ENV["VERBOSE"]
    end

    def get(path, headers={})
      @agent.get(:url => request_path(path), :headers => headers)
    end

    def post(path, params={}, headers={})
      @agent.post(request_path(path), params, headers)
    end

    XHR_HEADERS = {"X-REQUESTED-WITH" => "XMLHttpRequest"}
  
    def xhr_get(path)
      self.get(path, XHR_HEADERS)
    end
  
    def xhr_post(path, params={})
      self.post(path, params, XHR_HEADERS)
    end

    def speak(words)
      if verbose?
        speak!(words)
      end
    end

    def speak!(words)
      puts words
    end

    protected

    def request_path(path)
      puts "request to #{path.inspect}" if verbose?
      URI.join(self.domain, path)
    end

  end
end