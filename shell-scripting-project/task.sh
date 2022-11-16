#!/bin/bash

# main program
main_menu() {
	
	# prompt the user to return to main menu or exit program
	main_menu_or_exit() {

		echo "To return to the main menu press m, or press q to exit"
		read input
		echo ""

		case "$input" in
			
			"m")
				
				# return to main menu
				main_menu	
				
				;;
			
			"q")
				
				# print exiting massage, and exit program
				echo "Thanks for playing with us, have a good day!!"
				echo ""
				
				;;
			
			*)
				
				# in case user didn't choose from the supported options,
				# prompt the user to choose from menu,
				# and return to main menu or exit 
				echo "please choose the right option"
				echo ""
				main_menu_or_exit
				
				;;

		esac
	}

	# prints formatted contact
	# takes a databse row as an argument,
	# appends each column to the corresponding column name
	print_contact() {
			echo "First Name: $(echo "$1" | awk '{print $1}')"
			echo "Last Name: $(echo "$1" | awk '{print $2}')"
			echo "Email: $(echo "$1" | awk '{print $3}')"
			echo "Phone Number: $(echo "$1" | awk '{print $4}')"
			echo ""
	}

	# prompt the user to choose from main menu options
	echo "==="
	echo "press i to add new contact"
	echo "press v to view all contacts"
	echo "press s to search for record"
	echo "press e to delete all contacts"
	echo "press d to delete one contact"
	echo "press q to exit"
	echo "==="

	read input
	echo ""

	# select which option matches the user input,
	# excute the required commands
	case "$input" in
		
		"i")

			# prompt user to enter contact details

			echo "Enter Your Contact First Name"
			read first_name
			echo ""	

			echo "Enter Your Contact Last Name"
			read last_name
			echo ""

			echo "Enter Your Contact Email"
			read email
			echo ""
			
			echo "Enter Your Contact Phone Number"
			read phone_number
			echo ""

			# save/append the contact to a database row
			echo "$first_name $last_name $email $phone_number" >> ./database.txt

			main_menu_or_exit
			
			;;
		
		"v")
			
			# return early if databse file doesn't exit
			if [[ ! -e ./database.txt ]]; then
				echo "There are no contacts found"
			else
				# loop through database rows and print each contact
				echo "$(while read -r row; do
					print_contact "$row"
				done <./database.txt)"
			fi
			
			echo ""
			main_menu_or_exit
			
			;;

		"s")
			
			# return early if database file doesn't exit or empty
			if [[ ! -e ./database.txt ]]; then
				
				echo "There are no contacts found"
			
			else

				echo "please enter anything related to your contact"
				read query
				echo ""

				# return early if no contacts found
				if [[ -z $(grep $query ./database.txt) ]]; then
					echo "contact doesn't exit"
				fi

				# loop through database rows,
				# check if search term matches the contact in the row,
				# print contact if it matches search term
				echo "$(while read -r row; do
					if [[ -n $(echo "$row" | grep $query) ]]; then
						print_contact "$row"
					fi
				done <./database.txt)"
			
			fi

			echo ""
			main_menu_or_exit
			
			;;

		"e")
			
			# check if database file exits, and remove it 
			if [[ -e ./database.txt ]]; then
				echo "$(rm ./database.txt)"
				echo "Contacts deleted successfully..."
			else
				echo "database already clear..."
			fi
			
			echo ""	
			main_menu_or_exit
			
			;;

		"d")

			# return early if database file doesn't exit or empty
			if [[ ! -e ./database.txt ]]; then

				echo "There are no contacts found"
			
			else

				echo "please enter anything related to the contact/s you wish to delete"
				read query
				echo ""

				# return early if no contacts found
				if [[ -z $(grep $query ./database.txt) ]]; then
					echo "contact doesn't exit"
				fi

				# cut any line matches the search term pattern,
				# redirect the remaining content to a temp file,
				# rename the temp file to the original filename
				# delete the temp file if all the above failes
				echo "$(sed "/$query/d" ./database.txt > ./temp.txt &&
					mv ./temp.txt ./database.txt || rm ./temp.txt)"
				echo "contact/s deleted successfully..."
			
			fi

			echo ""
			main_menu_or_exit	

			;;


		"q")
			
			# print exiting massage, and exit program
			echo "Thanks for playing with us, have a good day!!"
			echo ""
			
			;;

		*)
			
			# in case user didn't choose from the supported options,
			# prompt the user to choose from menu,
			# and return to main menu 
			echo "please choose the right option"
			echo ""
			
			main_menu
			
			;;

	esac
}

# excute the program
main_menu
