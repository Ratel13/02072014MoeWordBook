//
//  ListTableViewController.h
//  MoeWordBook
//
//  Created by lyy on 12-11-1.
//
//

#import <UIKit/UIKit.h>

@class ExternalListLayer;
@interface ListTableViewController : UITableViewController
{
    NSMutableArray * _fileListArray;
    NSString * _listName;
    
    
    NSMutableArray * _selectedArray;
    CCMenuItemFont * _editaItemFont;
    
    BOOL _isStopAllAction;
    
 
    NSMutableArray * _menuArray;
    
    ExternalListLayer * _externalListLayer;
    BOOL isItunesShareList;
    
}

@property(nonatomic,retain)NSMutableArray * fileListArray;
@property(nonatomic,retain)NSString * listName;
@property(nonatomic,retain)NSMutableArray * selectedArray;
@property(nonatomic,retain)CCMenuItemFont * editaItemFont;
@property(nonatomic,assign)BOOL isStopAllAction;

@property(nonatomic,retain)NSMutableArray * menuArray;
@property(nonatomic,retain)ExternalListLayer * externalListLayer;
@property(nonatomic,assign)BOOL isItunesShareList;

@end
