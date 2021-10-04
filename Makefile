FLAGS = --use solc:0.8.6

all    	:; DAPP_STANDARD_JSON=dapp.json dapp $(FLAGS) build --legacy
clean  	:; dapp clean
test   	:; DAPP_STANDARD_JSON=dapp-test.json dapp $(FLAGS) test -v
deploy 	:; dapp create Bridge
