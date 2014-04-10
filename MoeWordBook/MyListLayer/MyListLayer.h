//
//  MyListLayer.h
//  MoeWordBook
//
//  Created by lyy on 12-11-4.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MyListLayerViewController;

@interface MyListLayer : CCLayer<UITextFieldDelegate>
{
    
    CCSprite * _bgSprite;

    MyListLayerViewController * _myListLayerViewController;

    UITextField * _listNameField;
    UIView * _maskView;
    CCMenuItemFont * _editaItemFont;
    BOOL isEditing;
    
    BOOL inputSameListName;
    
}

@property(nonatomic,retain) CCSprite * bgSprite;

@property(nonatomic,retain)MyListLayerViewController * myListLayerViewController;


@property(nonatomic,retain)UITextField * listNameField;
@property(nonatomic,retain)UIView * maskView;
@property(nonatomic,retain)CCMenuItemFont * editaItemFont;


+(CCScene *) scene;



@end
