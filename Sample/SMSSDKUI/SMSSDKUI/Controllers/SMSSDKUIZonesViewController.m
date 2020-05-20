//
//  SMSSDKUIZonesViewController.m
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/5/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SMSSDKUIZonesViewController.h"
#import "SMSSDKUIZonesCell.h"
#import "SMSSDKUIZonesResultViewController.h"

@interface SMSSDKUIZonesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *zonesList;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, copy) ResultHanler result;
@property (nonatomic, strong) NSDictionary *localList;
@property (nonatomic, strong) NSDictionary *dataSources;
@property (nonatomic, strong) NSArray *indexArr;

//搜索控制器
@property (nonatomic, strong) UISearchController *searchController;

@end

#define kCountryZoneCellIdentifier @"CountryZoneCellIdentifier"

@implementation SMSSDKUIZonesViewController

- (instancetype)initWithResult:(ResultHanler)result
{
    if (self = [super init])
    {
        _result = result;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _localList = [NSDictionary dictionaryWithContentsOfFile:[SMSSDKUIBundle pathForResource:@"country" ofType:@"plist"]];
    _dataSources = _localList;
    _indexArr = [_dataSources.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    

    [self configUI];
}

- (void)configUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedStringFromTableInBundle(@"countrychoose", @"Localizable", SMSSDKUIBundle, nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"back", @"Localizable", SMSSDKUIBundle, nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    __weak typeof(self) weakSelf = self;

    self.searchController =
    ({
        SMSSDKUIZonesResultViewController *resultVC = [SMSSDKUIZonesResultViewController new];
        
        [resultVC setItemSeletectedBlock:^(NSString *countryName, NSString *zone) {
            
            
            if (weakSelf.result)
            {
                weakSelf.result(NO,zone,countryName);
            }
            
            weakSelf.searchController = nil;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    

    self.zonesList =
    ({
        UITableView *zonesList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        
        [self.view addSubview:zonesList];
        zonesList.dataSource = self;
        zonesList.delegate = self;
        zonesList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        zonesList.sectionIndexColor = SMSCommonColor();
        zonesList.sectionIndexBackgroundColor = [UIColor clearColor];
        zonesList.tableHeaderView = self.searchController.searchBar;
        zonesList.sectionIndexBackgroundColor = [UIColor clearColor];
        
        zonesList ;
    });

    SMSSDKUIZonesResultViewController *resultVC = (SMSSDKUIZonesResultViewController *)self.searchController.searchResultsController;

    [resultVC setLocalList:_localList];
    
    [self configBack];

}

- (void)configBack
{
    NSString *path = [SMSSDKUIBundle pathForResource:@"back" ofType:@"png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 50);
    [backButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateHighlighted];
    // 让按钮内部的所有内容左对齐
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0); // 这里微调返回键的位置可以让它看上去和左边紧贴
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *title = _indexArr[section];
    
    return [self.dataSources[title] count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *title = _indexArr[section];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 31)];
    bgView.backgroundColor = SMSRGB(0xEFEFF3);
    
    UILabel *sectionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 31)];
    sectionNameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    sectionNameLabel.backgroundColor=[UIColor clearColor];
    sectionNameLabel.text = title;
    [bgView addSubview:sectionNameLabel];
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *index = _indexArr[indexPath.section];
    
    NSString *zoneInfo = self.dataSources[index][indexPath.row];
    
    NSInteger location = [zoneInfo rangeOfString:@"+"].location;
    
    NSString *countryName = [zoneInfo substringToIndex:location];
    NSString *zone = [zoneInfo substringFromIndex:location];
    
    SMSSDKUIZonesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountryZoneCellIdentifier];
    
    if (!cell)
    {
        cell = [[SMSSDKUIZonesCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCountryZoneCellIdentifier];
    }
    
    cell.nameLabel.text = countryName;
    cell.zoneCodeLabel.text = zone;
    
    return cell;
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = _indexArr.mutableCopy;
    
    [array insertObject:UITableViewIndexSearch atIndex:0];
    
    return array;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSSDKUIZonesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_result)
    {
        _result(NO,cell.zoneCodeLabel.text,cell.nameLabel.text);
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_searchBar.isFirstResponder)
    {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - clickEvent

- (void)cancel:(id)sender
{
    if (_result)
    {
        _result(YES,nil,nil);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
