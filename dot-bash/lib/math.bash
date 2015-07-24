
## Not happy with these:
##	* Should read stdin like anything else, not force its own RS
##	* Use raw int or length?  An option, e.g. --length?
##
## unset -f max ;
## function max() {
## 	echo $* | awk -vRS='[[:space:]]' '{ length>bb && bb=length } END { print bb }' 
## }
## 
## unset -f min ; 
## function min() {
## 	echo $* | awk -vRS='[[:space:]]' 'BEGIN { bb=99999 } { length<bb && bb=length } END { print bb }' 
## }

