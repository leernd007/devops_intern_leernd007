#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

BACKUP_FOLDER="backup"
max_backups=""
mkdir -p ~/$BACKUP_FOLDER
if [[ "$1" == "--max-backups" && -n "$2"  ]]; then
  max_backups="$2"
  files_to_remove=$(find ~/$BACKUP_FOLDER -maxdepth 1 -type f -name 'devops_internship_*.tar.gz' | sort -r | tail -n +"$max_backups")
  if [ -n "$files_to_remove" ]; then
    rm $files_to_remove
  fi
fi

archiveName=$(find ~/$BACKUP_FOLDER -type f -name 'devops_internship_*.tar.gz' | sort -r | head -n 1)
version="1.0.0"
if [[ -z "$archiveName" ]]; then
  archiveName="devops_internship_1.0.0.tar.gz"
else
  input_string="$archiveName"
  if [[ $input_string =~ devops_internship_(.*?)\.tar\.gz ]]; then
      version="${BASH_REMATCH[1]}"
      version=$(echo "$version" | gawk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
      archiveName="devops_internship_$version.tar.gz"
  fi
fi
repo_name="devops_intern_leernd007"

echo "$ssh_prv_key" > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa && ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone git@github.com:leernd007/$repo_name.git
rm ~/.ssh/id_rsa

cd $SCRIPT_DIR/$repo_name && tar --exclude=".git" -czvf "$archiveName" .
mv $SCRIPT_DIR/$repo_name/$archiveName ~/$BACKUP_FOLDER
file_size=$(stat -c %s ~/$BACKUP_FOLDER/$archiveName)
rm -rf $repo_name
echo "[
  {
     "version": "$version",
     "date": "$(date +%d.%m.%Y)",
     "size": "$file_size",
     "filename": "${archiveName%%.tar.gz}"
  }
]" > ~/$BACKUP_FOLDER/versions.json
