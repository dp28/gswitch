module GSwitch
  class NotGitRepoError < RuntimeError; end

  class Application

    STACK_DIR_PATH = File.join Dir.home, ".git_switch_stacks"

    def initialize argv
      @options  = GSwitch::Options.new argv
      @git      = GSwitch::GitInterface.new
      @stack    = GSwitch::PersistentStack.new  @git.current_repo, STACK_DIR_PATH
    end

    def run
      ensure_stack_directory_exists     
      run_from_options
    end

    private

      def run_from_options
        flags = @options.set_flags
        show_help if flags.include? :show_help
        if flags.empty?
          if @options.branch            
            push @git.current_branch
            @git.checkout @options.branch
          else
            pop
          end
        else
          flags.each { |flag| send flag }  
        end  
      end

      def ensure_stack_directory_exists
        unless File.directory? STACK_DIR_PATH
          puts "Creating #{STACK_DIR_PATH}"
          FileUtils.mkdir_p STACK_DIR_PATH
        end
      end

      def show_help
        @options.print_help
        exit
      end

      def push branch_name=nil
        branch = branch_name || @options.branch || @git.current_branch
        puts "Pushing #{branch}"
        @stack.push branch
      end

      def pop
        puts "Popped #{@stack.pop}"
      end

      def show_current_branch 
        puts @git.current_branch
      end

      def show_stack_height  
        height = @stack.height
        branch = height == 1 ? "branch" : "branches"
        puts "There are #{height} stored #{branch} for this repo."
      end

      def show_stack  
        stack   = @stack.get_raw_stack
        height  = stack.length
        stack.each_with_index { |branch, i| puts "#{height - i}. #{branch}" }
      end   

      def show_top  
        puts @stack.peek
      end

      def wipe
        @stack.empty
      end          
  end
end