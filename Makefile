CC         =cc
CFLAGS     =-std=c99 -W -Wall -O3
CFLAGS_DBG =-std=c99 -W -Wall -g -O0
LIBS       =-lm -lpthread

WAPITI_SRC ?=$(HOME)/wapiti/src

DESTDIR =
PREFIX  =/usr/local

INSTALL      =install -p
INSTALL_EXEC =$(INSTALL) -m 0755
INSTALL_DATA =$(INSTALL) -m 0644

SRC=$(WAPITI_SRC)/*.c src/api.c
HDR=$(WAPITI_SRC)/*.h src/api.h
OBJ=*.o

libwapiti: $(SRC) $(HDR)
	@echo "CC: api.c --> libwapiti.so"
	@$(CC) -fPIC -c $(CFLAGS) -I $(WAPITI_SRC) $(LIBS) $(SRC)
	@$(CC) -shared -Wl,--wrap,fatal,--wrap,pfatal,--wrap,warning,--wrap,info,-soname,libwapiti.so -o libwapiti.so $(OBJ) -lc
	@rm -f $(OBJ)

install: libwapiti
	@echo "CP: libwapiti.so   --> $(DESTDIR)$(PREFIX)/lib"
	@$(INSTALL_DATA) libwapiti.so $(DESTDIR)$(PREFIX)/lib
	@ldconfig

libwapiti_debug: $(SRC) $(HDR)
	@echo "CC: api.c --> libwapiti.so (dbg)"
	@$(CC) -fPIC -c $(CFLAGS_DBG) -I $(WAPITI_SRC) $(LIBS) $(SRC)
	@$(CC) -shared -Wl,--wrap,fatal,--wrap,pfatal,--wrap,warning,--wrap,info,-soname,libwapiti.so -o libwapiti.so $(OBJ) -lc
	@rm -f $(OBJ)

install_debug: libwapiti_debug
	@echo "CP: libwapiti.so (dbg)  --> $(DESTDIR)$(PREFIX)/lib"
	@$(INSTALL_DATA) libwapiti.so $(DESTDIR)$(PREFIX)/lib
	@ldconfig

uninstall: 
	@echo "RM: $(DESTDIR)$(PREFIX)/lib/libwapiti.so"
	@rm -f $(DESTDIR)$(PREFIX)/lib/libwapiti.so
	@ldconfig

clean:
	@echo "RM: libwapiti"
	@rm -f $(OBJ)
	@rm -f libwapiti.so

.PHONY: clean install uninstall libwapiti libwapiti_debug
