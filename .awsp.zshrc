if ! type "_awsp" > /dev/null; then
  return
fi

alias awsp="source _awsp"
export AWS_PROFILE=$(cat $HOME/.awsp)
