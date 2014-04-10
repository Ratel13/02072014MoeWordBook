//
//  MyWordListLayer.h
//  MoeWordBook
//
//  Created by lyy on 12-10-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class ListTableViewController;

@interface ExternalListLayer : CCLayer<UITextFieldDelegate>
{
    
    CCSprite * _bgSprite;
    NSMutableArray * _fileListArray;
    ListTableViewController * _listTableViewController;
    
    CCMenuItemFont * _editaItemFont;
    BOOL isEditing;
    
    NSMutableArray * _menuArray;
    
    BOOL isStopAllAction;
    
    
    
    UITextField * _listNameField;
    UIView * _maskView;
    BOOL inputSameListName;
    
    int _selectIndex;
    
    UIActivityIndicatorView * aActivityIndicatorView;
    
    ListTableViewController * _listTableViewController2;
    
   NSMutableArray * _fileListArray2;
    
    BOOL isItunesShareList;
    
}

@property(nonatomic,retain) CCSprite * bgSprite;
@property(nonatomic,retain)NSMutableArray * fileListArray;
@property(nonatomic,retain)ListTableViewController * listTableViewController;
@property(nonatomic,retain)CCMenuItemFont * editaItemFont;
@property(nonatomic,retain)NSMutableArray * menuArray;

@property(nonatomic,retain)UITextField * listNameField;
@property(nonatomic,retain)UIView * maskView;
@property(nonatomic,assign)BOOL isEditing;
@property(nonatomic,retain)ListTableViewController * listTableViewController2;
@property(nonatomic,retain) NSMutableArray * fileListArray2;
@property(nonatomic,assign)BOOL isItunesShareList;



+(CCScene *) scene;
-(void)setAllActionStart;
-(void)AddList:(NSUInteger)selectIndex;
@end
