//
//  SMSSDKUIFriendsResultViewController.m
//  SMSSDKUI
//
//  Created by hower on 2018/3/12.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import "SMSSDKUIFriendsResultViewController.h"
#import "SMSSDKUIInviteViewController.h"
#import "SMSSDKUIHelper.h"
#import "SMSSDKUIContactTableViewCell.h"
#import <SMS_SDK/SMSSDKAddressBook.h>
#import "SMSSDKUIGetCodeViewController.h"
#import <MOBFoundation/MOBFoundation.h>
#import "SMSSDKUIBindUserInfoViewController.h"

#define kSMSSDKUIContactCellIdentifier @"SMSSDKUIContactTableViewCellReuseIdentifier"


@interface SMSSDKUIFriendsResultViewController ()<UITableViewDelegate,UITableViewDataSource, SMSSDKUIContactTableViewCellDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *contactsTmp;//邀请列表分组
@property (nonatomic, strong) NSMutableArray *friendsTmp;//加好友列表分组

@property (nonatomic, strong) NSMutableArray *friendsInfo;//好友列表对应的服务器返回的信息

@end

@implementation SMSSDKUIFriendsResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self configUI];
}

- (void)configUI
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;//不加的话，table会下移
    self.edgesForExtendedLayout = UIRectEdgeNone;//不加的话，UISearchBar返回后会上移
    
    
    self.tableView =
    ({
        UITableView *friendsList = [[UITableView alloc] initWithFrame:CGRectMake(0, -6, self.view.frame.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        friendsList.rowHeight = 60.0;

        friendsList.dataSource = self;
        friendsList.delegate = self;
        friendsList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        friendsList.sectionIndexColor = SMSCommonColor();
        friendsList.sectionIndexBackgroundColor = [UIColor clearColor];
        [self.view addSubview:friendsList];
        
        friendsList ;
    });
    
    //表视图
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SMSSDKUIContactTableViewCell class] forCellReuseIdentifier:kSMSSDKUIContactCellIdentifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (_contactsTmp.count>0)+(_friendsTmp.count>0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_friendsTmp.count)
    {
        return _contactsTmp.count;
    }
    
    if (section)
    {
        return _contactsTmp.count;
    }
    else
    {
        return _friendsTmp.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSSDKUIContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMSSDKUIContactCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.delegate = self;
    
    if (_friendsTmp.count)
    {
        if (indexPath.section)
        {
            cell.actionType = SMSSDKUIContactActionTypeInvite;
            cell.contact = _contactsTmp[indexPath.row];
        }
        else
        {
            cell.actionType = SMSSDKUIContactActionTypeAddFriend;
            
            cell.contact = _friendsTmp[indexPath.row];
            
            cell.userInfo = _friendsInfo[indexPath.row];
        }
    }
    else
    {
        cell.actionType = SMSSDKUIContactActionTypeInvite;
        cell.contact = _contactsTmp[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (!_friendsTmp.count)
    {
        title = SMSLocalized(@"toinvitefriends");
    }
    
    if (section)
    {
        title = SMSLocalized(@"toinvitefriends");
    }
    else
    {
        title = SMSLocalized(@"toaddusers");
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 31)];
    bgView.backgroundColor = SMSRGB(0xEFEFF3);
    
    UILabel *sectionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 31)];
    sectionNameLabel.font= [UIFont fontWithName:@"Helvetica" size:13];
    sectionNameLabel.backgroundColor=[UIColor clearColor];
    sectionNameLabel.text = title;
    [bgView addSubview:sectionNameLabel];
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 31.0f;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    searchController.searchResultsController.view.hidden = NO;
    NSString *searchText = searchController.searchBar.text;
    
    if (!searchText.length)
    {
        _contactsTmp = _contactList.mutableCopy;
    }
    else
    {
        _contactsTmp = [NSMutableArray array];
        for (SMSSDKAddressBook *userInfo in _contactList)
        {
            if ([userInfo.name rangeOfString:searchText].location != NSNotFound)
            {
                [_contactsTmp addObject:userInfo];
            }
        }
    }
    SMSUILog(@"%@",_contactsTmp);
    [self matchContacts];
}


- (void)matchContacts
{
    _friendsTmp = [NSMutableArray array];
    _friendsInfo = [NSMutableArray array];
    
    for (NSDictionary *userInfo in _contactFriends)
    {
        NSString *phone = [[userInfo[@"phone"] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        for (SMSSDKAddressBook *contact in _contactsTmp.copy)
        {
            for (NSString *contactPhone in contact.phonesEx)
            {
                if ([contactPhone isEqualToString:phone])
                {
                    [_contactsTmp removeObject:contact];
                    [_friendsTmp addObject:contact];
                    [_friendsInfo addObject:userInfo];
                    break;
                }
            }
        }
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - SMSSDKUIContactTableViewCellDelegate

- (void)didClickButtonWithInfo:(id)info
{

    if ([info isKindOfClass:NSDictionary.class])
    {
        SMSSDKAlert(@"%@",info);
    }
    
    if ([info isKindOfClass:SMSSDKAddressBook.class])
    {
        //SMSSDKUIInviteViewController *vc = [[SMSSDKUIInviteViewController alloc] initWithContact:info];
        //[self.navigationController pushViewController:vc animated:YES];
        
        if(self.itemSeletectedBlock)
            self.itemSeletectedBlock(info);
    }
}

@end
