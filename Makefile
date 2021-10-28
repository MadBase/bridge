FLAGS = --use solc:0.8.6

all    	:; DAPP_BUILD_OPTIMIZE_RUNS=2000000 DAPP_STANDARD_JSON=dapp.json dapp $(FLAGS) build --legacy
clean  	:; dapp clean
test   	:; DAPP_BUILD_OPTIMIZE_RUNS=2000000 DAPP_STANDARD_JSON=dapp-test.json dapp $(FLAGS) test -v
deploy 	:; dapp create Bridge
