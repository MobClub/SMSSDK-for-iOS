//
//  SMSSDKUIZonesViewController.m
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/5/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SMSSDKUIZonesViewController.h"

@interface SMSSDKUIZonesViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *zonesList;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, copy) ResultHanler result;
@property (nonatomic, strong) NSDictionary *localList;
@property (nonatomic, strong) NSDictionary *dataSources;
@property (nonatomic, strong) NSArray *indexArr;

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
    
    self.searchBar =
    ({
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44 + StatusBarHeight, self.view.frame.size.width, 44)];
        searchBar.delegate = self;
        [self.view addSubview:searchBar];
        searchBar ;
    });

    self.zonesList =
    ({
        UITableView *zonesList = [[UITableView alloc] initWithFrame:CGRectMake(0, 88+StatusBarHeight, self.view.frame.size.width, self.view.bounds.size.height-(88+StatusBarHeight)) style:UITableViewStylePlain];
        
        [self.view addSubview:zonesList];
        zonesList.dataSource = self;
        zonesList.delegate = self;
        zonesList ;
    });

}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *index = _indexArr[section];
    
    return [self.dataSources[index] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *index = _indexArr[indexPath.section];
    
    NSString *zoneInfo = self.dataSources[index][indexPath.row];
    
    NSInteger location = [zoneInfo rangeOfString:@"+"].location;
    
    NSString *countryName = [zoneInfo substringToIndex:location];
    NSString *zone = [zoneInfo substringFromIndex:location];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountryZoneCellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCountryZoneCellIdentifier];
    }
    
    cell.textLabel.text = countryName;
    cell.detailTextLabel.text = zone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _indexArr[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = _indexArr.mutableCopy;
    
    [array insertObject:UITableViewIndexSearch atIndex:0];
    
    return array;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_result)
    {
        _result(NO,cell.detailTextLabel.text,cell.textLabel.text);
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

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length)
    {
        [self handleSearchWithText:searchText];
    }
    else
    {
        _dataSources = _localList;
        _indexArr = [_dataSources.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        [_zonesList reloadData];
    }
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
    [_zonesList reloadData];
}
@end
