# add to (+), delete from (-), print (.), or set ([=]) window title
# arguments are eval'd before printing
# title text string exported in TITLE_TEXT

function title # [+ | - | =] title ...
{
	typeset	x t="$TITLE_TEXT"

	case $1 in
	+)	shift
		case $# in
		0)	;;
		*)	for x
			do	case " $t " in
				*" $x "*)	;;
				"  ")		t=$x ;;
				*)		t="$t $x" ;;
				esac
			done
			case $t in
			$TITLE_TEXT)	return 1 ;;
			esac
			;;
		esac
		;;
	-)	shift
		case $# in
		0)	;;
		*)	for x
			do	case " $t " in
				*" $x "*)	t="${t%?( )$x*}${t##*$x?( )}" ;;
				esac
			done
			case $t in
			$TITLE_TEXT)	return 1 ;;
			esac
			;;
		esac
		;;
	.)	print -r -- "$TITLE_TEXT"
		return 0
		;;
	*)	t="$*"
		;;
	esac
	export TITLE_TEXT="$t"
	eval x=\"$t\"
	case $TERM in
	630*)	print -nr -- "[?${#x};0v$x" ;;
	uwin*|*vt100*|xterm*)	print -nr -- "]0;$x" ;;
	*)	return 1 ;;
	esac
	return 0
}
