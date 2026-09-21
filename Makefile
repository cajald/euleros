#
# Makefile -- run make on other dirs
#

DIRS=				\
	euclid/

# so using this is less awkward
all:
.for dir in ${DIRS}
	${MAKE} -C ${DIRS} all
.endfor

for dir

# huh
.DEFAULT:
.for dir in ${DIRS}
	${MAKE} -C ${DIRS} ${.TARGET}
.endfor

