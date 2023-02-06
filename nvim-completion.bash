# All variables and functions must named with prefix "_nvim_comp"

# These options come from `man nvim`
_nvim_comp_opts=(
	-

	# Finds tag in the tags file, the associated file becomes the current file and the associated command is executed.
	# Cursor is positioned at the tag location in the file.  :help tag-commands
	-t # -t tag

	# QuickFix mode. Display the first error in errorfile. If errorfile is omitted,
	# the value of the 'errorfile' option is used (defaults to errors.err).
	# Further errors can be jumped to with the :cnext command. :help quickfix
	-q # -q [errorfile]

	# End of options.  Remaining arguments are treated as literal file names,
	# including filenames starting with hyphen (‘-’).
	--

	# Ex mode, reading stdin as Ex commands.  :help Ex-mode
	-e

	# Ex mode, reading stdin as text.  :help Ex-mode
	-E

	# Silent (non-interactive) Ex mode, reading stdin as Ex commands.
	# Useful for scripting because it does NOT start a UI, unlike -e.  :help silent-mode
	-es

	# Silent (non-interactive) Ex mode, reading stdin as text.
	# Useful for scripting because it does NOT start a UI, unlike -E.  :help silent-mode
	-Es

	# Diff mode.  Show the difference between two to eight files, similar to sdiff(1).  :help diff
	-d

	# Read-only mode.  Sets the 'readonly' option.  Implies -n.
	# Buffers can still be edited, but cannot be written to disk if already associated with a file.
	# To overwrite a file, add an exclamation mark to the relevant Ex command, such as :w!.
	# :help 'readonly'
	-R

	# Resets the 'write' option, to disable file modifications.
	# Writing to a file is disabled, but buffers can still be modified.
	-m

	# Resets the 'write' and 'modifiable' options, to disable file and buffer modifications.
	-M

	# Binary mode.  :help edit-binary
	-b

	# Lisp mode.  Sets the 'lisp' and 'showmatch' options.
	-l

	# Arabic mode.  Sets the 'arabic' option.
	-A

	# Hebrew mode.  Sets the 'hkmap' and 'rightleft' options.
	-H

	# Verbose mode. Prints debug messages.  N is the 'verbose' level, defaults to 10. If file is specified,
	# append messages to file instead of printing them.  :help 'verbose'
	-V # -V[N][file]

	# Debug mode for VimL (Vim script).  Started when executing the first command from a script.
	# :help debug-mode
	-D

	# Disable the use of swap files. Sets the 'updatecount' option to 0.
	# Can be useful for editing files on a slow medium.
	-n

	# -r [file]   Recovery mode.  If file is omitted then list swap files with recovery information.  Otherwise the swap
	#             file file is used to recover a crashed session.  The swap file has the same name as the file it's
	#             associated with, but with ‘.swp’ appended.  :help recovery
	-r

	# -L [file]   Alias for -r.
	-L

	#
	# -u vimrc    Use vimrc instead of the default ~/.config/nvim/init.vim.  If vimrc is NORC, do not load any
	#             initialization files (except plugins).  If vimrc is NONE, loading plugins is also skipped.  :help
	#             initialization
	-u

	# -i shada    Use shada instead of the default ~/.local/state/nvim/shada/main.shada.  If shada is NONE, do not read or
	#             write a ShaDa file.  :help shada
	-i

	# Skip loading plugins.  Implied by -u NONE.
	--noplugin

	# Start Nvim with "factory defaults" (no user config and plugins, no shada).  :help --clean
	--clean

	# -o[N]       Open N windows stacked horizontally.  If N is omitted, open one window for each file.  If N is less than
	#             the number of file arguments, allocate windows for the first N files and hide the rest.
	-o

	# -O[N]       Like -o, but tile windows vertically.
	-O

	# -p[N]       Like -o, but for tab pages.
	-p

	# +[linenum]  For the first file, position the cursor on line linenum.  If linenum is omitted, position the cursor on
	#             the last line of the file.  +5 and -c 5 on the command-line are equivalent to :5 inside nvim.
	+

	# +/[pattern]
	#             For the first file, position the cursor on the first occurrence of pattern.  If pattern is omitted, the
	#             most recent search pattern is used (if any).  +/foo and -c /foo on the command-line are equivalent to
	#             /foo and :/foo inside nvim.  :help search-pattern
	+/

	# +command, -c command
	#             Execute command after reading the first file.  Up to 10 instances allowed.  "+foo" and -c "foo" are
	#             equivalent.
	-c

	# Like -c, but execute command before processing any vimrc.  Up to 10 instances of these can be used
	# independently from instances of -c.
	--cmd # --cmd command

	# Source session after the first file argument has been read. Equivalent to -c "source session".
	# session cannot start with a hyphen (‘-’). If session is omitted then Session.vim is used, if found.
	# :help session-file
	-S # -S [session]

	# Read normal mode commands from scriptin.  The same can be done with the command :source! scriptin.
	# If the end of the file is reached before nvim exits, further characters are read from the keyboard.
	-s # -s scriptin

	# Append all typed characters to scriptout. Can be used for creating a script to be used with -s or :source!.
	-w # -w scriptout

	# Like -w, but truncate scriptout.
	-W # -W scriptout

	# During startup, append timing messages to file.  Can be used to diagnose slow startup times.
	--startuptime # --startuptime file

	# Dump API metadata serialized to msgpack and exit.
	--api-info

	# Use standard input and standard output as a msgpack-rpc channel.  :help --embed
	--embed

	# Do not start a UI.  When supplied with --embed this implies that the embedding application does not
	# intend to (immediately) start a UI.  Also useful for "scraping" messages in a pipe.  :help --headless
	--headless

	# Start RPC server on this pipe or TCP socket.
	--listen # --listen address

	# Print usage information and exit.
	-h --help

	# Print version information and exit.
	-v --version
)

_nvim_comp_reply_files() {
	local IFS=$'\n'
	compopt -o nospace -o filenames
	# shellcheck disable=2207
	COMPREPLY=( $(compgen -A file -- "$cur") )
}

_nvim_comp_reply_opts() {
	local IFS=$'\n'
	# shellcheck disable=2207
	COMPREPLY=( $(compgen -W "${_nvim_comp_opts[*]}" -- "$cur") )
}

_nvim_completions() {
	COMPREPLY=()
	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [[ $COMP_LINE == *' -- '* ]]; then
		# When current command line contains the "--" option, other options are forbidden.
		_nvim_comp_reply_files
	elif [[ $cur =~ ^[-+] ]]; then
		_nvim_comp_reply_opts
	elif [[ $prev =~ ^- ]]; then
		case "${prev}" in
			-)
				# No completions.
				;;

			-t)
				# No completions. User must input argument.
				;;

			-c|--cmd)
				# No completions. User must input argument.
				;;

			*)
				_nvim_comp_reply_files
				;;
		esac
	elif [[ $prev =~ ^+ ]]; then
		case "${prev}" in
			+|+/)
				;;

			*)
				_nvim_comp_reply_files
				;;
		esac
	else
		_nvim_comp_reply_files
	fi
}

complete -F _nvim_completions -o bashdefault nvim
