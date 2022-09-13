# Command Line tips

### Useful commands

| command         	| usage                                                                                	| key flags 	| meaning                                                         	|
|-----------------	|--------------------------------------------------------------------------------------	|-----------	|-----------------------------------------------------------------	|
| ssh             	| secure shell - login to remote host                                                  	|           	|                                                                 	|
| scp             	| secure copy - copy file to/from another computer                                     	| -r        	| recursive, include contents of a directory                      	|
| pwd             	| print working directory                                                              	|           	|                                                                 	|
| ls              	| list the contents of a directory                                                     	| -l        	| gives a list with file details                                  	|
|                 	|                                                                                      	| -h        	| makes details easier to understand                              	|
|                 	|                                                                                      	| -a        	| all, including hidden files                                     	|
| cd              	| change directory                                                                     	|           	|                                                                 	|
| mkdir           	| make a new directory                                                                 	|           	|                                                                 	|
| mv              	| move a file or directory (also used to rename)                                       	|           	|                                                                 	|
| cp              	| copy a file or directory                                                             	|           	|                                                                 	|
| rm              	| remove a file or directory                                                           	| -r        	| recursive, include contents of a directory                      	|
|                 	|                                                                                      	| -f        	| force - doesn't ask about each file                             	|
| rmdir           	| remove directory (can also just use rm -r)                                           	|           	|                                                                 	|
| head            	| show the first 10 lines of a file                                                    	| -#        	| specify the number of lines to print from header                	|
| tail            	| show the last 10 lines of a file                                                     	| -#        	| specify the number of lines to print from tail                  	|
| less            	| view contents of file, in read only mode                                             	|           	|                                                                 	|
| cat             	| print the contents of a file                                                         	|           	|                                                                 	|
| wc              	| 'word count' returns the character, word, and line counts                            	| -l        	| only show number of lines                                       	|
| man             	| shows help for a command (Google is also a great resource for terminal help)         	|           	|                                                                 	|
| echo            	| prints to the screen whatever follows it on the command line.                        	|           	|                                                                 	|
| history         	| prints previous commands                                                             	|           	|                                                                 	|
| htop            	| shows current activity on the computer                                               	|           	|                                                                 	|
| which 'program' 	| shows location of a program in path                                                  	|           	|                                                                 	|
| PATH            	| an environmental variable that tells the shell where to look for executable programs 	|           	|                                                                 	|
| echo $PATH      	| lists the directories in your path ($ means "value of")                              	|           	|                                                                 	|
| cut             	| shows the first x columns of a file. VERY useful for peaking at a large alignment.   	| -c        	| specify number of columns to show, e.g., 'cut -c 1-50 filename' 	|
| grep            	| find lines that contain certain string                                               	| -i        	| case insensitive                                                	|
|                 	|                                                                                      	| -A        	| append the next # lines after the string                        	|


### Text editor

vi	simple text editor to open files with, e.g., vi file.txt
>	within a vim editor window
>>	:i	allow insertion of text
>>	
>>	:q!	quit (close file) without saving changes
>>	
>>	:wq	quit (close file) and save changes


### capturing outputs

'>'	redirects standard output to a file (will overwrite the file contents)

'>>'	append the results of a command to a file (will add lines at the end of existing file)

|	send the results of one command to another command (called “pipe”)


### Important characters to know

~	home directory

/	root directory

./	current working directory

..	directory above the current (parent directory)

*	wildcard - stands for any character, of any length
*	
?	wildcard - stand for any single character

;	line break


### Keys and shortcuts

ctrl - alt - t	new terminal window

tab	completes a file/directory names

alt - tab	switch programs

up arrow	recalls previous command
