module GSwitch

  class NoBranchSpecifiedError < RuntimeError; end

  class GSwitch
    STACK_DIR_PATH = File.join Dir.home, ".git_switch_stacks"

    attr_accessor :show_output

    def initialize
      @git          = GitInterface.new
      @stack        = PersistentStack.new  @git.current_repo, STACK_DIR_PATH
      @show_output  = true
    end

    def move branch
      if branch.nil?
        raise NoBranchSpecifiedError.new
      else
        push_current_and_checkout branch
      end
    end

    def back
      branch = pop
      unless try_checkout branch
        error =  "Failed to checkout #{branch}, staying on"
        error += " #{@git.current_branch} and discarding #{branch}."
        STDERR.puts error
      end
    end

    def push branch=nil
      branch ||= @git.current_branch
      display_message "Pushing #{branch}"
      @stack.push branch
    end

    def pop
      popped = @stack.pop
      display_message "Popped #{popped}"
      popped
    end

    def show_current_branch 
      puts @git.current_branch
    end

    def show_stack_height  
      height = @stack.height
      branch = height == 1 ? "branch" : "branches"
      is     = height == 1 ? "is"     : "are"
      puts "There #{is} #{height} stored #{branch} for this repo."
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
      @stack.empty!
    end

    private 

      def display_message message
        puts message if @show_output
      end

      def try_checkout branch
        begin 
          checkout branch
          true
        rescue CheckoutFailedError
          false
        end
      end

      def checkout branch
        if @show_output
          @git.checkout branch
        else
          @git.checkout_silently branch
        end
      end

      def push_current_and_checkout branch
        push
        unless try_checkout branch
          current = pop
          STDERR.puts "Failed to checkout #{branch}, staying on #{current}."
        end
      end
  end
end