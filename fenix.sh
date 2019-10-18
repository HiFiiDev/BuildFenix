#!/bin/bash
# script i made to make my life easier. it is now easier. rejoice.

# You just need to adjust the hardcoded values
# in the script for it to work if youd like to use it.
# Make sure to have fenixcloned and point it fo the right
# dirextory. same thing for anything related to my server
# directory I hardcoded for now

TodaysDate=$(date +"%m-%d-%Y")
FenixHome=/var/www/html/Fenix/Builds/$TodaysDate/
FenixChanges=/var/www/html/Fenix/Changelogs
Fenix=~/fenix
bold=$(tput bold)
BOLD="\033[1m"
GREEN=$'\e[0;32m'
On_Blu='\e[44m';
# bold white
BWhi='\e[1;37m';
var=" Number "
var+=$((var + 2))
varAlt=$((var + 2))
doubleUnderscore="__"
fenixHomeCountUp=/var/www/html/Fenix/Builds/$TodaysDate$var
fenixHomeCountUpUnderscore=/var/www/html/Fenix/Builds/$TodaysDate$doubleUnderscore$varAlt

# Alias for echo to handle escape codes like colors
function echo() {
    command echo -e "$@"
}

# in case i need this
while [ $# -gt 0 ]
do
    case $1 in
        '--opti')
            clear
            for l in It worked ; do
                if [ ! -f "build.sh" ] ; then
                    echo "Downloading file... "
                    wget http://get.hifiibuilds.com/Scripts/opti.sh
                    echo " "
                    sleep 0.5
                    echo "Done"
                    chmod a+x opti.sh && sh opti.sh
                fi
            done
            ;;
        *)
            echo "unrecognised arg $1"
            ;;
    esac
    shift
done

buildFenix() {
    cd $Fenix

    echo "updating source..."
    echo " "
    sleep 0.5

    git pull

    # WIP #
    if [ ! -f "build.sh" ] ; then
        echo "Downloading build script..."
        wget http://get.hifiibuilds.com/Scripts/build.sh
        chmod a+x build.sh
    fi

    echo " "
    echo " "
    echo  "Building. \nThis will take a few moments."
    sleep 0.5

    # run this but thread it so it gets done faster
    #    for d in /$Fenix ; do (cd "$d" && find -name '*.sh' -print0 | xargs -P8 -L1 -0 sh build.sh); done
    ./build.sh
    echo " "
    echo " "
    echo "Should be done now."
    sleep 0.2
    echo " "
}

signFenix() {
    echo "Signing apk... "
    #   echo -e "\e[1;97m **TEXT OR COMMAND HERE**
    #    java -jar ~/signer.jar -a ~/fenix/app/build/outputs/apk/geckoNightly/fenixNightly/app-geckoNightly-arm64-v8a-fenixNightly-unsigned.apk --out $FenixHomeCountUp
    java -jar ~/signer.jar -a ~/fenix/app/build/outputs/apk/geckoNightly/fenixNightly/app-geckoNightly-arm64-v8a-fenixNightly-unsigned.apk --out $fenixHomeCountUpUnderscore
}

doCd() {
    if [ ! -d $FenixHome ]; then mkdir -p $FenixHome; fi
    if [ -d "$FenixHome/$TodaysDate" ]; then cd $FenixHome && mkdir -p $TodaysDate+$var && echo "made dir!"; fi

    #if [ -d "$FenixHome/$TodaysDate" ]; then
    # cd $FenixHome && mkdir -p $TodaysDate__2
    #fi
}
makeChangelog() {
    cd $FenixChanges
    if [ ! -d $FenixChanges/$TodaysDate ]; then mkdir -p $FenixChanges/$TodaysDate; fi

    cd $Fenix
    git log --reverse --no-merges --since=1.day.ago >> Fenix_changelog_$TodaysDate.txt
    mv Fenix_changelog_$TodaysDate.txt $FenixChanges/$TodaysDate/
}

clear
echo " "
echo "Welcome, $USER! \n"
sleep 1
# was just testing this
# echo $fenixHomeCountUp
buildFenix
doCd
signFenix
if [ -d "$FenixHome/$TodaysDate" ]; then mkdir -p $fenixHomeCountUp ; fi
makeChangelog
cd $FenixHome
# mv app-geckoNightly-arm64-v8a-fenixNightly-aligned-debugSigned.apk Fenix-Arm64-hifii__nightly-$(date +"%m-%d-%Y")$var.apk
#if [ -d "$FenixHome/$TodaysDate" ]; then mkdir -p $fenixHomeCountUp ; fi
