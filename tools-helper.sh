echo "=============DART============"
echo "1. import_sorter"

while :
do 
	read -p "Run with: " input
	case $input in
		1)
		flutter pub run import_sorter:main
		break
		;;
        *)
		;;
	esac
done