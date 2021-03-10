pre="'"
pos="'=>'sertanejo',"
#ls -1 sdm/ | sed "s|.*|${pre}&${pos}|"
cat sdm/love.txt | sed "s|.*|${pre}&${pos}|"
