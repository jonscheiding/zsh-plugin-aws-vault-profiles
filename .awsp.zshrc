if ! type "_awsp" > /dev/null; then
  return
fi

touch $HOME/.awsp

alias awsp="source _awsp"
export AWS_PROFILE=$(cat $HOME/.awsp)
