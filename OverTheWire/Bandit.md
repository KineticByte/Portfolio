Everyones favourite overdone Linux skilltest.
Most levels have multiple viable methods for identifying the password. Several commands are provided in the level information on https://overthewire.org/wargames/bandit/bandit{level}.html even if not required. The goal is to get you to read the manual and learn what each tool does.  

# Level 0

Connecting to the lab server using SSH. 
$ ssh bandit0@bandit.labs.overthewire.org -p 2220
password: bandit0

**Skills learned:** SSH

# Level 1
Note: The "Task" of Level N in the context of Bandit OverTheWire is to find the password for the user account banditN

Level 1's password is stored in the "readme" file in the local directory. 
$cat readme
Password to bandit1: ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If

# Level 2
Level 2's password is stored in a file called - in the home directory.
This level aims to teach users about escaping certain inputs or special options - in this case, the linux shell (Bash) uses the hyphen to designate "flags", or optional parameters. As such, attempting to use the **cat** tool on this file will have the shell produce an error.
We can escape this by running the command `$cat ./-`
`.\` tells the shell to look at the current directory, and prefix the path to the hyphen with the current directory. Alternatively, you could write out the entire directory to the hyphen file - essentially escaping the flag parameter.
Password to bandit2: 263JGJPfgU6LtdEvgfWU1XP5yac29mFx

# Level 3
The password for the next level is stored in a file called spaces in this filename located in the home directory

This level aims to teach people how to escape spaces - as running a command on a file with spaces in the name using the standard convention of just writing the file name will cause the shell to interpret each word as a new part of the command, as opposed to looking at the whole file name.
There is one easy way around this, and one slightly more complicated method. 
The easy method is to just surround this filename in quotation marks. `$cat "spaces in this filename"
The other method is to use the bash built-in escape character, which is a non-quoted backslash `\`
Tab to autocomplete makes this easy as well - start by writing out the command then press tab to autocomplete `$ cat spaces\ in\ this\ filename`

Either way, running this we get the password to bandit3: MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx

# Level 4
The password for the next level is stored in a hidden file in the inhere directory.

The description gives away the answer to this, but to someone unfamiliar with how a file is set as "hidden" in the linux filesystem, or how to reveal them, it might be a challenge.
Like every other challenge though, the manual for the commands gives away the answer. In this case, the very first command listed under the "Commands you may need to solve this level" subheading is the solution. 
`$man ls` provides some insight, including the very first two flags, `-a` and `-A` which both work - as they output the names of all files in the current directory to standard output, even if hidden (with `-A` not outputting "implied" . and .., i.e. current and previous directory)
running `$ls -A` shows us that there is a hidden file in the directory called "...Hiding-From-You", which we can output the contents to standard output once again using `cat`
Bandit4's password is: 2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ

# Level 5
The password for the next level is stored in the only human-readable file in the inhere directory. Tip: if your terminal is messed up, try the “reset” command.

The inhere directory has 10 files, all prefixed with a hyphen (surprised they aren't also hidden, with spaces in the filenames). We could get the contents of each file manually with cat, but that wouldn't be a scalable answer - One of the key strengths of Linux (and bash) is how easy it is to automate; so it's unlikely we'd be dealing with 10 files, and probably dealing with thousands if not tens of thousands of files.
So we want a programmatic way to identify which file is "human-readable". The "file" command is the best tool for the job, with the description 

