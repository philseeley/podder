.TH podder "1" "Version __VERSION__ __DATE__" podder "User Commands"
.SH NAME

podder \- Command line utility for downloading podcasts

.SH SYNOPSIS

\fBpodder\fR [\fIOPTIONS\fR] +c \fIconfig-file\fR [[\fIOPTIONS\fR] +c \fIconfig-file\fR] ...

.SH DESCRIPTION

\fIconfig-file\fRs are processed in the order specified. Options can be
turned on and off for each config file. Options stay in effect for all following
\fIconfig-file\fRs.
All the podcasts will be downloaded relative to the location of each
\fIconfig-file\fR, one sub-directory is created per feed.
Locking is performed to stop a \fIconfig-file\fR from being processed
multiple times.

The \fB<title>\fRs in the feeds are used to name
the feed directories and the downloaded files unless overridden with the
\fB+d\fR or \fB+f\fR options.
A log file \fIconfig-file\fR.log is created to record downloaded podcasts.

Specifying \fIconfig-file\fR as \fB"-"\fR will read the list of feeds from
standard input. In this case all the feed directories will be created
relative to the current working directory and the log file will be
\fB"-.log"\fR.

.SH CONFIGURATION FILE FORMAT

The \fIconfig-file\fR contains one line per feed of the form:
.RS

\fIurl\fR [\fIOPTIONS\fR]

.RE
All \fIOPTIONS\fR are applied before the feed is processed and only apply
to the \fIurl\fR and not any following ones.

.SH OPTIONS

Options can be turned on (+) and off (-). Note that this differs from normal
option processing, but makes more sense.

All options are valid on the command line and for each feed. Specifying
\fB{+|-}c\fR \fIconfig-file\fR in the per-feed options is also valid, but any
directories will be relative to the including \fIconfig-file\fR.

.TP
\fB{+|-}c\fR \fIconfig-file\fR
process config file \fIconfig-file\fR.

.TP
\fB+C\fR \fINUM\fR|\fB-C\fR
catch up. Only downloads the first \fINUM\fR podcasts.
Useful if it's the first time you're downloading a feed and only want to
start with the most recent episodes. Specify 0 to avoid all downloads.

.TP
\fB+d\fR \fIDIR\fR|\fB-d\fR
use \fIDIR\fR as the directory to store the feed in, rather
then using the feed's \fB<title>\fR.

.TP
\fB{+|-}D\fR
create a date directory at the top level.
A directory of the form \fByyyy-mm-dd\fR is created above the feed directories.

.TP
\fB{+|-}f\fR
use the filenames of the podcasts rather than their \fB<title>\fRs.

.TP
\fB{+|-}F\fR
store just the filenames of the podcasts in the log file, rather than the
complete URL. This is useful for feeds that move hosts.

.TP
\fB{+|-}q\fR
quiet output. Useful in crontabs.

.TP
\fB{+|-}t\fR
test what would be downloaded. No actual downloads are performed and no
log entries are written.

.TP
\fB{+|-}v\fR
verbose output. Enables output from wget.

.TP
\fB+l\fR \fILIMIT\fR|\fB-l\fR
limits the download speed to \fILIMIT\fR bytes per second. \fILIMIT\fR may be
expressed in bytes, kilobytes with the k suffix, or megabytes with the m suffix.

.TP
\fB{+|-}p\fR
write .m3u playlist files. On by default.

.TP
\fB{+|-}a\fR
write .m3u playlist files alphabetically. By default the files are written in modification
time order, which wget attempts to take from the source file.

.TP
\fB{+|-}n\fR
write .m3u playlist files using the directory name as the playlist name. By default the files
are called \fBpodder.m3u\fR.

.SH EXAMPLES

To download all podcasts to a single dated directory:
.RS

podder +D +d . +c config-file

.RE

To download all podcasts in config-0 to a single dated directory and all
podcasts in config-1 as normal:
.RS

podder +D +d . +c config-0 -D -d +c config-1

.RE

The following config-file will just store the podcast's filename in the log
file for http://lugradio.org/episodes.rss:
.RS

http://lugradio.org/episodes.rss +F
.br
http://thelinuxlink.net/tllts/tllts.rss

.RE

To download a random set of feeds each day (random_feed_gen is left as
an exercise for the reader):
.RS

random_feed_gen | podder +D +d . +c -

.RE

.SH AUTHOR

Written by Phil Seeley. Inspired by Linc Fessenden's bashpodder.

.SH "FEATURES"

The complete flexibility in option specifications was more interesting to
write, rather than being strictly necessary.

Report bugs to <phil_seeley@hotmail.com>.

.SH "SEE ALSO"

\fBwget\fR(1), \fBxsltproc\fR(1)

.\" .SH COPYRIGHT
.\" Copyright \(co 2006 Free Software Foundation, Inc.
.\" .br
.\" This is free software.  You may redistribute copies of it under the terms of
.\" the GNU General Public License <http://www.gnu.org/licenses/gpl.html>.
.\" There is NO WARRANTY, to the extent permitted by law.
.\" .SH "SEE ALSO"
.\" wget, xsltproc
