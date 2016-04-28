#! /bin/sh

# Install the tutor components in ~/./tutor, then offer to install
# the tutor command into a directory in $PATH

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

TUTOR=$HOME/.tutor
if [ -d $TUTOR ]; then
  echo "You already have tutor installed in $TUTOR"
  echo "You can update it with"
  echo
  if (which tutor  >/dev/null); then
    echo "    tutor update"
  else
    echo "    $TUTOR/bin/tutor update"
  fi
  echo
  exit 1
fi


cat << EOM1

This script will install the tutor toolset under the directory

    $HOME/.tutor

It will also offer to install a global alias to the main \`tutor\` command, making
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


maybe_run "git clone git@github.com:pragdave/tutor.git $TUTOR"

cat << EOM2
The following command will install a link to the tutor command
into your \$PATH, which makes it more convenient. If you say
"N", you will need to run it using the full path:

    $TUTOR/bin/tutor «options»
EOM2


maybe_run "$TUTOR/bin/tutor install-into-path"
