//
//  SMSSDKAvatarSelectViewController.m
//  SMSSDKUI
//
//  Created by hower on 2018/3/8.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import "SMSSDKAvatarSelectViewController.h"
#import "SMSSDKUIAvatarFLowLayout.h"
#import "SMSSDKUISelectAvatarCell.h"
#import <MOBFoundation/MOBFoundation.h>

#define KSMSUISelectAvatarTag @"KSMSUISelectAvatarTag"


@interface SMSSDKAvatarSelectViewController () <UICollectionViewDataSource,UICollectionViewDelegate, SMSSDKUIAvatarFLowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellsArray;
@property (nonatomic, assign) NSInteger row;


@end

@implementation SMSSDKAvatarSelectViewController

- (NSMutableArray *)cellsArray
{
    if (!_cellsArray)
    {
        _cellsArray = [NSMutableArray array];
    }
    return _cellsArray;
}

- (void)loadData
{
    self.cellsArray = [NSMutableArray array];
    
    [self.cellsArray addObject:@"http://download.sdk.mob.com/e72/83d/e247e8b45bd557f70ac6dcc0cb.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/7b6/264/2c4a9fef9ffa03e5deb5973ab9.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/bbd/480/d993f23339944e4de27e4b0a12.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/3a6/b11/ba6a81f2c13fb0ba3b96d99619.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/a0b/7d0/0520d3554a69ad50a3b87d1760.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/510/deb/0c0731ac543eb71311c482a2e2.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/7d7/e2b/91d898dfde6fb787ab3d926f9d.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/29f/06f/e6a941cd02e3f29465cd438d16.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/167/bc4/38197ca7950aec7020d516fbb2.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/f57/a5e/72ecd0c6ca96361c7f3bcd7144.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/e31/c6e/315fdfa6abc4b17d8c139605de.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/cc3/00e/dedc8bf1514d6c6a5e456fba74.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/f22/154/e27eaf3fc3e24047bd5d4ec3a8.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/d33/6f9/c15ee2d2f01aba51d33985e6c5.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/cc6/115/2628761069dd35867eda68fe2a.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/047/a51/38cfad789e9808443d11f2f9be.png"];
    
    [_collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self configUI];
    [self loadData];

}

- (void)configBack
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:SMSLocalized(@"cancel") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configRight
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button setTitleColor:SMSCommonColor() forState:UIControlStateNormal];
    [button setTitle:SMSLocalized(@"finished") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(finishedClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configUI
{
    self.title = SMSLocalized(@"avatarchoose");
    self.row = -1;
    
    //[self configRight];
    
    SMSSDKUIAvatarFLowLayout *layout = [[SMSSDKUIAvatarFLowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    layout.delegate = self;
    
    [_collectionView registerClass:[SMSSDKUISelectAvatarCell class] forCellWithReuseIdentifier:KSMSUISelectAvatarTag];
}


- (void)finishedClicked:(UIButton*)button
{
    NSString *path = [self.cellsArray objectAtIndex:self.row];
    
    if (self.itemSeletectedBlock && path)
    {
        self.itemSeletectedBlock(path);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    _collectionView.mj_footer.hidden = self.shops.count == 0;
    return self.cellsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMSSDKUISelectAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KSMSUISelectAvatarTag forIndexPath:indexPath];
    

    
    NSString *path = [self.cellsArray objectAtIndex:indexPath.row];    
    [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:path] result:^(UIImage *image, NSError *error) {
        if (image && !error)
        {
            cell.avatarImageView.image = image;
        }
        
//        if(self.row == indexPath.row)
//        {
//            cell.checkedView.hidden = NO;
//        }
//        else
//        {
//            cell.checkedView.hidden = YES;
//        }

    }];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *path = [self.cellsArray objectAtIndex:indexPath.row];
    
    if (self.itemSeletectedBlock && path)
    {
        self.itemSeletectedBlock(path);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
