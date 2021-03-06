/***********************************************************************
*                                                                      *
*              This software is part of the uwin package               *
*          Copyright (c) 1985-2011 AT&T Intellectual Property          *
*                      and is licensed under the                       *
*                 Eclipse Public License, Version 1.0                  *
*                    by AT&T Intellectual Property                     *
*                                                                      *
*                A copy of the License is available at                 *
*          http://www.eclipse.org/org/documents/epl-v10.html           *
*         (with md5 checksum b35adb5213ca9657e911e9befb180842)         *
*                                                                      *
*              Information and Software Systems Research               *
*                            AT&T Research                             *
*                           Florham Park NJ                            *
*                                                                      *
*                 Glenn Fowler <gsf@research.att.com>                  *
*                  David Korn <dgk@research.att.com>                   *
*                   Phong Vo <kpv@research.att.com>                    *
*                                                                      *
***********************************************************************/
#include	"sfstdio.h"

/*	Read a set of data
**	Written by Kiem-Phong Vo
*/

#if __STD_C
size_t fread(Void_t* buf, size_t esize, size_t nelts, reg FILE* f)
#else
size_t fread(buf,esize,nelts,f)
reg Void_t*	buf;
reg size_t	esize;
reg size_t	nelts;
reg FILE*	f;
#endif
{
	reg Sfio_t*	sf;
	reg ssize_t	rv;

	if(!buf || !(sf = _sfstream(f)))
		return 0;

	if((rv = sfread(sf,buf,esize*nelts)) >= 0)
		return (esize == 0 ? 0 : rv/esize);
	else
	{	_stdseterr(f,sf);
		return 0;
	}
}

#if _lib_fread_unlocked && !_done_fread_unlocked && !defined(fread)
#define _done_fread_unlocked	1
#define fread	fread_unlocked
#include	"fread.c"
#undef fread
#endif
