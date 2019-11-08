alias awsp="source _awsp"
export AWS_PROFILE=$(cat $HOME/.awsp)

export AWS_SDK_LOAD_CONFIG="1"

alias aws-vault="AWS_PROFILE= aws-vault"

function awsv {
  AWS_PROFILE=${AWS_PROFILE:=default}
  echo -e "\033[1;36mExecuting $1 with aws-vault using $AWS_PROFILE profile.\033[0m"
  aws-vault exec $AWS_PROFILE -- "$@"
}

alias terraform="awsv terraform"
alias packer="awsv packer"
alias aws="awsv aws"

function aws_prompt_info {
  case $PWD/ in
    /Users/jonscheiding/Code/*) {
      if [ -z "$AWS_PROFILE" ]; then return; fi
      echo "%{$FG[208]%}$AWS_PROFILE %{$reset_color%}"
    }
  esac
}

PROMPT="$PROMPT\$(aws_prompt_info)"
