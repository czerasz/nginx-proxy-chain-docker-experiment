#!/bin/bash

script_dirirectory="$( cd "$( dirname "$0" )" && pwd )"
project_dirirectory=$script_dirirectory/..

nginx_version=1.9.12

echo 'Usage:'
script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
echo "$script_name [command] [containers number]"
echo -e "\nWhere:"
echo '- command           - command to execute. Possible values [start, delete]'
echo '- containers number - number of containers to create or delete'

if [ -z $1 ]; then
  echo -e "\nNo command defined"
  script_command='start'
  echo "Fall back to default command: $script_command"
else
  script_command=$1
fi

if [ -z $2 ]; then
  echo -e "\nNo number of containers specified"
  max=5
  echo "Fall back to default containers number: $max"
else
  max=$(echo "$2" | bc)
fi

echo -e "\n"

# Remove all the nginx containers
for i in $( seq $max -1 0 ); do
  docker rm -f nginx-$i &>/dev/null
done

# Start containers only if no quit parameter was passed
if [ "$script_command" != "delete" ]; then
  echo "Start $max (last) nginx container"

  # Start the last nginx container
  docker run -d \
             --name=nginx-$max \
             --volume=$project_dirirectory/shared:/var/www/html:ro \
             --volume=$project_dirirectory/config/nginx/last.conf:/etc/nginx/conf.d/default.conf \
             nginx:$nginx_version

  # Descrease max
  for i in $( seq $max -1 1 ); do
    current_container_index=$(($i-1))

    if [[ $current_container_index -eq 0 ]]; then
      echo "Start 0 (first) nginx container"

      # Start the first nginx container
      docker run -d \
                 --name=nginx-$current_container_index \
                 --link=nginx-$i:proxy \
                 -p 8080:80 \
                 --volume=$project_dirirectory/config/nginx/every.conf:/etc/nginx/conf.d/default.conf \
                 nginx:$nginx_version
    else
      echo "Start $current_container_index nginx container"

      # Start the nth nginx container
      docker run -d \
                 --name=nginx-$current_container_index \
                 --link=nginx-$i:proxy \
                 --volume=$project_dirirectory/config/nginx/every.conf:/etc/nginx/conf.d/default.conf \
                 nginx:$nginx_version
    fi
  done
else
  echo "Just delete the containers";
fi
