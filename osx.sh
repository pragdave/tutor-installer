#! /bin/sh

# Install the m13 components in ~/.pragprog/m13, then offer to install
# the m13 command into a directory in $PATH

if [ $EUID -eq 0 ]; then
  echo "Please don't run this script as root!"
  exit 1
fi

if [ ! -d $HOME ]; then
  echo "Can't find your home directory: $HOME"
  exit 1
fi

if [ ! -O $HOME ]; then
  echo "You don't own your home directory: $HOME"
  exit 1
fi

M13=$HOME/.pragprog/m13
if [ -d $M13 ]; then
  echo "You already have m13 installed in $M13"
  echo "You can update it with"
  echo
  if (which m13  >/dev/null); then
    echo "    m13 update"
  else
    echo "    ~/.pragprog/m13/bin/m13 update"
  fi
  echo
  exit 1
fi


cat << EOM1

This script will install the Pragmatic Bookshelf m13 toolset under the directory

    $HOME/.pragprog/m13

It will also offer to install a global alias to the main \`m13\` command, making
it more convenient to run the tools on your projects.

Just because you're right to be nervous, we'll show you each command before
we run it, giving you the chance to veto it.

Here come the first one…

EOM1


maybe_run() {
  CMD=$1
  echo
  echo "can I run: $CMD"
  read -p "[Yn]: " choice </dev/tty
  echo
  case "$choice" in
  y|yes|Y|YES|"" )
        if ($CMD)
        then
          echo
        else
          echo "Command failed. I'm bailing"
          exit 1
        fi
        ;;

  n|no|N|NO )
        echo OK. "I'll stop here"
        exit -1;;

  * )   echo "Please answer Y or N"
        maybe_run "$CMD";;
esac
}


maybe_run "mkdir -p $HOME/.pragprog"

maybe_run "git clone git@git.pragprog.com:pragdave/m13.git $M13"

cat << EOM2
The following command will install a link to the m13 command
into your \$PATH, which makes it more convenient. If you say
"N", you will need to run it using the full path:

    ~/.pragprog/m13/bin/m13 «options»
EOM2


maybe_run "$M13/bin/m13 install-into-path"
