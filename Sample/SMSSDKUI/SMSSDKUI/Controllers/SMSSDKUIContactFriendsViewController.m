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
#import "SMSSDKUIGetCodeViewController.h"
#import <MOBFoundation/MOBFoundation.h>
#import "SMSSDKUIBindUserInfoViewController.h"
#import "SMSGlobalManager.h"
#import "SMSSDKUIFriendsResultViewController.h"
#import "SMSSDKUIGetCodeViewController_Private.h"

@interface SMSSDKUIContactFriendsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SMSSDKUIContactTableViewCellDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *contactsTableView;


@property (nonatomic, strong) UIView *headView; //头部视图


@property (nonatomic, strong) NSMutableArray *contactList;// 获取到的所有联系人
@property (nonatomic, strong) NSArray *contactFriends;// 获取到所有的通讯录好友

@property (nonatomic, strong) NSMutableArray *contactsTmp;//邀请列表分组
@property (nonatomic, strong) NSMutableArray *friendsTmp;//加好友列表分组

@property (nonatomic, strong) NSMutableArray *friendsInfo;//好友列表对应的服务器返回的信息

@property (nonatomic, strong) UILabel *nameLabel; //头部名称
@property (nonatomic, strong) UILabel *nameDescLabel; //头部名称
@property (nonatomic, strong) UIImageView *mobileIcon; //手机图片
@property (nonatomic, strong) UIImageView *headIcon; //头部图片
@property (nonatomic, strong) UIButton *bindBtn; //头部按钮

//搜索控制器
@property (nonatomic, strong) UISearchController *searchController;

//模板code
@property (nonatomic, strong) NSString *tempCode;

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


- (instancetype)initWithContactFriends:(NSArray *)contactFriends template:(NSString *)tempCode
{
    if (self = [super init])
    {
        _contactFriends = contactFriends;
        _tempCode = tempCode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self readContacts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;

    SMSSDKUserInfo *userInfo = [[SMSGlobalManager sharedManager] curUserInfo];
    if(self.headView)
    {
        self.nameLabel.text = userInfo.nickname ? userInfo.nickname : SMSLocalized(@"myInfo");
        self.nameDescLabel.text = userInfo.phone;
        NSString *avatar = userInfo.avatar;
        if ([avatar isKindOfClass:NSString.class])
        {
            [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:avatar] result:^(UIImage *image, NSError *error) {
                if (image && !error)
                {
                    weakSelf.headIcon.image = image;
                }
            }];
        }
        
        if(userInfo && userInfo.uid)
        {
            [self.bindBtn setTitle:SMSLocalized(@"rebind") forState:UIControlStateNormal];
            self.mobileIcon.hidden = NO;
            self.nameDescLabel.hidden = NO;
        }
        else
        {
            [self.bindBtn setTitle:SMSLocalized(@"bindinfo") forState:UIControlStateNormal];
            self.mobileIcon.hidden = YES;
            self.nameDescLabel.hidden = YES;
        }
    }
}

