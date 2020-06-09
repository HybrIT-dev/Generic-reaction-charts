defaultchartdir="./charts/"

searchstring=$1
replacestring=$2
chartdirectory=${3:-$defaultchartdir}
filepath="$chartdirectory$searchstring"
newfilepath="$chartdirectory$replacestring"

useagestring="Intended command usage: ./chartRenameScript <searchstring> <replacestring> (optional:<chartdirectory>)"

if [ -z "$searchstring" ]
then
  echo -e "\e[91mError\e[39m: required a searchstring target. example: hyb-reaction-api"
  echo $useagestring
  exit
fi
if ! [[ $searchstring =~ ^[a-zA-Z\-]+$ ]];then
  echo -e "\e[91mError\e[39m: $searchstring contains invalid character"
  echo "allowed characters are a-z A-Z and -"
  echo $useagestring
  exit
fi

if [ -z "$replacestring" ]
then
  echo -e "\e[91mError\e[39m: required a replacestring. example: mol-reaction-api"
  echo $useagestring
  exit
fi
if ! [[ $replacestring =~ ^[a-zA-Z\-]+$ ]];then
  echo -e "\e[91mError\e[39m: $replacestring contains invalid character"
  echo "allowed characters are a-z A-Z and -"
  echo $useagestring
  exit
fi

if [ $searchstring == $replacestring ]
then
  echo -e "\e[91mError\e[39m: $searchstring and $replacestring are equal, no changes"
  exit
fi

if [ ! -d "$filepath" ]
then
  echo -e "\e[91mError\e[39m: chart directory $filepath not found"
  exit
fi

echo -e "\e[32mReplacing\e[39m:  $searchstring in $filepath with $replacestring"
for file in $(grep -l -R $searchstring $filepath)
do
  sed -e "s/$searchstring/$replacestring/ig" $file > tempfile.tmp
  mv tempfile.tmp $file

  echo -e "\e[32mModified\e[39m: " $file
done

mv $filepath $newfilepath
echo -e "\e[32mMoved\e[39m:  $filepath to $newfilepath"

git add $newfilepath
echo -e "\e[32mAdded-to-git\e[39m:  $newfilepath"

echo -e "\e[5m!!!\e[25m Remember to modify the azure-pipelines.yml file and any secret files as well \e[5m!!!\e[25m "
