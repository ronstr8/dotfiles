; TinyFugue no-idle script.
;
; Runs a command every 5 to 15 minutes.  (The time is random.)
;
;; This script is copyrighted July 12, 1999 by Christian J.  Robinson
;; <heptite@gmail.com>.  It is protected and distributed under the
;; terms of the GNU General Public License, version 2 or later.
;
; Set the variable 'Idler_Exclude_Worlds' with a | between each world name to
; exclude worlds from the idle trigger /send command.  Eg:
; /set Idler_Exclude_Worlds=foo|bar|baz
;
; -----------------------------------------------------------------------------
; RCS:
; $Id: idler.tf,v 1.6 2009/06/23 14:08:38 infynity Exp $
; $Log: idler.tf,v $
; Revision 1.6  2009/06/23 14:08:38  infynity
; Update email address
;
; Revision 1.5  2003/05/27 13:30:37  infynity
; Tweaks for TF5.0 alpha 10.
;
; Revision 1.4  2002/06/01 08:05:21  infynity
; Copyright notice added.
;
; Revision 1.3  2002/01/20 22:53:59  infynity
; Idler_Exclude_Worlds feature added.
; Don't set idlerpid if it's already set.
;
; Revision 1.2  2000/09/10 21:48:33  infynity
; Removed extra junk that I'd commented out.
;
; Revision 1.1  1999/07/12 08:25:55  infynity
; Initial revision
;

/loaded __OWNLILB__/idler.tf

/require lisp.tf

/eval /set idlerpid $[idlerpid ? : -1]

/def -i idler = \
	/if ({idlerpid} == -1) \
		/_idler %; \
		/echo %% No-Idle loop started. %; \
	/else \
		/echo %% No-Idle loop already running. %; \
	/endif

/def -i _idler = \
	/let _worlds= %;\
	/let i=1 %;\
	/let _sockets=$(/listsockets -s) %;\
	/let _line=$(/nth %{i} %{_sockets}) %;\
	/while (_line !~ "") \
		/if /eval /test '%_line' !/ '{%Idler_Exclude_Worlds}' %;\
		/then \
			/let _worlds=%_worlds %_line %;\
		/endif %; \
		/test ++i %; \
		/let _line=$(/nth %{i} %{_sockets}) %;\
	/done %;\
	/for i 1 $(/length %{_worlds}) \
;   	/send -w\$(/nth \%{i} \%{_worlds}) \\\\ %;\
		/send -w\$(/nth \%{i} \%{_worlds}) ;ctime() %;\
	/repeat -0:$[rand(5,15)]:$[rand(60)] 1 /_idler %;\
	/set idlerpid %?

;/def -i _idler = \
;	/send -W \\ %;\
;	/repeat -0:$[rand(5,15)]:$[rand(60)] 1 /_idler %;\
;	/set idlerpid %?

/def -i killidler = \
	/if ({idlerpid} != -1) \
		/kill %idlerpid %; \
		/set idlerpid -1 %; \
		/echo %% No-Idle loop killed. %; \
	/else \
		/echo %% No-Idle loop not running. %; \
	/endif

/def -i ki = /killidler

;; @see http://christianrobinson.name/tf/idler.tf


