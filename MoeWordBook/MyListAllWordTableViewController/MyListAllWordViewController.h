//
//  MyListAllWordViewController.h
//  MoeWordBook
//
//  Created by lyy on 12-11-6.
//
//

#import <UIKit/UIKit.h>

@interface MyListAllWordViewController : UITableViewController
{
    NSString * _fromListName;
    BOOL _isMovingBlock;
}
@property(nonatomic,retain)NSString * fromListName;
@property(nonatomic,assign)BOOL isMovingBlock;
@end
