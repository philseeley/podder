#!/bin/bash
`#' podder: __VERSION__ __DATE__
#
# Author: Phil Seeley <phil_seeley@hotmail.com>

usage () \
{
  echo "Usage:$(basename $0) [options] +c <config file> [[options] +c <config file>] ..."
  echo "  {+|-}C NUM   catch up, only download the first NUM podcasts"
  echo "  {+|-}d DIR   download files into DIR"
  echo "  {+|-}D       create a date directory at the top level"
  echo "  {+|-}f       use the podcast filenames"
  echo "  {+|-}F       store only the filename, not the whole url in the log"
  echo "  {+|-}q       quiet output"
  echo "  {+|-}t       test what would be downloaded"
  echo "  {+|-}v       verbose output"
  echo "  {+|-}l LIMIT limit the download to LIMIT per second"
  echo "  {+|-}p       write podder.m3u playlist files"
  echo "  {+|-}a       write podder.m3u playlist files alphabetically"
  exit 1
}

# Characters that shouldn't be in filenames.
bad_chars=' *?!|\\/"{}<>:;,^()~$&#'\'

# By default we don't generate output from wget.
verbose=-q

# By default we show what we're doing.
out=echo

# By default we download as fast as possible.
limit=

# Used when catching up.
catchup=-1
wget=wget

# By default we write .m3u files
playlist=true
playlist_opts=-1tr

parse_opts () \
{
  while [ "$1" ]
  do
    op=$(expr "$1" : '\([+-]\)')

    if [ "$op" ]
    then
      on=; off=true
      [ "$op" = + ] && { on=true; off=; }

      case "${1#[+-]}" in
      c) process_conf $2; shift
         ;;
      C) catchup=-1; [ "$on" ] && { catchup=$2; shift; }
         ;;
      d) feed_dir=; [ "$on" ] && { feed_dir=$2; shift; }
         ;;
      D) date_dir=; [ "$on" ] && date_dir=$(date +%Y-%m-%d)/
         ;;
      f) use_filenames=$on
         ;;
      F) log_file_only=$on
         ;;
      q) out=echo; [ "$on" ] && out=true
         ;;
      t) test=$on
         ;;
      v) verbose=-q; [ "$on" ] && verbose=-v
         ;;
      l) limit=; [ "$on" ] && { limit=--limit-rate=$2; shift; }
         ;;
      p) playlist=$on
         ;;
      a) playlist_opts=-1tr; [ "$on" ] && playlist_opts=
         ;;
      ?) usage
         ;;
      esac
    else
      usage
    fi

    shift
  done
}

# Function to parse out the podcast info from a feed.
# The output starts with the title of the feed, then for each item
# we output it's title and enclosure url.

parse () \
{
cat <<__EOF | xsltproc - $1
<?xml version="1.0"?>
<stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/XSL/Transform">
  <output method="text"/>
  <template match="/">
    <apply-templates select="rss/channel/title"/><text>&#10;</text>
    <apply-templates select="rss/channel/item"/>
  </template>
  <template match="item">
    <value-of select="title"/><text>&#10;</text>
    <value-of select="enclosure/@url"/><text>&#10;</text>
  </template>
</stylesheet>
__EOF
}

process_conf () \
(
  # Everything should be relative to the config file.
  conf=$1

  [ $conf != - -a ! -f $conf ] && { echo "Config file '$conf' does not exist"; return; }

  cd $(dirname $conf)
  conf=$(basename $conf)

  # Check that we're not already processing this config file.
  lock=$conf.lock

  if [ -s $lock ]
  then
    if [ ! -d /proc/$(cat $lock) ]
    then
      echo "Removing stale lock file '$lock'"
      rm -f $lock
    else
      echo "Config file '$conf' is currently being processed"
      exit 1
    fi
  fi

  echo $$ > $lock

  # We have a log file for each config file.
  log=$conf.log
  touch -- $log

  grep -v '^#' $conf | while read feed opts
  do
    trap "exit 1" SIGINT

    parse $feed | 
    (
      trap "exit 1" SIGINT

      # If no directory is specified in the config we use the title of the feed.

      read feed_title

      feed_title=${feed_title//["$bad_chars"]/_}

      parse_opts $opts

      $out "$feed_title $feed_dir"

      [ "$feed_dir" ] || feed_dir=$feed_title

      # We now read all the title, url pairs.

      while read title
      do
        read url

        title=${title//["$bad_chars"]/_}

        to_log=$url
        [ "$log_file_only" ] && to_log=$(basename $url)

        # We only get stuff we haven't got before.

        if ! grep -q "^$to_log$" -- $log
        then
          $out "  $title"

          if [ ! "$test" ]
          then
            # We need the extension of the url to add to the title.

            ext=$(basename $url)
            ext=$(echo $ext | cut -d\? -f1)
            ext=$(echo $ext | cut -d. -f2)

            mkdir -p "$date_dir$feed_dir"

            output_file=$title.$ext

            [ "$use_filenames" ] && output_file=$(basename $url)

            # Check if we've reached the catchup limit.

            [ $catchup -eq 0 ] && wget=true

            # If we successfully get the podcast we log the fact.

            $wget $verbose $limit -t 3 -T 20 --retry-connrefused -c -O "$date_dir$feed_dir/$output_file" $url && echo $to_log >> $log

            (( --catchup ))

            # Create a play list.
            [ "$playlist" ] && (cd $date_dir$feed_dir; ls $playlist_opts | grep -v '\.m3u$' > podder.m3u)
          fi
        fi
      done
    )
  done

  rm -f $lock
)

# If we get interrupted we just want to exit rather than going on.

trap "exit 1" SIGINT

parse_opts "$@"
