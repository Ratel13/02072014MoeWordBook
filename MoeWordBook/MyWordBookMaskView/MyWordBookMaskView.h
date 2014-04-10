//
//  MyWordBookMaskView.h
//  MoeWordBook
//
//  Created by lyy on 12-11-7.
//
//

#import <UIKit/UIKit.h>

@class MyWordBookLayer1;
@interface MyWordBookMaskView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _allMyListTableView;
    
    NSMutableArray * _fileListArray;
    
    int _nowWordIndex;
    
    MyWordBookLayer1 * _myWordBookLayer1;
    int sameWordReplaceInArrayIndex;
}

@property(nonatomic,retain)UITableView * allMyListTableView;
@property(nonatomic,retain)NSMutableArray * fileListArray;
@property(nonatomic,assign)int nowWordIndex;
@property(nonatomic,retain)MyWordBookLayer1 * myWordBookLayer1;
@end
