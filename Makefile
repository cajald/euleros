#
# Makefile -- run make on other dirs
#

DIRS=				\
	euclid/

# huh
.DEFAULT:
.for dir in ${DIRS}
	${MAKE} -C ${DIRS} ${.TARGET}
.endfor

