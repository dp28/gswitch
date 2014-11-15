module GSwitch
  class Options

    attr_reader :branch, :set_flags, :quiet

    def initialize argv
      @set_flags = []
      @parser = OptionParser.new 
      @quiet = false
      setup_parser
      @branch = @parser.parse argv
      @set_flags.uniq!
    end

    private

      def setup_parser
        @parser.on("-q", "--quiet",   "Run without output")   { @quiet = true                 }
        @parser.on("-c", "--current", "Show current branch")  { add_flag :show_current_branch }
        @parser.on("-t", "--top",     "Show top of stack")    { add_flag :show_top            }
        @parser.on("-s", "--stack",   "Show full stack")      { add_flag :show_stack          }
        @parser.on("-h", "--help",    "Print help message")   { add_flag :show_help           }

        @parser.on("-P", "--pop", "Pop top branch from history stack without checking it out") do 
          add_flag :pop 
        end

        @parser.on("-p", "--push", "Push current branch to history without changing branch") do 
          add_flag :push 
        end
      end

      def add_flag flag
        @set_flags << flag
      end
  end
end