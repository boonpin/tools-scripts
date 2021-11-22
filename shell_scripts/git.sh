
DoGitUpdate() {
  DL_DIR=$1
  SSH_REPO=$2
  HTTP_REPO=$3
  BRANCH=$4

  DockerGit() {
      local PARAMS=$@
      docker run -ti --rm -v $HOME/.ssh:/root/.ssh -v $DL_DIR:/git alpine/git:v2.32.0 $PARAMS
  }

  # clean non git folder
  if [ -d $DL_DIR ]; then
    if [ ! -d "$DL_DIR/.git" ]; then
        echo ">> found target folder $DL_DIR, but missing .git directory"
        echo ">> do you want to clean up the folder ?"
        CLEAR_DIR=$( PromptYesNo )

        if [ $CLEAR_DIR == "1" ]; then
          echo ">> cleaning folder $DL_DIR...."
          rm -rf $DL_DIR
        fi
    fi
  fi

  if [ ! -d $DL_DIR ]; then
      echo ">> core source not found, please select using ssh or http git repo:"
      echo "\t *(ssh): $SSH_REPO"
      echo "\t *(http): $HTTP_REPO"

      USE_REPO=""
      while true ; do
        echo ">> ssh/http"
        read -r -p ">> select the repo type. [ssh/http] " SELECT_TYPE

        case $SELECT_TYPE in
        ssh)
          USE_REPO=$SSH_REPO
          break
          ;;
        http)
          USE_REPO=$HTTP_REPO
          break
          ;;
        *)
          echo "unknown type $SELECT_TYPE"
          ;;
        esac
      done
      echo ">> using repo $USE_REPO"

      echo ">> cloning source to $DL_DIR"
      DockerGit clone -b $BRANCH $USE_REPO ./
      DockerGit config pull.ff only
  else
      echo ">> fetching .... "
      DockerGit fetch

      echo ">> checkout branch $BRANCH .... "
      DockerGit checkout $BRANCH
  fi

  HEAD_REV=$(DockerGit rev-parse HEAD)
  echo ">>>>> HEAD REV: $HEAD_REV"

  DATE=`date`
  HOST=`hostname`

  echo "branch: $BRANCH\ncommit: $HEAD_REV\nhostname: $HOST\ndate: $DATE" > $DL_DIR/git-rev
}
