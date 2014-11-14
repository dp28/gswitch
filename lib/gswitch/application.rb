module GSwitch
  class Application

    STACK_DIR_PATH = File.join Dir.home, ".git_switch_stacks"

    def initialize argv
      @args  = argv
      @stack = GSwitch::PersistentStack.new  current_repo, STACK_DIR_PATH
    end

    def run
      ensure_stack_directory_exists

      if @args[0]
        puts "Pushing #{current_branch} ..."
        @stack.push current_branch
        puts "git checkout #{@args[0]}"
      else
        begin
          puts "git checkout #{@stack.pop}"
        rescue GSwitch::PersistentStack::StackEmptyError
          puts "Stack empty"
        end
      end

    end

    private

      def ensure_stack_directory_exists
        unless File.directory? STACK_DIR_PATH
          puts "Creating #{STACK_DIR_PATH}"
          FileUtils.mkdir_p STACK_DIR_PATH
        end
      end

      def current_repo
        `basename \`git rev-parse --show-toplevel\``
      end      

      def current_branch
        `git branch | sed -n '/\\* /s///p'`.gsub!("\n", "").gsub(" ", "")
      end
  end
end