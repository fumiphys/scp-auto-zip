#/bin/bash
ZIPFILE="tmp_scp_auto.zip"
ZIPBASE="tmp_scp_auto"

function saz(){
  FROM="$1"
  TO="$2"
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
    ssh ${REMOTE} "zip -r ${ZIPFILE} ${REMOTE_DIR} > /dev/null;"
    scp ${REMOTE}:${ZIPFILE} ${TO}
    ssh ${REMOTE} "rm ${ZIPFILE}"
    unzip ${ZIPFILE} > /dev/null
    rm ${ZIPFILE}
  elif [[ ${TO} =~ '^([^:]+):([^:]+)$' ]]; then
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
    zip -r ${ZIPFILE} ${FROM} > /dev/null
    scp ${ZIPFILE} ${REMOTE}:${REMOTE_DIR}
    ssh ${REMOTE} "cd ${REMOTE_DIR}; unzip ${ZIPFILE} > /dev/null"
  else
    echo "invalid arguments"
    return 1
  fi
}
