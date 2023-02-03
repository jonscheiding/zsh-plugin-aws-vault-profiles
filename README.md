# zsh-awsvault

oh-my-zsh plugin for [aws-vault](https://github.com/99designs/aws-vault).

Provides a couple of aliases that integrate aws-vault seamlessly with the `AWS_PROFILE` environment variable.

This is most useful when used alongside a profile-switching tool, such as
[awsp](https://github.com/johnnyopao/awsp).

## Installation

### Oh My ZSH

This plugin is intended to be used with [oh-my-zsh](https://ohmyz.sh/). To install it with that framework:

1. Clone the repo to the Oh My ZSH plugins directory:
   ```shell
   $ git clone https://github.com/jonscheiding/zsh-plugin-awsvault $ZSH_CUSTOM/plugins/awsvault
   ```
2. In your `.zshrc`, add `awsvault` to your plugins list:
   ```
   plugins=(git ruby ... awsvault)
   ```

### Vanilla ZSH

This plugin does not depend on any Oh My ZSH functionality, so you can also use it with plain ZSH:

1. Clone the repo somewhere:
   ```shell
   $ git clone https://github.com/jonscheiding/zsh-plugin-awsvault ~/.zsh-plugin-awsvault
   ```
2. In your `.zshrc`, source the plugin file:
   ```
   source ~/.zsh-plugin-awsvault/awsvault.plugin.zsh
   ```

## Features

This plugin provides the following features:

### Alias `awsv`

Executes a command with `aws-vault`, using the profile set in the `$AWS_PROFILE` environment variable (or
default, if none is set).

If no command is provided, executes into an `aws-vault` shell.

So, the following are roughly equivalent:

```shell
$ awsv run-some-command
```

```shell
$ aws-vault exec ${AWS_PROFILE:-default} -- run-some-command
```

As are the following:

```shell
$ awsv
```

```shell
$ aws-vault exec ${AWS_PROFILE:-default}
```

The main difference is that if you are already in an `aws-vault` shell (detected by the existence of an
`$AWS_VAULT` environment variable), it will not nest you into another one; it will just execute the command
directly.

### Alias `awsc`

Generate temporary credentials using the profile set in the `$AWS_PROFILE` environment variable (or default,
if none is set), and stores them under that profile in your `$AWS_SHARED_CREDENTIALS_FILE` (by default,
`~/.aws/credentials`).

This is useful for commands which have a hard-coded expectation that they will find credentials in that file,
vs using the various resolution mechanisms exposed by the AWS SDK. The
[AWS Amplify CLI](https://docs.amplify.aws/cli/) is an example of this.

If `awsc` is provided with a command, it will execute that command directly after storing the temporary
credentials.

So, the following are roughly equivalent:

```shell
$ awsc run-some-command
```

```shell
$ aws-vault exec ${AWS_PROFILE:-default} -- bash -c 'echo $AWS_ACCESS_KEY_ID; echo $AWS_SECRET_ACCESS_KEY; echo $AWS_SESSION_TOKEN'
$ # Place the provided values in ~/.aws/credentials
$ run-some-command
```

This command requires the [crudini](https://github.com/pixelb/crudini) tool.

### Prompt segment

This plugin defines a prompt segment called `awsvault` which you can use with various Oh My ZSH themes such as
[powerlevel10k](https://github.com/romkatv/powerlevel10k). It will show the current value of the
`$AWS_PROFILE` variable, along with an icon indicating whether you are inside an `aws-vault` session.

![prompt segment example](example-prompt.gif)
