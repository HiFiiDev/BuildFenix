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
var=$((var + 2))
doubleUnderscore="__"
fenixHomeCountUp=/var/www/html/Fenix/Builds/$TodaysDate$doubleUnderscore$var
fenixChangelogCountup=/var/www/html/Fenix/Changelogs/$TodaysDate$doubleUnderscore$var

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
    echo  "Building... "
    sleep 0.3
    echo "This will take a few moments."
    sleep 0.3

    # run this but thread it so it gets done faster
    #    for d in /$Fenix ; do (cd "$d" && find -name '*.sh' -print0 | xargs -P8 -L1 -0 sh build.sh); done
    echo " "
    ./build.sh
    mv ~/fenix/app/build/outputs/apk/geckoNightly/fenixNightly/app-geckoNightly-arm64-v8a-fenixNightly-unsigned.apk ~/fenix/app/build/outputs/apk/geckoNightly/fenixNightly/Fenix-Arm64-hifii__nightly-$(date +"%m-%d-%Y")__$var.apk
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
    java -jar ~/signer.jar -a ~/fenix/app/build/outputs/apk/geckoNightly/fenixNightly/Fenix-Arm64-hifii__nightly-$(date +"%m-%d-%Y")__$var.apk --out $fenixHomeCountUp

    # Sorry for hardcoding!
    # 10-18-2019
    cd  $fenixHomeCountUp && mv *.apk Fenix-Arm64-hifii__nightly-$(date +"%m-%d-%Y")__$var.apk
}

doCd() {
    if [ ! -d $FenixHome ]; then mkdir -p $FenixHome; fi
    if [ -d "$FenixHome/$TodaysDate" ]; then mkdir -p $fenixHomeCountUp && echo "made dir!"; fi
}
makeChangelog() {
    #TO DO 10-18-2019:
    # clean up code

    clear
    echo "Making a changelog..."
    echo " "
    sleep 1
    cd $FenixChanges
    if [ ! -d $FenixChanges/$TodaysDate ] ; then
        mkdir -p $FenixChanges/$TodaysDate
    fi

    if [ -d $FenixChanges/$TodaysDate ] ; then
        mkdir -p $fenixChangelogCountup && cd $fenixChangelogCountup
        cd $Fenix
        git log --reverse --no-merges --since=1.day.ago >> Fenix_changelog_$TodaysDate$doubleUnderscore$var.txt
    fi
    cd $Fenix
    git log --reverse --no-merges --since=1.day.ago >> Fenix_changelog_$TodaysDate.txt
    cp Fenix_changelog_$TodaysDate$doubleUnderscore$var.txt $fenixChangelogCountup
}

clear
echo " "
echo "Welcome, $USER!"
echo " "
sleep 1
echo "Run ./fenix.sh --opti to optipng everything before building!"
echo " "
sleep 0.75

# was just testing this
# echo $fenixHomeCountUp

buildFenix
doCd
signFenix
if [ -d "$FenixHome/$TodaysDate" ]; then mkdir -p $fenixHomeCountUp ; fi
makeChangelog
cd $FenixHome

# more tests
# mv app-geckoNightly-arm64-v8a-fenixNightly-aligned-debugSigned.apk Fenix-Arm64-hifii__nightly-$(date +"%m-%d-%Y")$var.apk
#if [ -d "$FenixHome/$TodaysDate" ]; then mkdir -p $fenixHomeCountUp ; fi
