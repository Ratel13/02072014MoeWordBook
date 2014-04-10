//
//  MyListLayerViewController.h
//  MoeWordBook
//
//  Created by lyy on 12-11-4.
//
//

#import <UIKit/UIKit.h>
@class MyListLayer;
@interface MyListLayerViewController : UITableViewController<UITextFieldDelegate>
{
    NSMutableArray * _fileListArray;
    UIView * _maskView;
    UITextField * _listNameField;
    int inPutTimes;
    int selectedIndexPath;
    NSMutableArray * _addWordArray;
    MyListLayer* _myListLayer;
    CCMenuItemFont * _editaItemFont;
    NSMutableArray * _selectedArray;
     
}

@property(nonatomic,retain)NSMutableArray * fileListArray;
@property(nonatomic,retain)UIView * maskView;
@property(nonatomic,retain)UITextField * listNameField;
@property(nonatomic,retain)NSMutableArray * addWordArray;
@property(nonatomic,retain)MyListLayer* myListLayer;
@property(nonatomic,retain)CCMenuItemFont * editaItemFont;
@property(nonatomic,retain)NSMutableArray * selectedArray;

@end
