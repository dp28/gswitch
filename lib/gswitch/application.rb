module GSwitch
  class NotGitRepoError < RuntimeError; end

  class Application

    STACK_DIR_PATH = File.join Dir.home, ".git_switch_stacks"

    def initialize argv
      @args  = argv
      @stack = GSwitch::PersistentStack.new  current_repo, STACK_DIR_PATH
    end

    def run
      ensure_stack_directory_exists
      options = GSwitch::Options.new @args
      puts options.set_flags
      puts options.branch
      puts options.quiet

      # if @args[0]
      #   puts "Pushing #{current_branch} ..."
      #   @stack.push current_branch
      #   puts "git checkout #{@args[0]}"
      # else
      #   puts "git checkout #{@stack.pop}"
      # end

    end

    private

      def ensure_stack_directory_exists
        unless File.directory? STACK_DIR_PATH
          puts "Creating #{STACK_DIR_PATH}"
          FileUtils.mkdir_p STACK_DIR_PATH
        end
      end

      def current_repo
        repo = `basename \`git rev-parse --show-toplevel\` 2> /dev/null`
        if $?.success?
          repo
        else
          raise GSwitch::NotGitRepoError.new 
        end
      end      

      def current_branch
        `git branch | sed -n '/\\* /s///p'`.gsub!("\n", "").gsub(" ", "")
      end
  end
end