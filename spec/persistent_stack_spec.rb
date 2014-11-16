require_relative "../lib/gswitch/persistent_stack"

module GSwitch
  describe PersistentStack do

    TEST_FILE = "test.stack"

    def read_stack_file
      stack_file = File.open TEST_FILE, "r"
      lines = stack_file.readlines
      stack_file.close
      lines
    end

    def write_to_stack_file lines
      stack_file = File.open TEST_FILE, "w"
      lines.each { |line| stack_file.write "#{line}\n" }
      stack_file.close
    end

    def empty_stack_file 
      write_to_stack_file []
    end

    let(:file_name) { "test" }
    subject(:stack) { PersistentStack.new file_name, "." }

    describe "#pop" do
      context "when the stack is empty" do
        it "raises a StackEmptyError" do
          expect { stack.pop }.to raise_error PersistentStack::StackEmptyError
        end
      end

      context "when there are two lines in the stack" do
        let(:lines) { ["first", "second"] }
        before      { write_to_stack_file lines }
        after(:all) { empty_stack_file }

        it "returns the bottom line from the stack file" do
          expect(stack.pop).to eq lines.last
        end

        it "does change the stack file" do          
          expect { stack.pop }.to change { read_stack_file }
        end

        it "removes the bottom line from the stack file" do
          stack.pop
          expect(read_stack_file).to eq ["#{lines.first}\n"]
        end
      end      
    end

    describe "#push" do
      let(:data)      { "test line" }
      let(:more_data) { "test line 2" }
      after           { empty_stack_file }

      it "does change the stack file" do          
        expect { stack.push data }.to change { read_stack_file }
      end

      it "adds the specific line to the botom of the stack file" do  
        stack.push data
        stack.push more_data        
        expect(read_stack_file).to eq [ "#{data}\n", "#{more_data}\n"]
      end      
    end

    describe "#peek" do
      context "when the stack is empty" do
        it "raises a StackEmptyError" do
          expect { stack.peek }.to raise_error PersistentStack::StackEmptyError
        end
      end

      context "when there are two lines in the stack" do
        let(:lines) { ["first", "second"] }
        before      { write_to_stack_file lines }
        after(:all) { empty_stack_file }

        it "returns the bottom line from the stack file" do
          expect(stack.peek).to eq lines.last
        end

        it "does not change the stack file" do          
          expect { stack.peek }.not_to change { read_stack_file }
        end
      end  
      
    end

    describe "#get_raw_stack" do
      context "when the stack is empty" do
        it "returns an empty array" do
          expect(stack.get_raw_stack).to eq []
        end
      end

      context "when there are two lines in the stack" do
        let(:lines) { ["first", "second"] }
        before      { write_to_stack_file lines }
        after(:all) { empty_stack_file }

        it "returns all the lines in the stack file in order" do
          expect(stack.get_raw_stack).to eq lines
        end
      end        
    end

    describe "#height" do
      context "when the stack is empty" do
        it "returns 0" do
          expect(stack.height).to eq 0
        end
      end

      context "when there are two lines in the stack" do
        let(:lines) { ["first", "second"] }
        before      { write_to_stack_file lines }
        after(:all) { empty_stack_file }

        it "returns 2" do
          expect(stack.height).to eq 2
        end
      end      
    end

    describe "#empty!" do
      context "when the stack is empty" do
        it "does not raise an error" do
          expect { stack.empty! }.not_to raise_error 
        end
      end

      context "when there are two lines in the stack" do
        let(:lines) { ["first", "second"] }
        before      { write_to_stack_file lines }
        after(:all) { empty_stack_file }

        it "removes all entries from the stack file" do
          stack.empty!
          expect(read_stack_file).to eq [] 
        end
      end       
    end    
  end
end