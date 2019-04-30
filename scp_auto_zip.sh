#/bin/bash
ZIPFILE="tmp_scp_auto.zip"

function saz(){
  FROM="$1"
  TO="$2"
  echo ${FROM}
  echo ${TO}
  if [[ ${FROM} =~ '^([^:]+):([^:]+)$' ]]; then
    REMOTE=""
    REMOTE_DIR=""
    if [[ ${SHELL} =~ '^.*/zsh$' ]]; then
      REMOTE=${match[1]}
      REMOTE_DIR=${match[2]}
    else
      REMOTE=${BASH_REMATCH[1]}
      REMOTE_DIR=${BASH_REMATCH[2]}
    fi
    echo "remote host: ${REMOTE}"
    echo "remote directory: ${REMOTE_DIR}"
    ssh ${REMOTE} "zip -r ${ZIPFILE} ${REMOTE_DIR};"
    scp ${REMOTE}:${ZIPFILE} ${TO}
    ssh ${REMOTE} "rm ${ZIPFILE}"
    unzip ${ZIPFILE}
    rm ${ZIPFILE}
  elif [[ ${TO} =~ '^([^:]+):([^:])$' ]]; then
    echo "not implemented"
  else
    echo "invalid arguments"
    return 1
  fi
}
