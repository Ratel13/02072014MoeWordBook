//
//  MyListAllWordLayer.h
//  MoeWordBook
//
//  Created by lyy on 12-11-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class MyListAllWordViewController;

@interface MyListAllWordLayer : CCLayer
{
    
    CCSprite * _bgSprite;
    NSMutableArray * _fileListArray;
    MyListAllWordViewController * _myListAllWordViewController;

    BOOL isEditing;//tableviewCell
    NSString * _fromListName;
    CCMenuItemFont * _editaItemFont;
    
}

@property(nonatomic,retain) CCSprite * bgSprite;
@property(nonatomic,retain)NSMutableArray * fileListArray;
@property(nonatomic,retain)MyListAllWordViewController * myListAllWordViewController;
@property(nonatomic,retain)NSString * fromListName;
@property(nonatomic,retain)CCMenuItemFont * editaItemFont;
+(CCScene *) scene;
@end
