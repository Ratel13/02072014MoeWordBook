//
//  PersonalApiCplu.cpp
//  MoeWordBook
//
//  Created by lyy on 12-11-11.
//
//

#include "PersonalApiCplu.h"
int k = 0;

char * readText(char * filePathChar)
{
    
    char *pchBuf = NULL;
    int  nLen = 0;
    string path = filePathChar;
    FILE *fp = fopen(path.c_str(), "r");
    
    fseek(fp, 0, SEEK_END); //文件指针移到文件尾
    nLen = ftell(fp);  //得到当前指针位置, 即是文件的长度
    rewind(fp);    //文件指针恢复到文件头位置
    
    //动态申请空间, 为保存字符串结尾标志\0, 多申请一个字符的空间
    pchBuf = (char*) malloc(sizeof(char)*nLen+1);
    if(!pchBuf)
    {
        perror("内存不够!\n");
        exit(0);
    }
    
    //读取文件内容//读取的长度和源文件长度有可能有出入，这里自动调整 nLen
    nLen = fread(pchBuf, sizeof(char), nLen, fp);
    
    pchBuf[nLen] = '\0'; //添加字符串结尾标志
    
    //printf("%s\n", pchBuf); //把读取的内容输出到屏幕看看
    
    fclose(fp);  //关闭文件
    free(pchBuf); //释放空间
    
    return pchBuf;
}

//c++字符串分割函数
vector<string>PersonalApiCplu::split(string str,string pattern)
{
    string::size_type pos;
    vector<string> result;
    str+=pattern;//扩展字符串以方便操作
    int size=str.size();
    
    for(int i=0; i<size; i++)
    {
        pos=str.find(pattern,i);
        if(pos<size)
        {
            string s=str.substr(i,pos-i);
            result.push_back(s);
            i=pos+pattern.size()-1;
        }
    }
    return result;
}


bool PersonalApiCplu::isContantString(string sourceStr,string patternStr)
{
    const char *show;
    
    show=strstr(sourceStr.c_str(),patternStr.c_str());//返回指向第一次出现r位置的指针，如果没找到则返回NULL。
    
    bool isContant;
    if (show == NULL)
    {
        isContant = NO;
    }
    else
    {
        isContant = YES;
    }
    
    return isContant;
}





void PersonalApiCplu::traversingVector(vector<vector<string> > ivec)
{
    [SingleTonTool defaultMemory].wordListArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0 ; i<ivec.size();i++)
    {
        
        vector<string> tempIvec = ivec[i];
        
        NSMutableArray *  aArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int j = 0; j<tempIvec.size(); j++)
        {
            string str = tempIvec[j];
            
            const char * a = str.c_str();
            
            NSString * aString = [NSString stringWithUTF8String:a];
            
            [aArray addObject:aString];
            
            cout<<str<<endl;
        }
        [[SingleTonTool defaultMemory].wordListArray addObject:aArray];
        cout<<"/////////////////////"<<endl;
    }
    
}
//安全字符串复制,附加拷贝0结尾
size_t PersonalApiCplu::SafeStringCopy(void* dest,size_t destLen,const char* src)
{
	size_t stringLen = strlen(src);
	size_t size=min(destLen-1,stringLen);
	memcpy(dest,src,size);
	((char*)dest)[size]='\0';
	return size;
}

void PersonalApiCplu::string_replace(string & strBig, const string & strsrc, const string &strdst)
{
    string::size_type pos=0;
    string::size_type srclen=strsrc.size();
    string::size_type dstlen=strdst.size();
    
    while( (pos=strBig.find(strsrc, pos)) != string::npos)
    {
        strBig.replace(pos, srclen, strdst);
        pos += dstlen;
    }
}

bool PersonalApiCplu::isContainChinese(void * text)
{
   // NSString *text = @"i'm a 苹果。...";
    int length = [(NSString *)text length];
    
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [(NSString *)text substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            //NSLog(@"汉字:%s", cString);
            return true;
        }
    }
    return false;
}


