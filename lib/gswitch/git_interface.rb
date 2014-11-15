module GSwitch

  class NotGitRepoError < RuntimeError; end

  class GitInterface 

    def current_repo
      repo = `basename \`git rev-parse --show-toplevel\` 2> /dev/null`
      if $?.success?
        repo
      else
        raise NotGitRepoError.new 
      end
    end      

    def current_branch
      `git branch | sed -n '/\\* /s///p'`.gsub!("\n", "").gsub(" ", "")
    end

    def status
      `git status`
    end

    def checkout branch
      puts "EXAMPLE git checkout #{branch}"
      #{}`git checkout #{branch}`
    end
  end
end