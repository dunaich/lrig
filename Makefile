#
# lrig - ASCII erotic posters from command line
#
# (C)2016 Dmitry Duanev <dunaich@mail.ru>
#
# License: GPL2+
#

TARGET = lrig
FILES = $(shell ls -1 *.txt)
FILEZ = $(foreach file, $(FILES), $(file).gz)

all: $(TARGET)

$(TARGET): gzip
	@echo "#!/bin/sh" >> $@
	@echo -n "    case $$" >> $@
	@echo "1 in" >> $@
	@for f in $(FILEZ); do \
		test -z ''$$n && n=0; \
		echo "    $$n) base64 -d << EOF$$n | gzip -d" >> $@; \
		base64 $$f >> $@; \
		echo "EOF$$n" >> $@; \
		echo "    ;;" >> $@; \
		n=$$(( $$n + 1 )); \
	done
	@echo "    *) exit 1" >> $@
	@echo "    ;;" >> $@
	@echo "    esac" >> $@
	@echo "echo" >> $@
	@chmod a+x $@

gzip:
	@for f in $(FILES); do \
		gzip -9 -c $$f > $$f.gz; \
	done

clean:
	@rm -f $(TARGET) *.gz

install: all
	install --mode=755 --target-directory=$(DESTDIR)/sbin $(TARGET)

.PHONY: all clean install $(TARGET)
