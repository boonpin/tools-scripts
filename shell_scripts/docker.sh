
DockerPushLocalImageAsVersion() {
  local HOST=$1
  local IMG=$2
  local VER=$3

  IMG_TAG=$HOST/witotechnology/$IMG:$VER

  echo "pushing image $IMG to $HOST"

  docker image tag $IMG:local $IMG_TAG
  docker push $IMG_TAG
  docker rmi $IMG_TAG
}