void* PersonalApiCplu::getPhonetic(const char * aWordName)
{
    string wordName(aWordName);
    vector<string> phoneticVect;
    
    //get english
    
    string patternHead1 = "<span class=\"phonetic\">";
    
    vector<string> vect1;
    
    vect1 = PersonalApiCplu::split(wordName,patternHead1);
    
    string patternTail1 = "</span>";
    
    vector<string> vect2;
    
    vect2 = PersonalApiCplu::split(vect1[1],patternTail1);
    
    phoneticVect.push_back(vect2[0]);
    
    
    //get american
    
    vector<string> vect3;
    
    vect3 = PersonalApiCplu::split(vect1[2],patternTail1);
    
    phoneticVect.push_back(vect3[0]);
    
    //CCLog("\nen=%s\nAn=%s",vect2[0].c_str(),vect3[0].c_str());
    /*
    string key = wordListVect[nowPlayNum]+"Phonetic";
    string  combineStr = vect2[0]+vect3[0];
    CCUserDefault::sharedUserDefault()->setStringForKey(key.c_str(),combineStr);
    */
    /*
    cout<<vect2[0].c_str()<<endl;
    cout<<"/////////////////"<<endl;
    cout<<vect3[0].c_str()<<endl;
    */
    
    NSMutableArray * aArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSString * englishPhonetic = [NSString stringWithUTF8String:vect2[0].c_str()];
    NSString * americanPhonetic = [NSString stringWithUTF8String:vect3[0].c_str()];
    [aArray addObject:englishPhonetic];
    if (americanPhonetic!=nil)
    {
         [aArray addObject:americanPhonetic];
    }
    else
    {
        [aArray addObject:@" "];
    }
   
    return aArray;
    //return phoneticVect;
}


void* PersonalApiCplu::getChinese(const char * aWordName)
{
    string wordName(aWordName);
    string resultStr = "";
    cout<<wordName.c_str()<<endl;
    
    vector<string> vect1;
    vect1 = PersonalApiCplu::split(wordName,"group_prons");
    string str1 = vect1[1];
    cout<<str1.c_str()<<endl;

    //获取词性
    string patternHead1 = "<strong class=\"fl\">";
    string patternTail1 = "</strong>";
    string str2 = PersonalApiCplu::cutHeadAndTail(str1, patternHead1,patternTail1);
   
    cout<<str2.c_str()<<endl;
    
    //获取解释
    vector<string> vect2;
    vect2 = PersonalApiCplu::split(str1,"<label>");
    for (int i = 1; i<vect2.size(); i++)
    {
        resultStr+=PersonalApiCplu::split(vect2[i],"</label>")[0];
        
        cout<<PersonalApiCplu::split(vect2[i],"</label>")[0].c_str()<<endl;
    }
    
    //获取同义词，近义词等
    /*
    string str3 = vect1[2];
    vector<string> vect3 = PersonalApiCplu::split(str3,"<li>");
    vector<string> vect4 = PersonalApiCplu::split(str3,"<a class = \"explain\" href=\"http://www.iciba.com/alleviating\" onclick=\"clickCountResult(50);\">");
    for (int i = 1; i<vect3.size(); i++)
    {
        resultStr+=PersonalApiCplu::split(vect3[i],"\n")[0];
        resultStr+=PersonalApiCplu::split(vect4[i],"</a>")[0];
        
        cout<<PersonalApiCplu::split(vect3[i],"\n")[0]<<endl;
        cout<<PersonalApiCplu::split(vect4[i],"</a>")[0]<<endl;
        cout<<"//////////"<<endl;
    }
    */
    
    return [[NSString stringWithUTF8String:resultStr.c_str()] retain];
}

