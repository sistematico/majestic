#!/usr/bin/env bash
#
#
# This script creates XML files that can act as dynamic wallpapers for GNOME by referring to multiple wallpapers
# Coded by David J Krajnik

writePropertiesFile() {

    name=$(echo "${1%.*}")

    cat >${name}.prop.xml <<EOL
<?xml version="1.0"?>
<!-- Move this file to /usr/share/gnome-background-properties/ !!!! -->
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
    <wallpaper deleted="false">
        <name>${name}</name>
        <filename>/usr/share/backgrounds/${name}/${1}</filename>
        <options>zoom</options>
        <shade_type>solid</shade_type>
        <pcolor>#3465a4</pcolor>
        <scolor>#000000</scolor>
    </wallpaper>
</wallpapers>
EOL
}

if [ ! $1 ]; then
    echo "This script creates XML files that can act as dynamic backgrounds for GNOME by referring to multiple wallpapers"
    echo "Usage: $(basename $0) target-file.xml [duration] pic1 pic2 [pic3 .. picN]"
else
    #Grab the name of the target xml file
    files=$*

    #remove the first item from $files
    xmlfile=$(echo $files | cut -d " " -f 1)
    files=$(echo $files | sed 's/^\<[^ ]*\>//')

    if [ "$(echo $xmlfile | grep '\.xml$')" = "" ]; then
        echo "Your target file must be an XML file"
    else
        inputIsValid="true"
        firstItem=$(echo $files | cut -d " " -f 1)
        duration="1795.0" #set the default duration

        if [ "$(echo $firstItem | grep '^[0-9]\+\.[0-9]\+$')" != "" ]; then
            echo "The duration must be an integer"
            files=$(echo $files | sed 's/^\<[^ ]*\>//')
            inputIsValid=""
        elif [ "$(echo $firstItem | grep '^[0-9]\+$')" != "" ]; then
            #If the item is a number, then use it as the duration for each wallpaper image
            duration="$(expr $firstItem - 5).0"

            #remove the duration from the list of files
            files=$(echo $files | sed 's/^\<[^ ]*\>//')
        fi

        if [ "$files" = "" ]; then
            echo "You must enter image files to associate with the XML file"
        else
            for file in $files; do
                if [ ! -f $file ]; then
                    echo "\"$file\" does not exist"
                    inputIsValid=""
                elif [ "$(echo $file | sed 's/^.*\.\(jpg\|jpeg\|bmp\|png\|gif\|tif\|tiff\|jif\|jfif\|jp2\|jpx\|j2k\|j2c\)$//')" != "" ]; then
                    echo "\"$file\" is not an image file"
                    inputIsValid=""
                fi
            done

            if [ $inputIsValid ]; then
                currDir=$(pwd)

                echo "<background>" >>$xmlfile
                echo -e "  <starttime>\n    <year>2009</year>\n    <month>08</month>\n    <day>04</day>" >>$xmlfile
                echo -e "    <hour>00</hour>\n    <minute>00</minute>\n    <second>00</second>\n  </starttime>" >>$xmlfile
                echo -e "  <!-- This animation will start at midnight. -->" >>$xmlfile

                firstFile=$(echo $files | cut -d " " -f 1) # grab the first item

                if [ "$(echo $firstFile | sed 's/\(.\).*/\1/')" != "/" ]; then
                    #If the first character in the filename is not '/', then it is a relative path and must have the current directory's path appended
                    firstFile="$currDir/$firstFile"
                fi

                firstFile=$(echo $firstFile | sed 's/[^/]\+\/\.\.\/\?//g') #Remove occurrences of ".." from the filepath
                files=$(echo $files | sed 's/^\<[^ ]*\>//')                # remove the first item
                prevFile=$firstFile
                currFile=""
                #TODO add absolute path to the filenames
                #if $currFile =~ "^/.*" then the file needs to path appended

                echo -e "  <static>\n    <duration>$duration</duration>\n    <file>$firstFile</file>\n  </static>" >>$xmlfile

                for currFile in $files; do
                    if [ "$(echo $currFile | sed 's/\(.\).*/\1/')" != "/" ]; then
                        #If the first character in the filename is not '/', then it is a relative path and must have the current directory's path appended
                        currFile="$currDir/$currFile"
                    fi
                    currFile=$(echo $currFile | sed 's/[^/]\+\/\.\.\/\?//g') # Remove occurrences of ".." from the filepath
                    echo -e "  <transition>\n    <duration>5.0</duration>\n    <from>$prevFile</from>\n    <to>$currFile</to>\n  </transition>" >>$xmlfile
                    echo -e "  <static>\n    <duration>$duration</duration>\n    <file>$currFile</file>\n  </static>" >>$xmlfile
                    prevFile=$currFile
                done

                echo -e "  <transition>\n    <duration>5.0</duration>\n    <from>$currFile</from>\n    <to>$firstFile</to>\n  </transition>" >>$xmlfile
                echo "</background>" >>$xmlfile

                writePropertiesFile $xmlfile

            fi
        fi
    fi
fi
