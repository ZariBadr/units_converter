#!/usr/bin/env bash
set -o pipefail

function show_menu() {
	echo "Select an option"
	echo "0. Type '0' or 'quit' to end program"
	echo "1. Convert units"
	echo "2. Add a definition"
	echo "3. Delete a definition"

}

function option_2() {
	echo "Enter a definition:"
	read -a user_input
	arr_length="${#user_input[@]}"
	definition="${user_input[0]}"
	constant="${user_input[1]}"
	string="${user_input}"
	re_constant="^[+-]?[0-9]+\.?[0-9]*$"
	re="(^[A-Za-z]+_to_+[A-Za-z]+)"
	if [[ "$definition" =~ $re && "$constant" =~ $re_constant && "$arr_length" -eq "2" ]]; then
	file_name="definitions.txt"
	line="$definition $constant"
	echo "$line" >> "$file_name"
	show_menu
	else
	echo "The definition is incorrect!"
	fi
	until [[ "$definition" =~ $re && "$constant" =~ $re_constant && "$arr_length" -eq "2" ]];
	do
	echo "Enter a definition:"
	read -a user_input
	arr_length="${#user_input[@]}"
	definition="${user_input[0]}"
	constant="${user_input[1]}"
	string="${user_input}"
	re_constant="^[+-]?[0-9]+\.?[0-9]*$"
	re="(^[A-Za-z]+_to_+[A-Za-z]+)"
	if [[ "$definition" =~ $re && "$constant" =~ $re_constant && "$arr_length" -eq "2" ]]; then
	file_name="definitions.txt"
	line="$definition $constant"
	echo "$line" >> "$file_name"
	show_menu
	else
	echo "The definition is incorrect!"
	fi

	done
}

function show_def() {
	file_name="definitions.txt"
	line_number=1
	while read -r line ;
	do
	echo $line_number"." $line
	let "line_number+=1"
	done < definitions.txt

}
function is_number_line_valid() {
read line_number
number_definitions=$(cat <definitions.txt | wc -l)
file_name="definitions.txt"
line_number_regex="[0-9]"
if [ "$line_number" == "0" ]; then
  return
elif ! [[ $line_number =~ ^[0-9]*$ && $line_number -ne "" && $line_number -le number_definitions ]];
then
 echo "Enter a valid line number!"
 is_number_line_valid
else
  sed -i "${line_number}d" "$file_name"
fi
}

function option_3() {
  	number_definitions= wc definitions.txt | cut -d ' ' -f 1
	file_name="definitions.txt"
	if [ -s $file_name ]; then
		echo "Type the line number to delete or '0' to return"
		show_def
		is_number_line_valid
	else
	  echo "Please add a definition first!"
	fi
}





function option_1() {
	number_definitions= wc definitions.txt | cut -d ' ' -f 1
	file_name="definitions.txt"

	if [ -s $file_name ]; then
		echo "Type the line number to convert units or '0' to return"
		show_def
		#valid_line_option_1
		option=$(valid_line_option_1)
		if [[ "$option" -eq "0" ]]; then
			return
		else
			echo "Enter a value to convert:"
			value=$(value_input_option_1)
			file_name="definitions.txt"
			line=$(sed "${option}!d" "$file_name")
			read -a text <<< "$line"
			constant="${text[1]}"
			# shellcheck disable=SC2004
			result=$(($constant * $value))
			echo "Result: "$result
		fi
	else
	  	echo "Please add a definition first!"
	fi
}

function valid_line_option_1() {
	read line_number
	number_definitions=$(cat <definitions.txt | wc -l)
	file_name="definitions.txt"
	if [ "$line_number" == "0" ]; then
	  echo $line_number
	elif ! [[ $line_number =~ ^[0-9]+ && "$line_number" -ne "" && $line_number -le number_definitions ]];
	then
	 echo "Enter a valid line number!"
	 	valid_line_option_1
	 else
	 	echo $line_number
	 fi

}

function value_input_option_1() {
	re_constant="^[+-]?[0-9]+\.?[0-9]*$"
	read value
	#if ! [[ "$value" =~ ^[+-]?[0-9]+\.?[0-9]*$ && "$value" -ne "" ]]; then
	if ! [[ "$value" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
		until [[ "$value" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; do
			echo "Enter a float or integer value!"
			value_input_option_1
		done
	else
		echo $value
	fi
}

function option_1_() {
	number_definitions= wc definitions.txt | cut -d ' ' -f 1
	value_regex="^[+-]?[0-9]+\.?[0-9]*$"
	file_name="definitions.txt"
	if [ -s $file_name ]; then
		echo "Type the line number to convert units or '0' to return"
		show_def
		read line_number
    number_definitions=$(cat <definitions.txt | wc -l)
    file_name="definitions.txt"
    if [ "$line_number" == "0" ]; then
      return
    fi
    while ! [[ $line_number =~ ^[0-9]+ && "$line_number" -ne "" && $line_number -le number_definitions ]];
       do
        echo "Enter a valid line number!"
        read line_number
    done

			echo "Enter a value to convert:"
      read value
      if ! [[ $value =~ $value_regex ]]; then
        until [[ $value =~ $value_regex ]]; do
          echo "Enter a float or integer value!"
          read value
        done
      fi

			file_name="definitions.txt"
			line=$(sed "${line_number}!d" "$file_name")
			read -a text <<< "$line"
			constant="${text[1]}"
			# shellcheck disable=SC2004
			#result=$("$constant * $value" | bc)
			result=$(bc -l <<< "$constant * $value")
			echo "Result: "$result
	else
	  	echo "Please add a definition first!"
	fi
}



function main() {
echo "Welcome to the Simple converter!"
show_menu
while true; do
	read user_input
	case $user_input in

		0)
			echo "Goodbye!"
			exit
			 ;;
		1)
			option_1_
			show_menu
			;;
		2)
			option_2
			;;
		3)
			option_3
			show_menu
			;;


 	      'quit' )
 			echo "Goodbye!"
			exit
			;;

		*)
			echo "Invalid option!"
			show_menu
			;;
	esac
done

}

main



