.PHONY: build clean

build: Lexer/Lexer.yy.cpp

clean:
	rm -f ./**/*.yy.cpp ./*.yy.cpp

%.yy.cpp: %.l
	flex --c++ -o $@ $<