void* PersonalApiCplu::getSentence(const char * aWordName)
{
    string wordName(aWordName);
    NSMutableArray * aArray = [[NSMutableArray alloc] initWithCapacity:6];
    
    //string  combineStr;
    vector<vector<string> > sentenceVect;
    string patternHead1 = "<dt>1.";
    string patternTail1 = "<!--词典例句 End-->";
    string str1 = PersonalApiCplu::cutHeadAndTail(wordName, patternHead1,patternTail1);
    
    vector<string> vect1;
    vect1 = PersonalApiCplu::split(str1,"</p>");
 
    for (int i = 0; i<vect1.size()-2; i++)
    {
        //get englishSentence
        vector<string> oneSetSentenceVect;
        string originStr1 = vect1[i];
        
        string str2;
        if (0 == i)
        {
            string patternTail2 = "<span";
            str2 = PersonalApiCplu::split(originStr1,patternTail2)[0];
        }
        else
        {
            string patternHead2 = "<dt>";
            string patternTail2 = "<span";
            str2 = PersonalApiCplu::cutHeadAndTail(originStr1, patternHead2,patternTail2);
        }
        
        string patternHead3 = "<b>";
        string patternTail3 = "</b></span>";
        string str3 = PersonalApiCplu::cutHeadAndTail(originStr1, patternHead3,patternTail3);
        
        string patternHead4 = "</span> ";
        string patternTail4 = "<a class=\"ico_sound\" title=\"机器发音\"";

        k = 1;
        string str4 = PersonalApiCplu::cutHeadAndTail(originStr1, patternHead4,patternTail4);
        if (str4.length() == 0)
        {
            return aArray;
        }
        k = 0;
        string englishSentence = str2+str3+str4;
        if (0 == i)
        {
            englishSentence = "1. "+englishSentence;
        }
        oneSetSentenceVect.push_back(englishSentence);
        // NSLog(@"%@",englishSentence.c_str());
        
        //get chinesSentence
        
        string patternHead5 = "<dd>";
        string patternTail5 = "</dd>";
        string chineseSentence = PersonalApiCplu::cutHeadAndTail(originStr1, patternHead5,patternTail5);
        oneSetSentenceVect.push_back(chineseSentence);
        //CCLog("%s",chineseSentence.c_str());
        //get origin
        
        string patternHead6 = "<p>";
        string origin = PersonalApiCplu::split(originStr1,patternHead6)[1];
        oneSetSentenceVect.push_back(origin);
        //CCLog("%s\n",origin.c_str());
        sentenceVect.push_back(oneSetSentenceVect);
        //combineStr += englishSentence+"\n"+chineseSentence+"\n"+origin+"\n";
        
        
        NSString * originStr = [[NSString stringWithUTF8String:origin.c_str()] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString * englishSentenceStr = [[NSString stringWithUTF8String:englishSentence.c_str()] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString * chineseSentenceStr = [[NSString stringWithUTF8String:chineseSentence.c_str()] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        chineseSentenceStr = [chineseSentenceStr stringByReplacingOccurrencesOfString:@"<span class='text_blue'><b>" withString:@""];
        chineseSentenceStr = [chineseSentenceStr stringByReplacingOccurrencesOfString:@"</b></span>" withString:@""];
        
        
        if (originStr != nil)
        {
            [aArray addObject:originStr];
        }
        if (englishSentenceStr != nil)
        {
            [aArray addObject:englishSentenceStr];
        }
        if (chineseSentenceStr != nil)
        {
            [aArray addObject:chineseSentenceStr];
        }
        
    }
    
    return aArray;
}
string PersonalApiCplu::cutHeadAndTail(string str, string headPattern,string tailPattern)
{
    string cutStr;
    vector<string> vect1;
    vect1 = PersonalApiCplu::split(str,headPattern);
    vector<string> vect2;

    if (vect1.size()>1)
    {
        vect2 = PersonalApiCplu::split(vect1[1],tailPattern);
        
        cutStr = vect2[0];
        
        return cutStr;
    }
 
    return cutStr;
}
