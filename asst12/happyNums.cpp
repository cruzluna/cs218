// CS 218 - Provided C++ program
//	This program finds the count of happy and sad numbers.
//	Calls assembly language routines.

//  Must ensure g++ compiler is installed:
//	sudo apt-get install g++

// ***************************************************************************
//  Standard includes

#include <cstdlib>
#include <iostream>
#include <string>
#include <iomanip>
#include <thread>

using namespace std;

// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the standard C/C++ style
//	calling convention.

extern "C" bool getCommandLineArgs(int, char* [], int *, unsigned long *);
extern "C" void findHappyNumbers();

unsigned long	numberLimit = 0;
unsigned long	happyCount = 0;
unsigned long	sadCount = 0;


// ***************************************************************
//  C++ program (but does not use any objects).

int main(int argc, char* argv[])
{
	const char *bold = "\033[1m";
	const char *unbold = "\033[0m";
	const char *green = "\033[32m";
	const char *red = "\033[31m";
	int threadCount = 0;
	string	bars = "";
	bars.append(60, '-');
	thread		*thdList;

	unsigned long hwthd = thread::hardware_concurrency();

	if (getCommandLineArgs(argc, argv, &threadCount, &numberLimit)) {

		// cute header messages
		cout << bars << endl << bold << green <<
				"CS 218 - Assignment #12" << unbold << endl;
		cout << endl << bold << "Happy/Sad Numbers Program" <<
				unbold << endl;
		cout << endl;
//		cout << "Hardware Cores: " << hwthd << endl;
		cout << "Thread Count: " << threadCount << endl;
		cout << "Numbers Limit: " << numberLimit << endl;
		cout << endl << bold << "   Start Counting..." <<
				unbold << endl;

		// start thread count threads
		thdList = new thread[threadCount];
		for(unsigned int i=0; i<threadCount; i++)
			thdList[i] = thread(findHappyNumbers);

		// wait for threads to finish
		for(unsigned int i=0; i<threadCount; i++)
			thdList[i].join();

		// show results
		cout << endl;
		cout << bold << "Results:" << unbold << endl;
		cout << "--------" << endl;
		cout << "Happy Count: " << happyCount << endl;
		cout << "Sad Count:   " << sadCount << endl;

	}

// --------------------------------------------------------------------
//  All done...

	return	EXIT_SUCCESS;
}
