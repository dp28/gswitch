#! /usr/bin/env ruby
require 'fileutils'

STACK_DIR_PATH = File.join Dir.home, ".git_switch_stacks"

# Uses files to make a persistent stack implementation 
class SavedStack

  def initialize repo_name, stack_dir_path=STACK_DIR_PATH
    @path = full_path repo_name, stack_dir_path
  end

  def pop
    begin
      pop_line
    rescue EOFError
      raise StackEmptyError.new
    end
  end

  def push line
    stack_file = File.open @path, "a+"
    stack_file.write "#{line}\n"
    stack_file.close
  end

  class StackEmptyError < RuntimeError; end

  private

    def full_path repo_name, stack_dir_path
      "#{stack_dir_path}/#{repo_name}.stack"
    end

    def pop_line
      stack_file  = File.open @path, "r+"
      last_line   = move_to_last_line_of_file stack_file
      line        = stack_file.readline
      stack_file.truncate last_line
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

def ensure_stack_directory_exists
  unless File.directory? STACK_DIR_PATH
    puts "Creating #{STACK_DIR_PATH}"
    FileUtils.mkdir_p STACK_DIR_PATH
  end
end

ensure_stack_directory_exists
stack = SavedStack.new ARGV[0]

if ARGV[1]
  puts "Pushing #{ARGV[1]} ..."
  stack.push ARGV[1]
  puts "git checkout some_new_branch"
else
  begin
    puts "git checkout #{stack.pop}"
  rescue SavedStack::StackEmptyError
    puts "Stack empty"
  end
end