- (void)configUI
{

    self.title = SMSLocalized(@"addressbook");
    
    __weak typeof(self) weakSelf = self;
    self.searchController =
    ({
        SMSSDKUIFriendsResultViewController *resultVC = [SMSSDKUIFriendsResultViewController new];
        [resultVC setItemSeletectedBlock:^(id info) {
            
            [weakSelf didClickButtonWithInfo:info];
            [weakSelf.searchController.searchBar resignFirstResponder];
        }];

        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        searchController.searchResultsUpdater = resultVC;
        [searchController.searchBar sizeToFit];
        
        searchController.hidesNavigationBarDuringPresentation = YES;
        searchController.dimsBackgroundDuringPresentation = YES;
        self.definesPresentationContext = YES;
        
        resultVC.searchBar = searchController.searchBar;
        
        searchController;
    });
    
    
    self.headView =
    ({
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80 + 45)];
        
        [bgView addSubview:self.searchController.searchBar];
        
        self.headIcon =
        ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(15, 15 + 45, 56, 56);
            
            imageView.layer.cornerRadius = 56/2.0;
            imageView.clipsToBounds = YES;
            
            NSString *path = [SMSSDKUIBundle pathForResource:@"sms_ui_default_avatar" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            [bgView addSubview:imageView];
            
            imageView;
        });

        
        self.nameLabel =
        ({
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.frame = CGRectMake(83, 24 + 45, 200, 13);
            nameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
            nameLabel.text = SMSLocalized(@"myInfo");
            [bgView addSubview:nameLabel];
            
            nameLabel;
        });

        
        
        
        self.mobileIcon =
        ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(87, 41 + 45, 18, 18);

            NSString *path = [SMSSDKUIBundle pathForResource:@"mobile" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            [bgView addSubview:imageView];
            
            imageView;
        });

        
        self.nameDescLabel =
        ({
            UILabel *nameDescLabel = [[UILabel alloc] init];
            nameDescLabel.frame = CGRectMake(105, 44 + 45, 200, 13);
            nameDescLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
            nameDescLabel.textColor = SMSRGB(0xC7C7C7);
            [bgView addSubview:nameDescLabel];
            
            nameDescLabel;
        });

        
        self.bindBtn =
        ({
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            UIButton *inviteBtn = [UIButton new];
            inviteBtn.frame = CGRectMake(screenWidth - 83 - 15, 25 + 45, 83, 32);
            [inviteBtn addTarget:self action:@selector(inviteInfo:) forControlEvents:UIControlEventTouchUpInside];
            [inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
            [inviteBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
            [inviteBtn setTitleColor:SMSCommonColor() forState:UIControlStateNormal];
            [bgView addSubview:inviteBtn];
            
            inviteBtn;
        });

        
        bgView;
    });
    
    self.contactsTableView =
    ({
        //添加table
        UITableView *contactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height ) style:UITableViewStylePlain];
        
        [contactsTableView registerClass:[SMSSDKUIContactTableViewCell class] forCellReuseIdentifier:kSMSSDKUIContactCellIdentifier];
        contactsTableView.dataSource = self;
        contactsTableView.delegate = self;
        contactsTableView.rowHeight = 60.0;
        contactsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        contactsTableView.tableHeaderView = self.searchController.searchBar;
        contactsTableView.tableHeaderView = self.headView;

        [self.view addSubview:contactsTableView];
        contactsTableView;
    });
    
//    self.contactsTableView.tableHeaderView = self.headView;
}

- (void)inviteInfo:(id)sender
{
    
    SMSSDKUIGetCodeViewController *vc = [[SMSSDKUIGetCodeViewController alloc] initWithMethod:SMSGetCodeMethodSMS codeBusiness:SMSCheckCodeBusinessBindInfo template:_tempCode];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
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
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            SMSSDKUIFriendsResultViewController *resultVC = (SMSSDKUIFriendsResultViewController *)self.searchController.searchResultsController;
            resultVC.contactList = _contactList;
            resultVC.contactFriends = _contactFriends;
            
        });

        
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
                NSString *noSpacePhone = [[[contactPhone stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
                if ([noSpacePhone isEqualToString:phone])
                {
                    [_contactsTmp removeObject:contact];
                    [_friendsTmp addObject:contact];
                    [_friendsInfo addObject:userInfo];
                    break;
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_contactsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

    });
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (!_friendsTmp.count)
//    {
//        return SMSLocalized(@"toinvitefriends");
//    }
//
//    if (section)
//    {
//        return SMSLocalized(@"toinvitefriends");
//    }
//    else
//    {
//        return SMSLocalized(@"hasjoined");
//    }
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    
    if (!_friendsTmp.count)
    {
        title = SMSLocalized(@"toinvitefriends");
    }
    else
    {
        if (section)
        {
            title = SMSLocalized(@"toinvitefriends");
        }
        else
        {
            title = SMSLocalized(@"toaddusers");

        }
    }

    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 31)];
    bgView.backgroundColor = SMSRGB(0xEFEFF3);
    
    UILabel *sectionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 31)];
    sectionNameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    sectionNameLabel.backgroundColor=[UIColor clearColor];
    sectionNameLabel.text = title;
    [bgView addSubview:sectionNameLabel];
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31.0f;
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




#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }
}


- (void)dismiss:(UIButton *)btn
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
