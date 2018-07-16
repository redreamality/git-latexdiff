# git-latexdiff
To diff latex file with preview versions for **Windows**.
Extremely useful when others revised your paper/work and you need to find the difference.
works only on windows

# Effect
![](https://vgy.me/oQWBFo.png)

# CAUTION
Remember to commit everything before you run the script, the author is not responsible for any data loss.

# Usage

First, copy `git-latexdiff.bat` to your current latex directory. (**important**)

Then open cmd and execute
`git-latexdiff [old_revision] [latex_file|no extension] [newest_version]`

For example:
`git-latexdiff HEAD~1 main master`

# requirements
Requires the following on your path (so that you can call them from the commmand line):

these 3 should come along with Miktex:
- pdflatex
- latexdiff
- latexpand (available on CTAN)

and:
- perl(active perl is only 20MB in case you are wondering which to install)

 

# Acknowledgement
Inspired and many thanks to [this](https://chemicalkinetics.wordpress.com/2014/07/24/git-latexdiff-batch-script-for-windows/)


