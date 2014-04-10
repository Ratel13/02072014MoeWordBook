//
//  ExcelParser.cpp
//  MoeWordBook
//
//  Created by lyy on 12-11-2.
//
//

#include "ExcelParser.h"
#include "PersonalApiCplu.h"

vector<vector<string> > ExcelParser::paserExcel(string detailStr)
{
    vector<vector<string> > ivec;

    string pattern1("<Row");
    
    vector<string>ivec1 =  PersonalApiCplu::split(detailStr,pattern1);//取出所有单词套组
    
    for (int j = 1;j<ivec1.size(); j++)
    {
        printf("%d",j);
        if (j == 59)
        {
            ;
        }
        vector<string> tempIvec;
        
        string pattern2("</Data></Cell>");//去尾
        vector<string>ivec2 =  PersonalApiCplu::split(ivec1[j],pattern2);//某个单词组中的所有元素
       
        
        for (int i = 0;i<ivec2.size()-1; i++)//去尾
        {
            string sourceStr = ivec2[i];
            
            string patternStr = "</Font>";
            
            
            if (PersonalApiCplu::isContantString(sourceStr,patternStr))//判断是否可以直接取，或者是要通过字符串合并
            {
                string pattern3("</Font>");//去尾
                vector<string>ivec3 =  PersonalApiCplu::split(ivec2[i],pattern3);
                
                
                string s4;
                string pattern4("xmlns=\"http://www.w3.org/TR/REC-html40\">");//去头
                for (int k = 0; k<ivec3.size()-1; k++)//记得减去数组最后一位，去尾莫名其妙多最后一位。
                {
                    vector<string>ivec4 =  PersonalApiCplu::split(ivec3[k],pattern4);
                    s4 += ivec4[1];
                }
                
                tempIvec.push_back(s4.c_str());
            }
            else
            {
               
                string pattern3("<Data ss:Type=\"String\">");
                vector<string>ivec3 =  PersonalApiCplu::split(ivec2[i],pattern3);
                string s3 =  ivec3[1];
                
                tempIvec.push_back(s3.c_str());
            }
        }
        
        ivec.push_back(tempIvec);
    }

    ExcelParser::traversingVector(ivec);
    
    return ivec;

}

void ExcelParser::traversingVector(vector<vector<string> > ivec)
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
            
            //cout<<str<<endl;
        }
        [[SingleTonTool defaultMemory].wordListArray addObject:aArray];
        //cout<<"/////////////////////"<<endl;
    }
    
}

void ExcelParser::writeExcel(const char * listName)
{
    string  row1Str0 = " <Row>";
    string  row1Str = "   <Row>";
    string  row2Str = "   </Row>";
    string  word1Str = "<Cell><Data ss:Type=\"String\"><Font html:Face=\"宋体\"x:CharSet=\"134\" x:Family=\"Swiss\" html:Color=\"#000000\"xmlns=\"http://www.w3.org/TR/REC-html40\">";
    
    string  word2Str = "</Font></Data></Cell>";
    string  pattern1 = "</Table>";
    string  breakLine = "\n";
    string   rowPattern= "ExpandedRowCount=\"77\"";//行
    
    
    
    NSString * patternStr = [[NSBundle mainBundle] pathForResource:@"excelPattern" ofType:@"xml"];
    patternStr = [NSString stringWithContentsOfFile:patternStr encoding:NSUTF8StringEncoding error:nil];
    const char * patternChar = [patternStr UTF8String];
    
    vector<string>ivec1 =  PersonalApiCplu::split(patternChar,pattern1);//取出所有单词套组
    
    
    //绘制xml表
    string insertStr;
    for (int i = 0; i<[[SingleTonTool defaultMemory].wordListArray count]; i++)
    {
        string rowStr;
        NSArray * wordArray = [[SingleTonTool defaultMemory].wordListArray objectAtIndex:i];
        for (int j = 0; j<[wordArray count]; j++)
        {
            NSString * aString = [wordArray objectAtIndex:j];
            string wordStr = [aString UTF8String];
            rowStr = rowStr+word1Str+wordStr+word2Str+breakLine;//<Cell><Data ss:Type=\String\> WORD </Data></Cell>
        }
        if (i==0)
        {
            insertStr = insertStr+row1Str0+breakLine+rowStr+row2Str+breakLine;
        }
        else
        {
            insertStr = insertStr+row1Str+breakLine+rowStr+row2Str+breakLine;
        }
        
        
        /*
         <Row>
         <Cell><Data ss:Type=\String\> WORD </Data></Cell>
         </Row>
         */
    }
    
    
    string xmlStr = ivec1[0]+ insertStr + pattern1 + ivec1[1];
    
    //把单词的数量和行数
    string rowStr;
    
    //int 转string
    int i= [[SingleTonTool defaultMemory].wordListArray count];
    
    string c;
    
    ostringstream oss;
    oss<<i;
    
    c=oss.str();
    
    string changeString = "ExpandedRowCount=\"77\"";
    PersonalApiCplu::string_replace(changeString,"77",c);//行
    cout<<changeString<<endl;
    
    
    PersonalApiCplu::string_replace(xmlStr,rowPattern,changeString);//行
    
    
    const char * aChar = xmlStr.c_str();
    
    //写xml
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                         objectAtIndex:0];
    
    NSString * listNameStr = [NSString stringWithUTF8String:listName];
    
    listNameStr = [NSString stringWithFormat:@"%@.xml",listNameStr];
    NSString *filePath = [docPath stringByAppendingPathComponent:listNameStr];
    
    string path = [filePath UTF8String];
	
	FILE *fp = fopen(path.c_str(), "w");
    
    
	fputs(aChar, fp);
	fclose(fp);
    
    
    /*NSString * str = [NSString stringWithUTF8String:aChar];
     
     
     //写xml
     NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
     objectAtIndex:0];
     
     NSString *filePath = [docPath stringByAppendingPathComponent:@"mylist1.xml"];
     
     NSData * aData = [str dataUsingEncoding:NSUTF8StringEncoding];//NSString 转NSData
     
     NSError *error = nil;
     
     [aData writeToFile:filePath options:0  error:&error];
     
     if (error)
     {
     NSLog(@"Fail: %@", [error localizedDescription]);
     }*/
}





