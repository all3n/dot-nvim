BUILDDIR = build
CFLAGS += -std=c11
LDFLAGS +=
SOURCES = $(filter-out test_%.c,$(wildcard *.c))
OBJECTS = $(patsubst %.c,$(BUILDDIR)/%.o,$(SOURCES))
LIBS = 
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
	CFLAGS += -DLINUX
	LDFLAGS +=
else ifeq ($(UNAME_S),Darwin)

CFLAGS += -I /opt/homebrew/include/ -DMACOS
	LDFLAGS += -L /opt/homebrew/lib
else
	$(error Unsupported operating system: $(UNAME_S))
endif


.PHONY: all clean build_dir


all: $(BUILDDIR)/main

build_dir:
	@mkdir -p $(BUILDDIR)

$(BUILDDIR)/main: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

$(BUILDDIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -rf $(BUILDDIR)
	rm -f  $(OBJECTS)
