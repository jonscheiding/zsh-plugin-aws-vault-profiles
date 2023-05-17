if ! type "aws-vault" > /dev/null; then
  return
fi

export AWS_SDK_LOAD_CONFIG="1"

alias aws-vault="AWS_PROFILE= aws-vault"

function awsv {
  COMMAND=$1
  COMMAND=${COMMAND:-"shell"}

  if [ ! -z "$AWS_VAULT" ]; then
    echo "$(tput setaf 3)Already using $AWS_VAULT profile.$(tput sgr0)" >&2
    "$@"
    return $?
  fi

  echo -e "$(tput setaf 6)Executing $COMMAND with aws-vault using the $(_profile) profile.$(tput sgr0)" >&2
  aws-vault exec $(_profile) -- "$@"
}

function awsc {
  if [[ -z "$@" ]]; then
    echo "Usage: $0 <command>" >&2
    return 2;
  fi

  type crudini > /dev/null || {
    echo "$(tput setaf 3)This command requires the crudini tool. Please install it with pip install crudini.$(tput sgr0)" >&2
    return 1
  }

  echo -e "$(tput setaf 6)Storing temporary credentials for the $(_profile) profile.$(tput sgr0)" >&2

  SET_CREDENTIALS="
    $(_crudini --set aws_access_key_id \$AWS_ACCESS_KEY_ID) && 
    $(_crudini --set aws_secret_access_key \$AWS_SECRET_ACCESS_KEY) &&
    $(_crudini --set aws_session_token \$AWS_SESSION_TOKEN)"

  if [ ! -z "$AWS_VAULT" ]; then
    bash -c $SET_CREDENTIALS
  else
    aws-vault exec $(_profile) -- bash -c $SET_CREDENTIALS
  fi

  AWS_PROFILE=$(_profile) "$@"
  EXIT_STATUS=$?

  echo -e "$(tput setaf 6)Removing temporary credentials for the $(_profile) profile.$(tput sgr0)" >&2

  $(_crudini --del aws_access_key_id) && \
  $(_crudini --del aws_secret_access_key) && \
  $(_crudini --del aws_session_token)

  return $EXIT_STATUS
}

function _crudini {
  AWS_CREDENTIALS_FILE=${AWS_SHARED_CREDENTIALS_FILE:-$HOME/.aws/credentials}
  OP=$1
  shift
  ARGS="$@"

  echo crudini $OP $(_credentials) $(_profile) $ARGS
}

function _profile {
  echo ${AWS_VAULT:-${AWS_PROFILE:-default}}  
}

function _credentials {
  echo ${AWS_SHARED_CREDENTIALS_FILE:-$HOME/.aws/credentials}
}

prompt_awsvault() {
  ICON=''

  if [[ -n $AWS_VAULT ]]; then
    ICON=''
  fi

  p10k segment -f 208 -i $ICON -t "$(_profile)"
}
