module GSwitch

  class NotGitRepoError     < RuntimeError; end
  class CheckoutFailedError < RuntimeError; end

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

    def checkout branch
      raise CheckoutFailedError.new unless system "git checkout #{branch}"
    end

    def checkout_silently branch
      `git checkout #{branch}`
      raise CheckoutFailedError.new unless $?.success?
    end
  end
end