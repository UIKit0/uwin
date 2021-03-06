########################################################################
#                                                                      #
#              This software is part of the uwin package               #
#          Copyright (c) 1996-2011 AT&T Intellectual Property          #
#                      and is licensed under the                       #
#                 Eclipse Public License, Version 1.0                  #
#                    by AT&T Intellectual Property                     #
#                                                                      #
#                A copy of the License is available at                 #
#          http://www.eclipse.org/org/documents/epl-v10.html           #
#         (with md5 checksum b35adb5213ca9657e911e9befb180842)         #
#                                                                      #
#              Information and Software Systems Research               #
#                            AT&T Research                             #
#                           Florham Park NJ                            #
#                                                                      #
#                  David Korn <dgk@research.att.com>                   #
#                 Glenn Fowler <gsf@research.att.com>                  #
#                                                                      #
########################################################################
USAGE=$'
[-?
@(#)$Id: exception (at&t research) 2009-10-15 $
]
'$USAGE_LICENSE$'
[+NAME?exception - provide source information for an exception]
[+DESCRIPTION?\bexception\b attempts to find the line number, the
    module name, and the file name of an exception logged in the
    \b/var/log/uwin\b file given the library name, the program counter, and
    the library stamp reported in the log file. The libraries \bposix\b,
    \bast54\b, \bshell11\b and \bcmd12\b are supported by default. Other
    libraries can be added by running \bnmake --global=map.mk map\b in a
    clean directory with \bMAKEPATH\b set to the top view of the library
    source directory.]
[+?The file \b/usr/lib/map/\b\alibname\a\b/current\b, or
    \b/usr/lib/map/\b\alibname/stamp\a if the \astamp\a operand is
    specified, must exist. A map file is a \btgz\b archive that contains:]
    {
        [+id?The contents of this file is the library stamp generated
            by \bobjstamp\b(1). Used to verify that the map file matches
            the specified \alibname\a.]
        [+map?The \b.map\b file corresponding to the \alibname\a
            \b.dll\b file.]
        [+addr?The file generated by the \b--disasm\b option.]
        [+\amodule\a\b.s\b?The module files generated by the \b--asm\b
            option.]
    }
[+?The \astamp\a operand may be omitted if \b--local\b is specified or
    if there is only a single file in \b/usr/lib/map/\b\alibname\a.]
[+?If \alibname\a is the full path of a dll then that dll is used, and
    if \astamp\a is the path to a map directory or map file then that map
    file is used.]
[a:asm?The \b.s\b file \alibname\a, generated by the \bcc\b(1) \b-S\b
    option, is converted in-place to a line number lookup file. Used by
    \bmap.mk\b to generate \amodule\a\b.s\b line lookup members of the map
    file.]
[d:disasm?The \b.dll\b file \alibname\a is used to generate address
    lookup data on the standard output. Used by \bmap.mk\b to generate the
    \baddr\b address lookup member of the map file.]
[l:local?When run from the libposix source directory, the map file in
    the \bposix.so\b directory and the source will be used to locate the
    exception.]

libname [ pc [ stamp ] ]

[+EXIT STATUS?]
    {
        [+0?Success.]
        [+>0?An error occurred.]
    }
[+SEE ALSO?\bobjstamp\b(1)]
'

function usage
{
	OPTIND=0
	getopts -a $command "$USAGE" OPT '-?'
	exit 2
}

function err_exit
{
	print -u2 -- "$command: $@"
	exit 1
}

function err_warn
{
	print -u2 -- "$command: warning: $@"
}

function asm2line # module.s
{
	typeset f=$1 a b c x

	[[ -r $f ]] || err_exit "$f: cannot read"
	{
		while	read -r a b c
		do	[[ $b == PROC ]] && break
		done
		while	:
		do	case $a in
			'')	case $b in
				D[BD])	;;
				*)	print I $b ;;
				esac
				;;
			';')	case $b in
				Line)	print L $c ;;
				esac
				;;
			?*)	case $b in
				PROC)	print P $a ;;
				esac
			esac
			IFS= read -r x || break
			set -- $x
			if	[[ $x == [[:space:]]* ]]
			then	a='' b=$1 c=$2
			else	a=$1 b=$2 c=$3
			fi
		done
	} < $f > ${f%.s}.t
	mv -f ${f%.s}.t $f
}

function disasm2addr # dll
{
	typeset f=$1

	[[ -r $f ]] || err_exit "$f: cannot read"
	dumpbin -disasm $(winpath $f) |
	cut -c3-10,31-40 |
	sed -e '/^[[:xdigit:]]\{8\} /!d' -e 's/^  //' -e 's/  *$//'
}

function getfunction lib addr module start fun 
{
	typeset -l addr=$2
	nameref module=$3
	nameref start=$4
	nameref fun=$5
	typeset -u start
	typeset -L2 prefix=$addr
	integer	x=0x$addr loc closest=0x10000 
	while read -r 
	do	set -- $REPLY
		[[ $1 != *:* ]] && continue
		[[ $3 != ${prefix}* ]] && continue
		((loc=0x$3))
		(( loc > x)) && continue
		if(( (x-loc) < closest ))
		then	((closest= x-loc))
			module=${@: -1:1}
			start=$3
			fun=$2
		fi
	done < $1
}

