#!/usr/bin/env bash
set -e

EXECUTION_DIR="$PWD/workflows/scc18-containerless/execution"

# download zenodo files
files=$(curl \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X GET \
  https://zenodo.org/api/records/439946)
files=$(echo "$files" | jq -r '.files |.[]| .filename')

file_list=""
for file in $files; do
    file_list=$file_list$file,
done
IFS=','

mkdir -p "$EXECUTION_DIR"
cd "$EXECUTION_DIR"

for i in ${file_list}; do
  echo "$i"
  if [[ ! -e "$i" ]]; then
    curl -LO https://zenodo.org/record/439946/files/"$i"
  fi
done

# download extra files

wget https://github.com/SeisSol/SeisSol/files/3353667/sumatra_easi.zip
unzip sumatra_easi.zip
rm sumatra_easi.zip

sed -i "s#FL = .*#FL = 16#" parameters_zenodo_easi.par