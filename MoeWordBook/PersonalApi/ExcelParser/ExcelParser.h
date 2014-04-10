//
//  ExcelParser.h
//  MoeWordBook
//
//  Created by lyy on 12-11-2.
//
//

#ifndef __MoeWordBook__ExcelParser__
#define __MoeWordBook__ExcelParser__

#include <iostream>
#include<vector>
#include<string>
#include<cstdio>
#include <sstream>


using namespace std;
class ExcelParser
{
public:
	
   static vector<vector<string> > paserExcel(string detailStr);
   static void traversingVector(vector<vector<string> > ivec);
   static void writeExcel(const char * listName);
 
};

#endif /* defined(__MoeWordBook__ExcelParser__) */
