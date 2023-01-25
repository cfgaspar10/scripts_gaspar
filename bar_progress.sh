# After wondering how commands like curl showed a progress bar, with the very big help of
# Google, I decided to write a shell script to show a progress bar
#
# Having not done much shell scripting, I learned a few (very likely quite obvious) things:
#   * It looks much nicer to create the string to echo in a variable, then echo it.  If I echo'ed
#     each part of the string instead of concatenating it with the rest of the string, the cursor
#     jumped around quite a bit.
#   * 'let x=x+1' is a lot faster than 'x=`expr $x + 1`' (I have a feeling this is probably because
#     let is implemented directly in bash, instead of a separate command)

for i in {1..100}; do
	output="\r"

	output="$output ["
	total=$i
	count=0
	
	while [ $count -lt $total ]; do
		output="$output#"
		let count=$count+1
	done

	let total=100-$total
	count=0

	while [ $count -lt $total ]; do
		output="$output " 
		let count=$count+1
	done
	output="$output] $i%"
	echo -ne "$output"

	sleep .01
done

printf "\n"