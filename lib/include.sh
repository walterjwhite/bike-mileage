#!/bin/sh

. _LIBRARY_PATH_/git/include.sh

_PROJECT_PATH=_APPLICATION_DATA_PATH_
_PROJECT=data/_APPLICATION_NAME_

_git_init

# checks if the entry already exists
# NOTE: if we enter the date differently, it'll be entered twice
_exists() {
    if [ "$(grep -c "^$_DATE,$_INDEX,$_BIKE" $_FILE)" -gt "0" ]
    then
        exitWithError "Entry already exists, please double-check: $_DATE,$_INDEX,$_BIKE - $_FILE" 2
    fi
}

_file() {
    _YEAR=$(echo $_DATE | cut -f 1 -d '/')
    _decade

    _FILE=$_PROJECT_PATH/$_DECADE/$_YEAR.csv
}

# @see: /usr/local/sbin/zfs-media-backup
_decade() {
  _end_year=$(echo $_YEAR | head -c 4 | tail -c 1)
  _event_decade_prefix=$(echo -e "$_YEAR" | /usr/local/bin/grep -Po "[0-9]{3}")

  if [ "$_end_year" -eq "0" ]
  then
    _event_decade_start=${_event_decade_prefix}
    _event_decade_start=$(echo "$_event_decade_start-1" | bc)

    _event_decade_end=${_event_decade_prefix}0
  else
    _event_decade_start=$_event_decade_prefix
    _event_decade_end=$_event_decade_prefix

    _event_decade_end=$(echo "$_event_decade_end+1" | bc)
    _event_decade_end="${_event_decade_end}0"
  fi

  _event_decade_start=${_event_decade_start}1

  _DECADE=${_event_decade_start}-${_event_decade_end}
}