function getline # line addrfile start stop asmfile function
{
	nameref line=$1
	typeset -u start=$3
	typeset -u stop=$4
	typeset a d t s
	exec 3<$5 3<# "P "$6
	read -u3 -r
	exec 4< $2 4<# "$start "*
	read -u4 -r a d
	line=$unknown
	while	read -u3 -r t s
	do	case $t in
		L)	line=$s
			;;
		I)	if	[[ $s == npad ]]
			then	read -u3 -r t s
				if	[[ $t == L ]]
				then	line=$s	
					read -u3 -r t s
				fi
				read -u4 -r a d
				read -u4 -r a d
			fi
			if	[[ $s != $d ]]
			then	err_warn "line number match failed: last line $line (asm=$s dll=$d)"
				line=$unknown
				break
			fi
			while	read -u4 -r a d
			do	if	[[ $a == $stop ]]
				then	if	read -u3 -r t s && [[ $t == L ]]
					then	line=$s
					fi
					break 2
				fi
				[[ $d != nop ]] && break
			done
			[[ $d ]] || break
			;;
		esac
	done
	exec 3<&- 4<&-
}

# main program starts here

command=${0##*/}
op=exception local= module= fname= dllstamp= start= line= unknown=UNKNOWN
while	getopts "$USAGE" var
do      case $var in
	a)	op=asm ;;
	d)	op=disasm ;;
        l)      local=1;;
	*)	usage ;;
        esac
done
shift $((OPTIND-1))
case $op in
asm)	(( $# == 1 )) || usage
	asm2line "$1"
	exit
	;;
disasm)	(( $# == 1 )) || usage
	disasm2addr "$1"
	exit
	;;
esac
(( $# >= 2 && $# <= 3 )) || usage
tmpdir=$(mktemp -dt) || err_exit "$tmpdir: cannot create temporary directory"
trap 'cd ~-;rm -rf $tmpdir' EXIT
lib=$1
typeset -u pc=$2
stamp=$3
if	[[ $local ]]
then	[[ -r posix.so/posix.map ]] || err_exit "posix.so/posix.map: not found" 
fi
cd "$tmpdir" || err_exit "$tmpdir: cannot cd to temporary directory" 

if	[[ $lib == */* ]]
then	dllfile=''
	for suf in .dll ''
	do	if	[[ -r $lib$suf ]]
		then	dllfile=$lib$suf
			break
		fi
	done
	[[ -r $dllfile ]] || err_exit "$lib: not found"
	lib=${lib##*/}
	lib=${lib%.dll}
elif	[[ -r /sys/$lib.dll ]]
then	dllfile=/sys/$lib.dll
elif	[[ -r /bin/$lib.dll ]]
then	dllfile=/bin/$lib.dll
else	err_exit "$lib.dll: not found"
fi
# find the map file
if	[[ $local ]]
then	cp $OLDPWD/posix.so/posix.map map
	exact=''
	tgz=''
else	if	[[ $stamp == */* ]]
	then	tgz=''
		for suf in /$lib/current /current ''
		do	if	[[ -r $stamp$suf ]]
			then	tgz=$stamp$suf
				break
			fi
		done
		[[ $tgz ]] || err_exit "$stamp: map file not found"
		stamp=current
		exact=''
	else	if	[[ $stamp ]]
		then	exact=$stamp
		else	stamp=current
			exact=''
		fi
		dir=/usr/lib/map/$lib
		tgz=$dir/$stamp
		if	[[ ! -f $tgz ]]
		then	[[ $stamp == current ]] && err_exit "$tgz: not found"
			tgz=$dir/current
			if	[[ ! -f $tgz ]]
			then	err_exit "$tgz: not found"
			fi
		fi
	fi
	pax --nosummary -rf $tgz id map addr
	[[ $tgz == */current ]] && stamp=$(<id)
	[[ $exact && $stamp != $exact ]] && err_exit "$tgz stamp $stamp does not match requested $exact"
fi

if	[[ $stamp ]]
then	dllstamp=$(objstamp "$dllfile")
	if	[[ $dllstamp != $stamp ]]
	then	if	[[ $exact ]]
		then	err=err_exit
		else	err=err_warn
		fi
		if	[[ $tgz ]]
		then	$err "$dllfile stamp $dllstamp does not match $tgz $stamp"
		else	$err "$dllfile stamp $dllstamp does not match requested $stamp"
		fi
	fi
fi

getfunction map $pc module start fname
[[ ! $module ]] && err_exit "cannot find file name with pc=$pc"
module=${module/*:@(*).o/\1}.s
if	[[ $local ]]
then	MAKEPATH=$OLDPWD nmake -g debug.mk $module || err_exit "$module: build failed"
	asm2line "$module"
else	pax --nosummary -rf $tgz "$module"
fi
[[ -f addr ]] || disasm2addr "$dllfile" > addr || exit
getline line addr $start $pc "$module" "$fname" 
msg="exception"
[[ $line == $unknown ]] || msg="$msg at line $line"
[[ $fname == $unknown ]] || msg="$msg in function ${fname#_}"
msg="$msg in file ${module%.s}.c"
print "$msg"
