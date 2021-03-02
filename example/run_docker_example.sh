#!/bin/bash
docker run -d kscodemagic/fastfluttertests:1.0
unset CONTAINER_ID
export CONTAINER_ID=$(docker ps -l -q)
docker exec -d $CONTAINER_ID sh -c "Xvfb :0 -screen 0 1920x1920x24"
docker exec $CONTAINER_ID sh -c "cd /home/user/fast_flutter_driver && git pull && cd /home/user/fast_flutter_driver/example && flutter packages get && fastdriver -r 1300x1000 -s --dart-args \"--no-sound-null-safety\" --flutter-args \"--no-sound-null-safety\""