CC = gcc

NAME = julia
SRCS = jltypes.c
OBJS = $(SRCS:%.c=%.o)
DOBJS = $(SRCS:%.c=%.do)
EXENAME = $(NAME)
LLTDIR = lib
LLT = $(LLTDIR)/libllt.a
HFILEDIRS = /usr/local/include
LIBDIRS = /usr/local/lib

FLAGS = -falign-functions -Wall -Wno-strict-aliasing -I$(LLTDIR) -I$(HFILEDIRS) -L$(LIBDIRS) $(CFLAGS)
LIBFILES = $(LLT)
LIBS = $(LIBFILES) -lm -lgc

DEBUGFLAGS = -g -DDEBUG $(FLAGS)
SHIPFLAGS = -O2 -DNDEBUG $(FLAGS)

default: release

%.o: %.c
	$(CC) $(SHIPFLAGS) -c $< -o $@
%.do: %.c
	$(CC) $(DEBUGFLAGS) -c $< -o $@


$(LLT):
	cd $(LLTDIR) && make

debug: $(DOBJS) $(LIBFILES)
	$(CC) $(DEBUGFLAGS) $(DOBJS) -o $(EXENAME) $(LIBS)

release: $(OBJS) $(LIBFILES)
	$(CC) $(SHIPFLAGS) $(OBJS) -o $(EXENAME) $(LIBS)

clean:
	rm -f *.o
	rm -f *.do
	rm -f $(EXENAME)
