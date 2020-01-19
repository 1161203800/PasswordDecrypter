#!/bin/bash

#List of characters
#List of capital letter characters
LIST1=(F K L W) #PLAY HERE
#List of number characters
LIST2=(2 8 9) #PLAY HERE
#List of letter characters
LIST3=(b s v x) #PLAY HERE
#List of unique characters
LIST4=("~" "*" "-" "[") #PLAY HERE
LIST5=("%" "+" "]" "$") #PLAY HERE

#MD5 Encrypted Key
encr1="$(cat hackcode.txt |cut -d";" -f1)" #retrieve the MD5 hash string from hackcode.txt file
hash1="$(echo $encr1 |cut -d"$" -f4)" #retrieve the hash string from MD5 hash string
salt1="$(echo $encr1 |cut -d"$" -f3)" #retrieve the salt string from MD5 hash string

#DES Encrypted Key
encr2="$(cat hackcode.txt |cut -d";" -f2)" #retrieve the DES hash string from hackcode.txt file
hash2="$(echo $encr2 | cut -d 1 -f2)" #retrieve the hash string from DES hash string
salt2="$(echo $encr2 | cut -b 1-2)" #retrieve the salt string from DES hash string

#SHA-256 Encrypted Key
encr3="$(cat hackcode.txt |cut -d";" -f3)" #retrieve the SHA-256 hash string from hackcode.txt file
hash3="$(echo $encr3 |cut -d"$" -f4)" #retrieve the hash string from SHA-256 hash string
salt3="$(echo $encr3 |cut -d"$" -f3)" #retrieve the salt string from SHA-256 hash string

#SHA-512 Encrypted Key
encr4="$(cat hackcode.txt |cut -d";" -f4)" #retrieve the SHA-512 hash string from hackcode.txt file
hash4="$(echo $encr4 |cut -d"$" -f4)" #retrieve the hash string from SHA-512 hash string
salt4="$(echo $encr4 |cut -d"$" -f3)" #retrieve the salt string from SHA-512 hash string

#counters reset
counter1=0
counter2=0
counter3=0
counter4=0

loop1=0
loop2=0
loop3=0
loop4=0

#To notify user the script is running
echo "Please Wait, Be patient, Currently Processing..."

#Start the loop to compare the hashes
for i in "${LIST1[@]}" #loop the List of capital letter characters
  do
   for j in "${LIST2[@]}" #loop the List of number characters
    do
	for k in "${LIST3[@]}" #loop the List of letter characters
	 do
	  for l in "${LIST4[@]}" #loop the List of unique characters on list4 and list5 
	   	do
		for a in "${LIST5[@]}"
			do

#simultaneously run all 4 hashes to find the same ones	
#Generate MD5 using current looped character with given salt and retrieve the hash code ONLY from MD5 hash string to test1
	test1="$(mkpasswd -m MD5 "$i$j$k$l$a" -s $salt1 | cut -d"$" -f4)" 
	((loop1++)) #times tried of MD5 hashes comaparing
	#display when MD5 password found when comparing
	if [ "$test1" == "$hash1" ] ; then
		printf "\n\nMD5 PASSWORD FOUND\n"
		echo "Loop Counts : $loop1"
		echo "MD5 Password is : $i$j$k$l$a"
		echo "MD5 Salt is     : $salt1"
		counter1=1 #Upate counter that MD5 has been found
	fi


#Generate DES using current looped character with given salt and retrieve DES hash string to test2
	test2="$(mkpasswd -m DES "$i$j$k$l$a" -s $salt2)"
	((loop2++)) #times tried of DES hashes comaparing
	#display when DES password found
	if [ "$test2" == "$encr2" ] ; then
		printf "\n\nDES PASSWORD FOUND\n"		
		echo "Loop Counts : $loop2"
		echo "DES Password is : $i$j$k$l$a"
		echo "DES Salt is     : $salt2"
		counter2=1 #Upate counter that DES has been found
	fi

#Generate SHA-256 using current looped character with given salt and retrieve the hash code ONLY from SHA-256 hash string to test3
	test3="$(mkpasswd -m SHA-256 "$i$j$k$l$a" -s $salt3 | cut -d"$" -f4)"
	((loop3++)) #times tried of SHA-256 hashes comaparing
	#display when SHA-256 password found
	if [ "$test3" == "$hash3" ] ; then
		printf "\n\nSHA-256 PASSWORD FOUND\n"
		echo "Loop Counts : $loop3"
		echo "SHA-256 Password is : $i$j$k$l$a"
		echo "SHA-256 Salt is     : $salt3"
		counter3=1 #Upate counter that SHA-256 has been found
	fi
	
#Generate SHA-512 using current looped character with given salt and retrieve the hash code ONLY from SHA-512 hash string to test4
	test4="$(mkpasswd -m SHA-512 "$i$j$k$l$a" -s $salt4 | cut -d"$" -f4)"
	((loop4++)) #times tried of SHA-512 hashes comaparing
	#display when SHA-512 password found
	if [ "$test4" == "$hash4" ] ; then
		printf "\n\nSHA-512 PASSWORD FOUND\n"
		echo "Loop Counts : $loop4"
		echo "SHA-512 Password is : $i$j$k$l$a"
		echo "SHA-512 Salt is     : $salt4"
		counter4=1 #Upate counter that SHA-512 has been found
	fi

				done
			done
		done
	done
done

#If any of the password not found, display error message.
if [ $counter1 == 0 ] ; then
	printf "\nMD5 PASSWORD NOT FOUND"
fi
if [ $counter2 == 0 ] ; then
	printf "\nDES PASSWORD NOT FOUND"
fi
if [ $counter3 == 0 ] ; then
	printf "\nSHA-256 PASSWORD NOT FOUND"
fi
if [ $counter4 == 0 ] ; then
	printf "\nSHA-512 PASSWORD NOT FOUND"
fi

#End of loops display a notification for user
printf "\n\nBruteforce Completed!\n\n"
