//
//  SMSDemoZonesResultVC.m
//  SMSSDKDemo
//
//  Created by hower on 2020/1/2.
//  Copyright © 2020 youzu. All rights reserved.
//

#import "SMSDemoZonesResultVC.h"
#import "SMSDemoDefines.h"
#import "SMSDemoZonesCell.h"

#define kCountryZoneResultCellIdentifier @"kCountryZoneResultCellIdentifier"

@interface SMSDemoZonesResultVC ()<UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSDictionary *dataSources;
@property (nonatomic, strong) NSArray *indexArr;


@end

@implementation SMSDemoZonesResultVC

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
        UITableView *zonesList = [[UITableView alloc] initWithFrame:CGRectMake(0, -6, self.view.frame.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        
        [self.view addSubview:zonesList];
        zonesList.dataSource = self;
        zonesList.delegate = self;
        zonesList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        zonesList.sectionIndexColor = SMSDemoCommonColor();
        zonesList.sectionIndexBackgroundColor = [UIColor clearColor];
        [self.view addSubview:zonesList];
        
        zonesList ;
    });
    
    //表视图
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SMSDemoZonesCell class] forCellReuseIdentifier:kCountryZoneResultCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *index = _indexArr[section];
    
    return [self.dataSources[index] count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *title = nil;
    title = _indexArr[section];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 31)];
    bgView.backgroundColor = SMSDemoRGB(0xEFEFF3);
    
    UILabel *sectionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 31)];
    sectionNameLabel.font = [UIFont fontWithName:@"Helvetica" size:
                             13];
    sectionNameLabel.backgroundColor=[UIColor clearColor];
    sectionNameLabel.text = title;
    [bgView addSubview:sectionNameLabel];
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    SMSDemoZonesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountryZoneResultCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell)
    {
        cell = [[SMSDemoZonesCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCountryZoneResultCellIdentifier];
    }
    
    NSString *index = _indexArr[indexPath.section];
    
    NSString *zoneInfo = self.dataSources[index][indexPath.row];
    
    NSInteger location = [zoneInfo rangeOfString:@"+"].location;
    
    NSString *countryName = [zoneInfo substringToIndex:location];
    NSString *zone = [zoneInfo substringFromIndex:location];
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

    if(self.itemSeletectedBlock)
    {
        NSString *index = _indexArr[indexPath.section];
        
        NSString *zoneInfo = self.dataSources[index][indexPath.row];
        
        NSInteger location = [zoneInfo rangeOfString:@"+"].location;
        
        NSString *countryName = [zoneInfo substringToIndex:location];
        NSString *zone = [zoneInfo substringFromIndex:location];
        
        if(countryName && zone)
        {
            [[NSUserDefaults standardUserDefaults] setObject:countryName forKey:@"secdemo_country"];
            [[NSUserDefaults standardUserDefaults] setObject:zone forKey:@"secdemo_zone"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        self.itemSeletectedBlock(countryName, zone);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    searchController.searchResultsController.view.hidden = NO;
    {
        NSString *text = searchController.searchBar.text;
        if (text.length)
        {
            [self handleSearchWithText:text];
        }
        else
        {
            _dataSources = _localList;
            _indexArr = [_dataSources.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
        }
    }
    
    [self.tableView reloadData];
    
}

- (void)handleSearchWithText:(NSString *)text
{
    NSMutableDictionary *resultList = [NSMutableDictionary dictionary];
    
    for (NSString *key in self.localList.allKeys)
    {
        if ([self.localList[key] count])
        {
            NSMutableArray *matchArr = [NSMutableArray array];
            for (NSString *zoneInfo in self.localList[key])
            {
                if ([zoneInfo rangeOfString:text].location != NSNotFound)
                {
                    [matchArr addObject:zoneInfo];
                }
            }
            
            if (matchArr.count)
            {
                [resultList setObject:matchArr forKey:key];
            }
        }
    }
    _dataSources = resultList;
    _indexArr = [_dataSources.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
}

@end
