module GSwitch

  class ApplicationController

    STACK_DIR_PATH = File.join Dir.home, ".git_switch_stacks"

    def initialize argv
      @options = Options.new argv
      @gswitch = GSwitch.new
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
          run_without_flags
        else
          flags.each { |flag| @gswitch.send flag }  
        end  
      end

      def run_without_flags
        if @options.branch            
          @gswitch.push_current_and_checkout @options.branch
        else
          @gswitch.pop_and_checkout
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