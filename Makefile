FLAGS = --use solc:0.7.6
	
all    :; dapp $(FLAGS) build
clean  :; dapp clean
test   :; dapp $(FLAGS) test
deploy :; dapp create Bridge
