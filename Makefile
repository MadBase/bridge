FLAGS = --use solc:0.7.6
	
all    	:; dapp $(FLAGS) build
clean  	:; dapp clean
test   	:; dapp $(FLAGS) test -v
deploy 	:; dapp create Bridge
