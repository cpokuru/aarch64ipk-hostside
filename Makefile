# Cross compilation settings
CROSS_COMPILE = aarch64-linux-gnu-
CC = $(CROSS_COMPILE)gcc
STRIP = $(CROSS_COMPILE)strip

# Application settings
APP_NAME = simple-app

# Compilation flags
CFLAGS = -O2 -Wall -Wextra

all: $(APP_NAME)

$(APP_NAME): main.c
	$(CC) $(CFLAGS) -o $@ main.c
	$(STRIP) $@

clean:
	rm -f $(APP_NAME)

.PHONY: all clean
