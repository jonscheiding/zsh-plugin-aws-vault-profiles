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
  echo -e "\033[1;36mExecuting $COMMAND with aws-vault using $AWS_PROFILE profile.\033[0m" >&2
  aws-vault exec $AWS_PROFILE_EVALUATED -- "$@"
}

# alias terraform="awsv terraform"
# alias packer="awsv packer"
# alias aws="awsv aws"

prompt_awsvault() {
  ICON=''

  if [[ -n $AWS_VAULT ]]; then
    ICON=''
  fi

  p10k segment -f 208 -i $ICON -t "${AWS_PROFILE:=default}"
}
