module GSwitch
  class GSwitch
    STACK_DIR_PATH = File.join Dir.home, ".git_switch_stacks"

    def initialize
      @git      = GitInterface.new
      @stack    = PersistentStack.new  @git.current_repo, STACK_DIR_PATH
    end

    def push_current_and_checkout branch
      push
      @git.checkout branch
    end

    def pop_and_checkout
      branch = pop
      @git.checkout branch
    end

    def push branch=nil
      branch ||= @git.current_branch
      puts "Pushing #{branch}"
      @stack.push branch
    end

    def pop
      popped = @stack.pop
      puts "Popped #{popped}"
      popped
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