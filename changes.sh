TodaysDate=$(date +"%m-%d-%Y")

git log --reverse --no-merges --since=2.days.ago >> Fenix_changelog_$TodaysDate.txt
