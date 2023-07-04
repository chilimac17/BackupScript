#!/bin/bash

# Michael Chillemi
# M8.B4: Programming Assignment 4
# 03/20/2023

# This Program will backup a directory to the desired location of the user. This program take in two arguments, first the directory that the user wants to back up followed by the desired location. 
# It will not back up subdirectories.
# ./program_name  fullpath/to/copy/directory fullpath/to/desired/destination

# The Program first checks if the user provided 2 arguments. If so then a echo will be called to notify the user that the program has begun and will check if the arguments exist.

if [ "$#" ==  2 ];  then
   	echo "Program Is Starting"
	echo "Checking If Directories Exist"

	# This will check if the directories provided exist. If so then a echo will be displayed to the user indicating that the directory exist.
	if [ -e $1 ] && [ -e $2 ]; then
			echo "Both Directories Exists"
			
			# This will check for the case if the user already backed up the current arguments.

			if [ -e $2/$1 ]; then

				# Creating an array of files from argument 1.

				declare -a previously_backed_up_dir=( $1* )
				
				# Using a for loop to go through the array.

				for file in ${previously_backed_up_dir[@]};
				do
					# If the file is a directory then an echo will indicate to the user that the directory will not be backed up. 

					if [ -d "$file" ]; then
						echo "$file is a directory and will not be backed up"

					# If the file does not exist in the new directory then we have indicated that we found a new file and then proceed to copy it over to the disired directory.

					elif [ ! -e $2$file ]; then
						echo "Copying new file $file to $2$1"
						cp $file $2$1

					# The else case will indicate that the file does exist in the desired directory.
						
					else
						# Run the stat command to get the size of both files.

						arg1_file=$(stat -c%s $file)
						arg2_file=$(stat -c%s $2$file)
					
						# If the file exists in the desired directory AND the file sizes are the same then the program will indicate to the user that the file does not need to be copied over.

						if [ -e "$2$file" ] && [ "$arg1_file" == "$arg2_file" ]; then
							echo "File: $file does not need to be backed up"

						# This else case will verify that the file sizes are not equal then it will backup the file to the desired directory. 

						else 
							if [ "$arg1_file" != "$arg2_file" ]; then
								echo "Copying $file to $2$1"
								cp $file $2$1
							fi
						fi
					fi
				done
			
			# The else case will create the directory in the desired location(arguemnt 2) and output an echo indicating that the directory has been created.

			else
				mkdir $2/$1
				echo "DIRECORY CREATED"
				
				# Creating an array from argument 1.

			        declare -a directory_files=( $1* )
  
				# Looping through the array of files in argument 1

   			       for file in ${directory_files[@]};
        		       do
					# At each iteration of the loop it will check if the provided argument is a file. If so then the user will get an echo indicating which file is being copied and the destination it will go. Then the file will be copied to users desired destination.

                  			if [ -f $file ]; then
                          			echo "Copying $file to $2/$1"
                          			cp $file $2/$1

					# The else case will indicate to the user that the file is not a file and will provide the name, because in this assignment subdirectories can not be copied over. 

                  			else
                          			echo "$file is not a File"
                          			exit 3
                  			fi
                 	       done

			fi

	# The else case will check if the first argument does not exist. If so then an echo will indicate to the user that the first argument does not exist.
	# The else case will notifiy the user that the second argument is incorrect.

	else
		if [ ! -e $1 ]; then
			echo "First Argument Does Not Exist"
			exit 1
		else
			echo "Second Argument Does not Exists"
			exit 2
		fi
	fi

# If the user did not provide the proper amount of arguments then an echo will be called to instruct the user the proper way to run the Backup Script.

else 
	echo "Two Arguments are needed"
	echo "Scriptname fullpath/to/copy/directory fullpath/to/desired/destination"   
fi
exit 0
