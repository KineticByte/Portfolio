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
So we want a programmatic way to identify which file is "human-readable". The "file" command is the best tool for the job, with the description being "determine file type". Knowing the 'file' command is the right tool for the job is just part of the answer - this level aims to test multiple angles of a users linux knowledge and creativity. As in level 2, we can escape the hyphen with `.\`. To automate it though, we need to understand "regex" - a sequence of characters that specify or enable pattern matching. The regex character we need for this is the asterisk - `*` which is a wildcard that means "match zero or more of any character" - perfect for this situation as we want to run the file command against all files in this directory.
Combining this together, we need just run `$file ./*` from the inhere directory - and we get the output that of all files, ./-file07 contains "ASCII text". 
If we cat this, we get the password to Bandit5: 4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw

# Level 6
The password for the next level is stored in a file somewhere in the **inhere** directory and has all of the following properties:
- human readable
- 1033 bytes in size
- Not executable.

For this, file alone isn't enough, despite the first criteria being "human readable". The linux command "find" is designed to search for files in a directory heirarchy - which this is - as the **inhere** directory contains more directories, similar to what many Linux System administrators would experience trying to find a specific file in their linux servers.
Scrolling through the manual page, or using the built-in manual search (type /[string to search] while looking through the manual page) we find -size as a flag to specify the size of files to look for.
The 'c' suffix means bytes, so we want a file of `-size 1033c`. Now, many System administrators (and cybersecurity professionals) will tell you to not overcomplicate the problem. In this question, that can simply mean simply - run the command with the flags we do know already, rather than wasting time trying to match the other criteria. 
So, we can run `$find -size 1033c`, and get just a single file as a result, /~/maybehere07/.file2, which we can cat to get the password for bandit6:HWasnPhtq9AVKe0dmk45nxy20cvUa6EG


# Level 7. 
The password for the next level is stored somewhere on the server and has all of the following properties:
- owned by user bandit7
- owned by group bandit6
- 33 bytes in size

This one isn't going to be as simple as just looking for files of size 33 bytes. We're gonna need to look for files owned by bandit7 and group bandit6. How? 
We can use `find -user {uname}` to find all files owned by the user "uname". we can use `-group {gname}` to do the same for groups. 
Putting it all together we get `$find -user bandit7 -group bandit6 -size 33c`, upon which we can look through the results and get /var/lib/dpkg/info/bandit7.password
Cat-ing this file, we get the password for bandit7: morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj

# Level 8
The password for the next level is stored in the file **data.txt** next to the word **millionth**

For people familiar with the tool "grep" this one is an easy one. For those unfamiliar - read the manual entry for grep, and then spend the next few hours practising it. Seriously. Grep is one of the most useful and powerful filtering tools in Linux - and what makes it so powerful is how it can be used with pipes from other shell binaries.
The solution for this level is a simple `$cat data.txt |grep millionth`. This gives us the password for bandit8: dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc

# Level 9
The password for the next level is stored in the file data.txt and is the only line of text that occurs only once

For this level, we need two new commands - sort and uniq.
Uniq does what you'd expect - filters out matching lines from input. Since we want the only line of text that occurs only once, we can use the `-u` flag to only print unique lines. Key to the `uniq` binary though is it only filters out _adjacent_ matching lines - so if the data isn't sorted, it's not going to be able to filter it out.
That's where sort comes in handy. `sort` sorts lines of text. 
Putting this all together, we get `$sort data.txt | uniq -u` which prints to the standard output, the password for bandit9: 4CKMh1JI91bUIZZPXDqGanal4xvAg0JM

# Level 10
The password for the next level is stored in the file data.txt in one of the few human-readable strings, preceded by several ‘=’ characters.

The first issue with this file is obvious if we run the `file` command on data.txt. The file consists of "data" and not "ASCII Text". One of the new commands listed on the level description will be of use to us.
Skipping over the various encryption and compression commands, the only other new command shown is `strings`. The description of the `strings` command states that it prints the sequences of printable characters in files. That sounds like what we need.
Using `grep` again to sort the data, looking for multiple '=' characters (let's use 3), we can get the password.
`$strings data.txt | grep ===` gives us the password for bandit10: FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey

# Level 11
The password for the next level is stored in the file data.txt, which contains base64 encoded data.
Again, if you don't know much about base64, I'd advise reading up on it on the Wikipedia article mentioned on the level description on overthewire.org.

We can use base64 to decode files in base64 format using the `-d` flag.
`$base64 -d data.txt` gives us the password for bandit11: dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr

# Level 12
The password for the next level is stored in the file data.txt, where all lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions.

The rot13 cipher, i.e. a 13 character caesar cipher, is a special case for a cipher because it is it's inverse - to reverse the "encryption" you simply apply the same algorithm again. This offers virtually no cryptographic security, but is often used in online challenges, for hiding spoilers and punchlines, and other such purposes - with the intention being that you can decrypt it if you want to, but you won't automatically be able to read it without decrypting it (requiring intent).
The `tr` command can be used to translate characters. We want a 13 character substitution for both lower case and upper case. The example provided has the usage of `tr A-Z a-z` - simply meaning that A-Z is replaced with a-z.
Since that's an upper to lower translation, that's not useful for us. What we want is to translate both upper and lower by 13 characters.
We can do that with the following command `cat data.txt | tr A-Za-z N-ZA-Mn-za-m`.
Explanation: tr translates standard input, so needs to be redirected from cat first.
We want to translate A to N, and Z to M (as they are 13 characters different), but tr cannot translate values past Z in what it calls "reverse collating sequence order" which is why you cannot simply use `tr A-Za-z N-Mn-m` - you instead have to piecewise the function into N-ZA-Mn-za-m.
Either way, running the tr command with the required parameters, we get the password for bandit12: 7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4

# Level 13
The password for the next level is stored in the file data.txt, which is a hexdump of a file that has been repeatedly compressed. 








