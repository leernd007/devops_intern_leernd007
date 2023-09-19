#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

BACKUP_FOLDER="backup"
mkdir -p ~/$BACKUP_FOLDER

repo_name="devops_intern_leernd007"

get_archiveName() {
  archiveName=$(find ~/$BACKUP_FOLDER -type f -name 'devops_internship_*.tar.gz' | sort -r | head -n 1)

  if [[ -z "$archiveName" ]]; then
    archiveName="devops_internship_1.0.0.tar.gz"
  else
    input_string="$archiveName"
    if [[ $input_string =~ devops_internship_(.*?)\.tar\.gz ]]; then
        archiveName="devops_internship_$(get_archiveVersion).tar.gz"
    fi
  fi
  echo "$archiveName"
}
get_archiveVersion() {
  archiveName=$(find ~/$BACKUP_FOLDER -type f -name 'devops_internship_*.tar.gz' | sort -r | head -n 1)
  version="1.0.0"
  input_string="$archiveName"
  if [[ $input_string =~ devops_internship_(.*?)\.tar\.gz ]]; then
      version="${BASH_REMATCH[1]}"
      version=$(echo "$version" | gawk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
  fi
  echo "$version"
}
create_archive() {
  archiveName=$1
  version=$2

  cd "$SCRIPT_DIR/$repo_name" && tar --exclude=".git" -czvf "$archiveName" .  >/dev/null 2>&1
  mv $archiveName ~/$BACKUP_FOLDER
  file_size=$(stat -c %s ~/$BACKUP_FOLDER/$archiveName)
  if [[ ! -f ~/$BACKUP_FOLDER/versions.json ]]; then
    echo "[]" > ~/$BACKUP_FOLDER/versions.json
  fi

  jq --arg version "$version" \
     --arg date "$(date +%d.%m.%Y)" \
     --argjson size "$file_size" \
     --arg filename "${archiveName%%.tar.gz}" \
     '. += [{
       "version": $version,
       "date": $date,
       "size": $size,
       "filename": $filename
     }]' ~/$BACKUP_FOLDER/versions.json > tmpfile && mv tmpfile ~/$BACKUP_FOLDER/versions.json
}

echo "$ssh_prv_key" > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa && ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone git@github.com:leernd007/$repo_name.git
rm ~/.ssh/id_rsa

number_of_backups="$backup_runs"

if [[ -n "$number_of_backups" ]]; then
  for ((i = 1; i <= "$number_of_backups"; i++)); do
      create_archive "$(get_archiveName)" "$(get_archiveVersion)"
  done
else
  create_archive "$(get_archiveName)" "$(get_archiveVersion)"
fi
if [[ -n "$max_backups"  ]]; then
  files_to_remove=$(find ~/$BACKUP_FOLDER -maxdepth 1 -type f -name 'devops_internship_*.tar.gz' | sort -r | tail -n +"$(($max_backups+1))")
  if [ -n "$files_to_remove" ]; then
    rm $files_to_remove
  fi
fi

rm -rf $repo_name