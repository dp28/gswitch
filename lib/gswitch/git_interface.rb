module GSwitch
  class GitInterface 

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

    def status
      `git status`
    end

    def checkout branch
      `git checkout #{branch}`
    end
  end
end