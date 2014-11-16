module GSwitch
  class PersistentStack

    class StackEmptyError < RuntimeError; end

    def initialize file_name, stack_dir_path
      @path = full_path file_name, stack_dir_path
    end

    def pop
      try_get_last_line true
    end

    def push line
      stack_file = File.open @path, "a+"
      stack_file.write "#{line}\n"
      stack_file.close
    end

    def peek
      try_get_last_line
    end

    def get_raw_stack
      stack_file = File.open @path, "r"
      lines = stack_file.read.split
      stack_file.close
      lines
    end

    def height
      get_raw_stack.size
    end

    def empty!      
      stack_file = File.open @path, "w"
      stack_file.close
    end

    private

      def full_path file_name, stack_dir_path
        "#{stack_dir_path}/#{file_name}.stack"
      end

      def try_get_last_line delete=false
        begin
          get_last_line delete
        rescue EOFError, Errno::ENOENT
          raise StackEmptyError.new
        end
      end

      def get_last_line delete
        stack_file  = File.open @path, "r+"
        last_line   = move_to_last_line_of_file stack_file
        line        = stack_file.readline.split.first
        stack_file.truncate last_line if delete
        stack_file.close
        line
      end

      def move_to_last_line_of_file file
        last_line = 0
        file.each { last_line = file.pos unless file.eof? }
        file.seek last_line, IO::SEEK_SET
        last_line
      end
  end
end