SRCS = $(wildcard *.bu)
MACHINECONFIGS = $(SRCS:.bu=.yaml)

%.yaml: %.bu
	butane -o $@ -d . $<

all: $(MACHINECONFIGS)

configure-metallb-routing.yaml: configure-metallb-routing.bu configure-metallb-routing.sh

clean:
	rm -f $(MACHINECONFIGS)
