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
        show_help if @options.set_flags.include? :show_help
        @options.set_flags.each { |flag| send flag }    
        if @options.branch
          puts "Pushing #{@git.current_branch} ..."
          @stack.push @git.current_branch
          puts "git checkout #{@options.branch}"
        else
          puts "git checkout #{@stack.pop}"
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
  end
end