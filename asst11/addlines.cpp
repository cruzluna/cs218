// CS 218 - Provided C++ program
//	This programs adds line numbers (base 13)
//	to an input text file.
//	Calls assembly language routines.

//  Must ensure g++ compiler is installed:
//	sudo apt-get install g++

// ***************************************************************************
//  Standard includes

#include <cstdlib>
#include <iostream>
#include <sstream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <iomanip>
#include <map>

using namespace std;

// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the standard C/C++ style
//	calling convention.

extern "C" bool getFileDescriptors(int, char* [], FILE **, FILE **);
extern "C" bool getLine(FILE *, char [], unsigned int, bool *);
extern "C" void addLineNumber(unsigned int, char [], char [],
					unsigned int, unsigned int);
extern "C" bool writeNewLine(FILE *, char [], unsigned int);


// ***************************************************************
//  C++ program (but does not use any objects).

int main(int argc, char* argv[])
{

// --------------------------------------------------------------------
//  Define constants and declare variables
//	By default, C++ integers are doublewords (32-bits).

	static const unsigned int	MAX_LINE_LEN = 250;
	static const unsigned int	BASE13_STR_LEN = 10;

	unsigned int	lineNumber = 0;
	bool			OverLineLimit = false;

	char	currLine[MAX_LINE_LEN];
	char	currNewLine[MAX_LINE_LEN + BASE13_STR_LEN];

	FILE	*inputFile;
	FILE	*outputFile;

// --------------------------------------------------------------------
//  If file opens successful
//	loop to
//		get line
//		add line number
//		write new line

	if (getFileDescriptors(argc, argv, &inputFile, &outputFile)) {

		while (getLine(inputFile, currLine, MAX_LINE_LEN,
										&OverLineLimit)) {

			if (OverLineLimit) {
				cout << "Warning, line " << lineNumber <<
					" truncated." << endl;
			}

			addLineNumber(lineNumber, currLine, currNewLine,
					MAX_LINE_LEN, BASE13_STR_LEN);

			lineNumber++;

			if(!writeNewLine(outputFile, currNewLine,
					MAX_LINE_LEN + BASE13_STR_LEN))
				break;
		}
	}

// --------------------------------------------------------------------
//  Note, file are closed automatically by OS.
//  All done...

	return	EXIT_SUCCESS;
}