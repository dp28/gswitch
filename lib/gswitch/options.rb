module GSwitch
  class Options

    attr_reader :branch, :set_flags, :quiet

    def initialize argv
      @set_flags = []
      @parser = OptionParser.new 
      @quiet = false
      setup_parser
      @branch = @parser.parse(argv).first
      @set_flags.uniq!
    end

    def print_help
      puts @parser
    end

    private

      def setup_parser
        @parser.banner = "Usage: gswitch [-bcmwHPpsthq] [branch]"
        git_options
        stack_options
        other_options
      end

      def git_options
        @parser.separator ""
        @parser.separator "Git options:"   
        @parser.on("-b", "--back",    back_description)       { add_flag :back                }
        @parser.on("-c", "--current", "Show current branch.") { add_flag :show_current_branch }
        @parser.on("-m", "--move",    move_description)       { add_flag :move                }

      end

      def stack_options
        @parser.separator ""
        @parser.separator "History stack options:"   
        @parser.on("-w", "--wipe",    wipe_description)       { add_flag :wipe                }
        @parser.on("-H", "--height",  "Show stack height.")   { add_flag :show_stack_height   }
        @parser.on("-P", "--pop",     pop_description)        { add_flag :pop                 }
        @parser.on("-p", "--push",    push_description)       { add_flag :push                }
        @parser.on("-s", "--stack",   "Show full stack.")     { add_flag :show_stack          } 
        @parser.on("-t", "--top",     "Show top of stack.")   { add_flag :show_top            }  
      end

      def other_options
        @parser.separator ""
        @parser.separator "Other options:"
        @parser.on("-h", "--help",    "Print this message.")  { add_flag :show_help }
        @parser.on("-q", "--quiet",   "Run without output.")  { @quiet = true       }
      end

      def add_flag flag
        @set_flags << flag
      end

      def push_description 
        """Push a branch to history without changing
           \t\t\t     branch. If no branch is specified, the 
           \t\t\t     current branch is pushed.\n  """
      end

      def pop_description 
        """Pop top branch from history stack without
           \t\t\t     checking it out.\n  """
      end

      def wipe_description
        "Wipe gswitch branch history for current repo."
      end

      def back_description
        """Pop the last branch and check it out 
           \t\t\t     [default for no arguments].\n """
      end

      def move_description
        """Push the current branch and checkout the
           \t\t\t     specified branch. 
           \t\t\t     [default with one branch argument,
           \t\t\t     eg gswitch master].\n """
      end
  end
end