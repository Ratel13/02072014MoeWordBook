//
//  ListTableViewController.m
//  MoeWordBook
//
//  Created by lyy on 12-11-1.
//
//

#import "ListTableViewController.h"

#import "cocos2d.h"
#include "ExcelParser.h"
#include "PersonalApiCplu.h"

#import "ExternalListLayer.h"

@implementation ListTableViewController



@synthesize fileListArray = _fileListArray;
@synthesize listName = _listName;
@synthesize selectedArray =_selectedArray;
@synthesize editaItemFont = _editaItemFont;
@synthesize isStopAllAction =_isStopAllAction;
@synthesize menuArray = _menuArray;
@synthesize externalListLayer = _externalListLayer;
@synthesize isItunesShareList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_fileListArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.text = [_fileListArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];//cyanColor];
    
    }
    
    cell.textLabel.text = [_fileListArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];//cyanColor];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isStopAllAction == NO)
    {
        
        if ([[_editaItemFont.label string] isEqualToString:@"Add"])//
        {
            [PersonalApi playSoundEffect:@"selectButtonEffect.mp3"];//按键音效
            [self.selectedArray addObject:indexPath];
            
        }
    }
}





#pragma mark - 单选多选
//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isStopAllAction == NO)
    {
    [PersonalApi playSoundEffect:@"selectButtonEffect.mp3"];//按键音效
    
    
    if ([[_editaItemFont.label string] isEqualToString:@"Add"])//多选删除
    {
        
        [self.selectedArray addObject:indexPath];
        
    }
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleInsert;
    
}

-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	if (editingStyle == UITableViewCellEditingStyleInsert)
	{
		_isStopAllAction = YES;
        
        for (CCMenu * aMenu in _menuArray)
        {
            aMenu.enabled = NO;
        }
        
        _externalListLayer.isEditing = YES;
        _externalListLayer.isItunesShareList=isItunesShareList;
        [_externalListLayer AddList:indexPath.row];
		
	}
    
}

@end






