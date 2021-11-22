PromptYesNo() {

  while true
  do
   read -r -p "Are You Sure? [Y/n] " input

   case $input in
    [yY][eE][sS]|[yY])
      echo "1"
      break;
       ;;
     [nN][oO]|[nN])
      echo "0"
      break
      ;;
    *)
      echo "Invalid input..."
      ;;
   esac
  done
}
