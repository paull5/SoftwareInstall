function compress()
{
if [ $# -ne 1 ]; then
   echo "Please enter one file name:"
else
   if [[ -e $1 ]]; then
      tar cvf $1.tgz $1
#     if tar czf $1.tgz $1
      echo "The file " $1 " has been compressed"
   fi
fi
}
compress $1
