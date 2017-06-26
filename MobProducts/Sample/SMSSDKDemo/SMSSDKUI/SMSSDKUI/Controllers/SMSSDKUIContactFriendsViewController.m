//
//  SMSSDKUIContactFriendsViewController.m
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/7.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SMSSDKUIContactFriendsViewController.h"
#import "SMSSDKUIInviteViewController.h"
#import "SMSSDKUIHelper.h"
#import "SMSSDKUIContactTableViewCell.h"
#import <SMS_SDK/SMSSDKAddressBook.h>

@interface SMSSDKUIContactFriendsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SMSSDKUIContactTableViewCellDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *contactsTableView;

@property (nonatomic, strong) NSMutableArray *contactList;// 获取到的所有联系人
@property (nonatomic, strong) NSArray *contactFriends;// 获取到所有的通讯录好友

@property (nonatomic, strong) NSMutableArray *contactsTmp;//邀请列表分组
@property (nonatomic, strong) NSMutableArray *friendsTmp;//加好友列表分组

@property (nonatomic, strong) NSMutableArray *friendsInfo;//好友列表对应的服务器返回的信息

@end

@implementation SMSSDKUIContactFriendsViewController

#define kSMSSDKUIContactCellIdentifier @"SMSSDKUIContactTableViewCellReuseIdentifier"

- (instancetype)initWithContactFriends:(NSArray *)contactFriends
{
    if (self = [super init])
    {
        _contactFriends = contactFriends;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self readContacts];
}

- (void)configUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SMSLocalized(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.searchBar =
    ({
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.frame = CGRectMake(0, 44+StatusBarHeight, self.view.frame.size.width, 44);
        searchBar.delegate = self;
        [self.view addSubview:searchBar];
        searchBar;
    });
    
    self.contactsTableView =
    ({
        //添加table
        UITableView *contactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88 + StatusBarHeight, self.view.frame.size.width, self.view.bounds.size.height - (88 + StatusBarHeight)) style:UITableViewStylePlain];
        
        [contactsTableView registerClass:[SMSSDKUIContactTableViewCell class] forCellReuseIdentifier:kSMSSDKUIContactCellIdentifier];
        contactsTableView.dataSource = self;
        contactsTableView.delegate = self;
        contactsTableView.rowHeight = 60.0;
        [self.view addSubview:contactsTableView];
        contactsTableView;
    });
}

- (void)readContacts
{
    [SMSSDKUIHelper readContacts:^(BOOL authorized, NSMutableArray *contacts) {
        if (!authorized)
        {
            SMSUILog(@"通讯录权限未授权");
            [self alertAuthorization];
        }
        else
        {
            SMSUILog(@"获取到了%zd条通讯录信息",contacts.count);
        }
        
        _contactList = contacts;
        _contactsTmp = _contactList.mutableCopy;
        
        [self matchContacts];
    }];
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
    
    [_contactsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    if (!_friendsTmp.count)
    {
        return SMSLocalized(@"toinvitefriends");
    }
    
    if (section)
    {
        return SMSLocalized(@"toinvitefriends");
    }
    else
    {
        return SMSLocalized(@"hasjoined");
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
        SMSSDKUIInviteViewController *vc = [[SMSSDKUIInviteViewController alloc] initWithContact:info];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }
}

- (void)back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) alertAuthorization
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:SMSLocalized(@"notice") message:SMSLocalized(@"alertContactAuth") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:SMSLocalized(@"sure") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    UIAlertAction *set = [UIAlertAction actionWithTitle:SMSLocalized(@"goset") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alert addAction:set];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
