GSwitch - git switch
====================

GSwitch is an add-on for git that allows quick switching between branches. It 
allows you to save the name of the branch you're on and checkout a new branch
with `gswitch <branch-to-switch-to>`, then checkout your original branch just 
with `gswitch`. The branch history is stored as a stack, so you can even switch
to another branch after your original switch. In addition, all your local and 
remote branches willl be tab-completed, just like `git checkout`.

Installation
------------

```bash
git clone https://github.com/dp28/gswitch.git
cd gswitch
chmod +x installer
./installer
```

Usage
-----

Git options:

    -b, --back          Pop the last branch and check it out 
                        [default for no arguments].
 
    -c, --current       Show current branch.
    -m, --move          Push the current branch and checkout the
                        specified branch. 
                        [default with one branch argument,
                        eg gswitch master].
 
History stack options:

    -w, --wipe          Wipe gswitch branch history for current repo.
    -H, --height        Show stack height.
    -P, --pop           Pop top branch from history stack without
                        checking it out.
  
    -p, --push          Push a branch to history without changing
                        branch. If no branch is specified, the 
                        current branch is pushed.
  
    -s, --stack         Show full stack.
    -t, --top           Show top of stack.

Other options:

    -h, --help          Print help message.
    -q, --quiet         Run without output.
