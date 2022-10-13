//
//  SMSDemoZonesVC.m
//  SMSSDKDemo
//
//  Created by hower on 2020/1/2.
//  Copyright © 2020 youzu. All rights reserved.
//

#import "SMSDemoZonesVC.h"
#import "SMSDemoDefines.h"
#import "SMSDemoZonesResultVC.h"
#import "SMSDemoZonesCell.h"

#define kCountryZoneCellIdentifier @"CountryZoneCellIdentifier"

@interface SMSDemoZonesVC ()


@property (nonatomic, strong) UITableView *zonesList;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSDictionary *localList;
@property (nonatomic, strong) NSDictionary *dataSources;
@property (nonatomic, strong) NSArray *indexArr;

//搜索控制器
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, copy) SMSDZonesResultHanler result;


//选中信息
@property (nonatomic, strong) NSString *selectedCountry;
@property (nonatomic, strong) NSString *selectedZone;

@end

@implementation SMSDemoZonesVC

- (instancetype)initWithResult:(SMSDZonesResultHanler) result
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
    
    
    self.selectedCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"secdemo_country"];
    self.selectedZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"secdemo_zone"];
    
    _localList = [NSDictionary dictionaryWithContentsOfFile:[SMSDemoUIBundle pathForResource:@"country" ofType:@"plist"]];
    _dataSources = _localList;
    _indexArr = [_dataSources.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    
    
    [self configUI];
}

- (void)configUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedStringFromTableInBundle(@"countrychoose", @"Localizable", SMSDemoUIBundle, nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"back", @"Localizable", SMSDemoUIBundle, nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    __weak typeof(self) weakSelf = self;
    
    self.searchController =
    ({
        SMSDemoZonesResultVC *resultVC = [SMSDemoZonesResultVC new];
        
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
        searchController.searchBar.placeholder = SMSDemoLocalized(@"searchplaceholder");
        
        
        searchController;
    });
    
    
    self.zonesList =
    ({
        UITableView *zonesList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        
        [self.view addSubview:zonesList];
        zonesList.dataSource = self;
        zonesList.delegate = self;
        zonesList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        zonesList.sectionIndexColor = SMSDemoCommonColor();
        zonesList.sectionIndexBackgroundColor = [UIColor clearColor];
        zonesList.tableHeaderView = self.searchController.searchBar;
        zonesList.sectionIndexBackgroundColor = [UIColor clearColor];
        
        zonesList ;
    });
    
    SMSDemoZonesResultVC *resultVC = (SMSDemoZonesResultVC *)self.searchController.searchResultsController;
    
    [resultVC setLocalList:_localList];
    
    [self configBack];
    
}

- (void)configBack
{
    NSString *path = [SMSDemoUIBundle pathForResource:@"back@3x" ofType:@"png"];
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
    if(_selectedCountry)
    {
        return self.indexArr.count + 1;
    }
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
    if(_selectedCountry)
    {
        if(section==0)
        {
            return 1;
        }
        NSString *title = _indexArr[section-1];
        
        return [self.dataSources[title] count];
    }
    
    NSString *title = _indexArr[section];
    
    return [self.dataSources[title] count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *title = nil;
    if(_selectedCountry)
    {
        if(section==0)
        {
            title = SMSDemoLocalized(@"hasselected");
        }
        else
        {
            title = _indexArr[section-1];
        }
    }
    else
    {
        title = _indexArr[section];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 31)];
    bgView.backgroundColor = SMSDemoRGBA(246, 246, 246, 1);
    
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
    
    SMSDemoZonesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountryZoneCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell)
    {
        cell = [[SMSDemoZonesCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCountryZoneCellIdentifier];
    }
    
    NSString *index = 0;
    if(_selectedCountry)
    {
        if(indexPath.section==0)
        {
            cell.nameLabel.text = _selectedCountry;
            cell.zoneCodeLabel.text = _selectedZone;
        }
        else
        {
            NSString *index = _indexArr[indexPath.section-1];
            
            NSString *zoneInfo = self.dataSources[index][indexPath.row];
            
            NSInteger location = [zoneInfo rangeOfString:@"+"].location;
            
            NSString *countryName = [zoneInfo substringToIndex:location];
            NSString *zone = [zoneInfo substringFromIndex:location];
            cell.nameLabel.text = countryName;
            cell.zoneCodeLabel.text = zone;
        }
        
    }
    else
    {
        NSString *index = _indexArr[indexPath.section];
        
        NSString *zoneInfo = self.dataSources[index][indexPath.row];
        
        NSInteger location = [zoneInfo rangeOfString:@"+"].location;
        
        NSString *countryName = [zoneInfo substringToIndex:location];
        NSString *zone = [zoneInfo substringFromIndex:location];
        cell.nameLabel.text = countryName;
        cell.zoneCodeLabel.text = zone;
    }
    
    
    return cell;
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    

    //更改索引的背景颜色
    tableView.sectionIndexBackgroundColor = SMSDemoRGBA(246, 246, 246, 1);
    
    //更改索引的背景颜色:
    tableView.sectionIndexColor = SMSDemoRGBA(57, 57, 57, 1);

    NSMutableArray *array = _indexArr.mutableCopy;
    if(_selectedCountry)
    {
        [array insertObject:@"#" atIndex:0];
    }
    
    [array insertObject:UITableViewIndexSearch atIndex:0];
    
    return array;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSDemoZonesCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if(_selectedCountry && indexPath.section == 0)
    {
        //return;
    }
    else
    {
        

    }

    if(cell.nameLabel.text && cell.zoneCodeLabel.text)
    {
        [[NSUserDefaults standardUserDefaults] setObject:cell.nameLabel.text forKey:@"secdemo_country"];
        [[NSUserDefaults standardUserDefaults] setObject:cell.zoneCodeLabel.text forKey:@"secdemo_zone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
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
