#!/bin/bash
# script i made to make my life easier. it is now easier. rejoice.

# You just need to adjust the hardcoded values
# in the script for it to work if youd like to use it.
# Make sure to have fenix cloned and point it fo the right
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

# Alias for echo to handle escape codes like colors
function echo() {
    command echo -e "$@"
}

# in case i need this
while [ $# -gt 0 ]
do
    case $1 in
        '--debug')
            clear
            for l in It worked ; do
                echo -n ${bold}$l
                echo " "
                eecho " "
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
    git pull

    # WIP #
    if [ ! -f "build.sh" ] ; then
        wget http://get.hifiibuilds.com/Scripts/build.sh
        chmod a+x build.sh
    fi

    echo " "
    echo " "
    echo "Building. Might take a few moments."
    sleep 0.5
    echo " "
    echo " "

    # run this but thread it so it gets done faster
    #    for d in /$Fenix ; do (cd "$d" && find -name '*.sh' -print0 | xargs -P8 -L1 -0 sh build.sh); done
    sh build.sh
    echo " "
    echo " "
    echo "Should be done now."
    sleep 0.2
    echo " "
    echo "Onto signing app..."
}

signFenix() {
    java -jar ~/signer.jar -a ~/fenix/app/build/outputs/apk/geckoNightly/fenixNightly/app-geckoNightly-arm64-v8a-fenixNightly-unsigned.apk --out $FenixHome
}

doCd() {
    if [ ! -d $FenixHome ]; then mkdir -p $FenixHome; fi
    #  if [ -d "$FenixHome/$TodaysDate" ]; then cd $FenixHome && mkdir -p $TodaysDate__2; fi

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

buildFenix
doCd
signFenix
makeChangelog
cd $FenixHome
mv app-geckoNightly-arm64-v8a-fenixNightly-aligned-debugSigned.apk Fenix-Arm64-hifii__nightly-$(date +"%m-%d-%Y").apk
if [ -d "$FenixHome/$TodaysDate" ]; then mkdir -p 10-06-2019__2 ; fi
d $FenixChanges/$TodaysDate ]; then mkdir -p $FenixChanges/$TodaysDate; fi

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
makeChangelog
cd $FenixHome
mv app-geckoNightly-arm64-v8a-fenixNightly-aligned-debugSigned.apk Fenix-Arm64-hifii__nightly-$(date +"%m-%d-%Y")$var.apk
if [ -d "$FenixHome/$TodaysDate" ]; then mkdir -p $fenixHomeCountUp ; fi
