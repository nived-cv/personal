# git branch >> branches.txt
# git log --author='nived' >> commits.txt

function get_branches() {
   git branch > branches.txt
   sed -i "s|*||" branches.txt
   readarray a < branches.txt
    for letter in $a; do
        echo $letter
    done
}

function get_changes() {
    readarray branches < branches.txt
    echo $branches
    for branch in $branches; do 
        git checkout $branch
        echo 'hi'
        git log --author='nived' > `${branch}.txt`
    done
}

function main() {
    get_changes
}

main