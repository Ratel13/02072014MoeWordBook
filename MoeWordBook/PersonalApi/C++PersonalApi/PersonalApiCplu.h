//
//  PersonalApiCplu.h
//  MoeWordBook
//
//  Created by lyy on 12-11-11.
//
//

#ifndef __MoeWordBook__PersonalApiCplu__
#define __MoeWordBook__PersonalApiCplu__


#include <iostream>
#include<vector>
#include<string>
#include<cstdio>
#include <sstream>

using namespace std;

class PersonalApiCplu
{
public:
	
    static char * readText(char * filePathChar);
    static vector<string> split(string str,string pattern);//字符串分割
    static bool isContantString(string sourceStr,string patternStr);//判断一个字符串是否包含另外一个
    static void traversingVector(vector<vector<string> > ivec);//打印多维数组
    static size_t SafeStringCopy(void* dest,size_t destLen,const char* src);
    static void string_replace(string & strBig, const string & strsrc, const string &strdst);//字符串替换
    static bool isContainChinese(void * text);
    
    static void* getPhonetic(const char * aWordName);
    static void* getSentence(const char * aWordName);
    static void* getChinese(const char * aWordName);
    
    static string cutHeadAndTail(string str, string headPattern,string tailPattern);
    
};



#endif /* defined(__MoeWordBook__PersonalApiCplu__) */
