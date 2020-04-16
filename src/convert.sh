#!/bin/bash
# automatic script to convert user's Bitbucket Mercurial repositories to Git
# requres PHP

if [ -z "$1" ] || [ -z "$2" ]
then
      echo "Usage: $0 <bitbucket_user_name> <bitbucket_user_password>"
      exit
fi

bitbucket_user_name=$1  
bitbucket_user_password=$2
team=$3

if [ -z "$3" ]
then
    team=$bitbucket_user_name
fi

echo "Team: "
echo $team

repos_names_str=`php php_scripts/list_hg_repos.php $bitbucket_user_name $bitbucket_user_password $team`
read -r -a repos_names <<< "$repos_names_str"


for Repository in "${repos_names[@]}"; do
    echo "Checking repository: $Repository"

    gitRepoRemoteName="git_$Repository"
    php php_scripts/create_git_repo.php $gitRepoRemoteName $bitbucket_user_name $bitbucket_user_password $team

    ./convert_repo.sh $bitbucket_user_name $Repository $team
done
