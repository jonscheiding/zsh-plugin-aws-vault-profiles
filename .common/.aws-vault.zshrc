if ! type "aws-vault" > /dev/null; then
  return
fi

export AWS_SDK_LOAD_CONFIG="1"

alias aws-vault="AWS_PROFILE= aws-vault"

function awsv {
  COMMAND=$1
  COMMAND=${COMMAND:-"shell"}

  if [ ! -z "$AWS_VAULT" ]; then
    echo "\033[0;33mAlready using $AWS_VAULT profile.\033[0m" >&2
    "$@"
    return $?
  fi

  AWS_PROFILE_EVALUATED=${AWS_PROFILE:=default}
  echo -e "\033[1;36mExecuting $COMMAND with aws-vault using the $AWS_PROFILE_EVALUATED profile.\033[0m" >&2
  aws-vault exec $AWS_PROFILE_EVALUATED -- "$@"
}

function awsc {
  AWS_PROFILE_EVALUATED=${AWS_VAULT:-${AWS_PROFILE:-default}}

  type crudini > /dev/null || {
    echo "This command requires the crudini tool. Please install it with pip install crudini."
    return 1
  }

  echo -e "\033[1;36mStoring temporary credentials for the $AWS_PROFILE_EVALUATED profile.\033[0m" >&2

  COMMAND_BASE="crudini --set ~/.aws/credentials $AWS_PROFILE_EVALUATED"

  COMMAND="
    $COMMAND_BASE aws_access_key_id \$AWS_ACCESS_KEY_ID && 
    $COMMAND_BASE aws_secret_access_key \$AWS_SECRET_ACCESS_KEY &&
    $COMMAND_BASE aws_session_token \$AWS_SESSION_TOKEN"

  if [ ! -z "$AWS_VAULT" ]; then
    bash -c '$COMMAND'
  else
    aws-vault exec $AWS_PROFILE_EVALUATED -- bash -c $COMMAND
  fi

  if [ ! -z "$1" ]; then
    awsv "$@"
  fi
}

prompt_awsvault() {
  ICON=''

  if [[ -n $AWS_VAULT ]]; then
    ICON=''
  fi

  p10k segment -f 208 -i $ICON -t "${AWS_PROFILE:=default}"
}
