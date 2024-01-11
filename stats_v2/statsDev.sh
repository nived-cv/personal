# git branch >> branches.txt
# git log --author='nived' >> commits.txt

function get_commits() {

   git branch >> branches.txt
   sed -i "s|*||" branches.txt
   readarray a < branches.txt
    for letter in $a; do
        echo $letter
    done
}

get_commits
