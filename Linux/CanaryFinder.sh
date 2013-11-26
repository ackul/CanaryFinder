#!/bin/bash

do_I_have_readelf=1
 
# Will add full ELF reading support, For now its...
version() {
  echo "CanaryFinder 1.0, Achin Kulshrestha (@GeekMonk), 2012"
}

# help help help help help
help() {
  echo "Usage: CanaryFinder [OPTION]"
  echo
  echo "Options:"
  echo
  echo "  --file <ELF File>"
  echo "  --ver"
  echo "  --help"
  echo
  echo "For more info, please see my project page on:"
  echo "Achin Kulshrestha, @Geekmonk"
  echo "http://www.achin.in"
  echo
}

# Just to see if the command is there
assert_command () {
  type $1  > /dev/null 2>&1;
}

# check if directory exists
is_dir () {
  if [ -d $1 ] ; then
    return 0
  else
    return 1
  fi
}

# User privileges check please
find_privilege () {
  if [ $(/usr/bin/id -u) -eq 0 ] ; then
    return 0
  else
    return 1
  fi
}

# Dumb check for numeric
isNumeric () {
  echo "$@" | grep -q -v "[^0-9]"
}

# Dumb check for string
isString () {
  echo "$@" | grep -q -v "[^A-Za-z]"
}

#Boom the file and dig out the canary 
boom_file() {

  # check for stack canary support
  if readelf -s $1 2>/dev/null | grep -q '__stack_chk_fail'; then
    echo -n -e '\033[36mCanary found   \033[m   '
  else
    echo -n -e '\033[32mOhhhh...No Canary...at Risk\033[m   '
  fi

  # check for NX support
  if readelf -W -l $1 2>/dev/null | grep 'GNU_STACK' | grep -q 'RWE'; then
    echo -n -e '\033[32mNX disabled\033[m   '
  else
    echo -n -e '\033[36mNX enabled \033[m   '
  fi 

}


if !(assert_command readelf) ; then
  printf "\033[Alert Alert: readelf is required to run this mighty script.\n\n"
  do_I_have_readelf=0
fi

# parse command-line arguments
case "$1" in

 --ver)
  version
  exit 0
  ;;

 --help)
  help
  exit 0
  ;;

 --file)
  if [ $do_I_have_readelf -eq 0 ] ; then
    exit 1
  fi
  if [ -z "$2" ] ; then
    printf "\033[31mAlert: Please provide a valid file.\033[m\n\n"
   exit 1
  fi
  # does the file exist?
  if [ ! -e $2 ] ; then
    printf "\033[31mAlert: The file '$2' does not exist.\033[m\n\n"
    exit 1
  fi
  # read permissions?
  if [ ! -r $2 ] ; then
    printf "\033[31mAlert: No read permission '$2' Please run as root.\033[m\n\n"
    exit 1
  fi
  # ELF executable?
  out=`file $2`
  if [[ ! $out =~ ELF ]] ; then
    printf "\033[31mAlert: Not an ELF file: "
    file $2
    printf "\033[m\n"
    exit 1
  fi
  printf "STACK CANARY      NX		FILENAME\n"
  boom_file $2
  if [ `find $2 \( -perm -004000 -o -perm -002000 \) -type f -print` ] ; then
    printf "\033[37;44m%s%s\033[m" $2 $N
  else
    printf "%s" $2
  fi
  echo
  exit 0
  ;;

*)
  if [ "$#" != "0" ] ; then
    printf "\033[31mAlert: Unknown option '$1'.\033[m\n\n"
  fi
  help
  exit 1
  ;;
esac
