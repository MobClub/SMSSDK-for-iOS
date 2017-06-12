

#import "SectionsViewControllerFriends.h"
#import "CustomCell.h"
#import "InvitationViewControllerEx.h"
#import "VerifyViewController.h"
#import "YJLocalCountryData.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+ContactFriends.h>
#import <AddressBook/AddressBook.h>
#import <SMS_SDK/SMSSDKAddressBook.h>

@interface SectionsViewControllerFriends ()
{
    NSMutableArray* _addressBookData;
    NSMutableArray* _friendsData;
    NSMutableArray* _friendsData2;
    
    NSMutableArray* _other;
    
    NSBundle *_bundle;
}

@end

@implementation SectionsViewControllerFriends
@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;

#pragma mark -
#pragma mark Custom Methods
- (void)resetSearch
{
    NSMutableDictionary *allNamesCopy = [YJLocalCountryData mutableDeepCopy:self.allNames];
    self.names = allNamesCopy;
    NSMutableArray *keyArray = [NSMutableArray arrayWithCapacity:0];

    [keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys] 
                                   sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [NSMutableArray arrayWithCapacity:0];
    [self resetSearch];
    
    for (NSString *key in self.keys)
    {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:0];
        for (NSString *name in array)
        {
            if ([name rangeOfString:searchTerm 
                            options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
}

-(void)clickLeftButton
{
    if (self.onCloseResultHandler) {
        
        self.onCloseResultHandler ();
        
    }

    if (_friendsBlock) {
        _friendsBlock(1,0);
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _friendsData = [NSMutableArray array];
        
        _friendsData2 = [NSMutableArray array];
    }
    return self;
}

-(void)setMyData:(NSMutableArray*) array
{
    _friendsData = [NSMutableArray arrayWithArray:array];
}

-(void)setMyBlock:(SMSShowNewFriendsCountBlock)block
{
    _friendsBlock = block;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SMSSDKUI" ofType:@"bundle"];
    NSBundle *bundle = [[NSBundle alloc] initWithPath:filePath];
    _bundle = bundle;
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0 + statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"back", @"Localizable", bundle, nil)
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(clickLeftButton)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    //添加搜索框
    search=[[UISearchBar alloc] init];
    search.frame = CGRectMake(0, 44+statusBarHeight, self.view.frame.size.width, 44);
    [self.view addSubview:search];
    
    //添加table
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 88 + statusBarHeight, self.view.frame.size.width, self.view.bounds.size.height - (88 + statusBarHeight)) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    
    search.delegate = self;
    _other = [NSMutableArray array];
    _addressBookData = [self addressBook_ex];
    
    NSLog(@"获取到了%zi条通讯录信息",_addressBookData.count);
    
    NSLog(@"获取到了%zi条好友信息",_friendsData.count);
    
    
    //双层循环 取出重复的通讯录信息
    for (int i = 0; i<_friendsData.count; i++) {
        NSDictionary* dict1 = [_friendsData objectAtIndex:i];
        NSString* phone1 = [dict1 objectForKey:@"phone"];
        NSString* name1 = [dict1 objectForKey:@"nickname"];
        for (int j = 0; j < _addressBookData.count; j++) {
            SMSSDKAddressBook* person1 = [_addressBookData objectAtIndex:j];
            for (int k = 0; k < person1.phonesEx.count; k++) {
                if ([phone1 isEqualToString:[person1.phonesEx objectAtIndex:k]])
                {
                    if (person1.name)
                    {
                        NSString* str1 = [NSString stringWithFormat:@"%@+%@",name1,person1.name];
                        NSString* str2 = [str1 stringByAppendingString:@"@"];
                
                        [_friendsData2 addObject:str2];
                    }
                    else
                    {
                        //[_friendsData2 addObject:@""];
                    }
                    
                    [_addressBookData removeObjectAtIndex:j];
                }

            }
        }
    }
    NSLog(@"_friends1:%zi",_friendsData.count);
    NSLog(@"_friends2:%zi",_friendsData2.count);
    
    for (int i = 0; i < _addressBookData.count; i++) {
        SMSSDKAddressBook* person1 = [_addressBookData objectAtIndex:i];
        NSString* str1 = [NSString stringWithFormat:@"%@+%@",person1.name,person1.phones];
        NSString* str2 = [str1 stringByAppendingString:@"#"];
//        NSLog(@"%@",str2);
        [_other addObject:str2];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (_friendsData2.count > 0) {
        [dict setObject:_friendsData2 forKey:NSLocalizedStringFromTableInBundle(@"hasjoined", @"Localizable", bundle, nil)];
    }
    if (_other.count > 0) {
         [dict setObject:_other forKey:NSLocalizedStringFromTableInBundle(@"toinvitefriends", @"Localizable", bundle, nil)];
    }
    
    self.allNames = dict;
    
    [self resetSearch];
    [table reloadData];
}

#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keys count];
    
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return 0;
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}

- (void)CustomCellBtnClick:(CustomCell *)cell
{
    [self.view endEditing:YES];
    NSLog(@"cell的按钮被点击了-第%i组,第%i行", cell.section,cell.index);
    
    UIButton* btn = cell.btn;
    NSLog(@"%@",btn.titleLabel.text);
    NSString* newStr = btn.titleLabel.text;
    
    if ([newStr isEqualToString:NSLocalizedStringFromTableInBundle(@"addfriends", @"Localizable", _bundle, nil)])
    {
        NSLog(@"添加好友");
        NSLog(@"添加好友回调 用户自行处理");
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"addfriendstitle", @"Localizable", _bundle, nil) message:NSLocalizedStringFromTableInBundle(@"addfriendsmsg", @"Localizable", _bundle, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"sure", @"Localizable", _bundle, nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if ([newStr isEqualToString:NSLocalizedStringFromTableInBundle(@"invitefriends", @"Localizable", _bundle, nil)])
    {
        NSLog(@"邀请好友");
        InvitationViewControllerEx* invit = [[InvitationViewControllerEx alloc] init];
        [invit setData:cell.name];
        [invit setPhone:cell.nameDesc AndPhone2:@""];
        [self presentViewController:invit animated:YES completion:^{
            ;
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    
    static NSString *CellWithIdentifier = @"CustomCellIdentifier";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell = [[CustomCell alloc] init];
        cell.delegate = self;
    }

    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    NSString* newStr1 = [str1 substringFromIndex:(str1.length-1)];
    
    NSRange range = [str1 rangeOfString:@"+"];
    NSString* str2 = [str1 substringFromIndex:range.location];
    NSString* phone = [str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *cccc = [phone substringToIndex:[phone length] - 1];
    NSString* name = [str1 substringToIndex:range.location];
    
    if ([newStr1 isEqualToString:@"@"])
    {
        UIButton* btn = cell.btn;
        [btn setTitle:NSLocalizedStringFromTableInBundle(@"addfriends", @"Localizable", _bundle, nil) forState:UIControlStateNormal];
        cell.nameDesc = [NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTableInBundle(@"phonecontacts", @"Localizable", _bundle, nil),cccc];
    }
    
    if ([newStr1 isEqualToString:@"#"])
    {
        UIButton* btn = cell.btn;
        [btn setTitle:NSLocalizedStringFromTableInBundle(@"invitefriends", @"Localizable", _bundle, nil) forState:UIControlStateNormal];
        
        cell.nameDesc = [NSString stringWithFormat:@"%@",cccc];
        cell.nameDescLabel.hidden = YES;
    }
    
    cell.name = name;
    cell.index = (int)indexPath.row;
    cell.section = (int)[indexPath section];
    
//    int myindex = (int)(cell.index)%14;
//    NSString* imagePath = [NSString stringWithFormat:@"SMSUISDK.bundle/%i.png",myindex+1];
    NSString *imageName = [NSString stringWithFormat:@"SMSSDKUI.bundle/sms_ui_default_avatar.png"];
    cell.image = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return nil;

    NSString *key = [keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    
    return key;
}

#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    search.text = @"";
    isSearching = NO;
    [tableView reloadData];
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView 
sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index
{
    NSString *key = [keys objectAtIndex:index];
    if (key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    NSRange range=[str1 rangeOfString:@"+"];
    
    NSString* str2 = [str1 substringFromIndex:range.location];
    NSString* areaCode = [str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* countryName = [str1 substringToIndex:range.location];
    NSLog(@"%@ %@",countryName,areaCode);
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [table reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar 
    textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0)
    {
        [self resetSearch];
        [table reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    search.text = @"";

    [self resetSearch];
    [table reloadData];
    
    [searchBar resignFirstResponder];
}

- (NSMutableArray *)addressBook_ex
{
    NSMutableArray *addressBookArray = [NSMutableArray array];
    
    ABAddressBookRef addressBooks = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else
    {
        addressBooks = ABAddressBookCreate();
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    for (NSInteger i = 0; i < nPeople; i++)
    {
        SMSSDKAddressBook* addressBook = [[SMSSDKAddressBook alloc] init];
        addressBook.phonesEx = [NSMutableArray array];
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil)
        {
            nameString = (__bridge NSString *)abFullName;
        }
        else
        {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        addressBook.name = nameString;
        addressBook.recordid = [NSString stringWithFormat:@"%i",(int)ABRecordGetRecordID(person)];
        addressBook.prefixname = (__bridge NSString *)ABRecordCopyValue(person, kABPersonPrefixProperty);
        addressBook.suffixname = (__bridge NSString *)ABRecordCopyValue(person, kABPersonSuffixProperty);
        addressBook.lastname = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        addressBook.firstname = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        addressBook.middlename = (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        addressBook.nickname = (__bridge NSString *)ABRecordCopyValue(person, kABPersonNicknameProperty);
        addressBook.displayname = (__bridge NSString *)ABRecordCopyValue(person, kABPersonNicknameProperty);
        addressBook.company = (__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        
        addressBook.position = (__bridge NSString *)ABRecordCopyValue(person, kABPersonJobTitleProperty);
        addressBook.specialdata = (__bridge NSString *)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        addressBook.group = (__bridge NSString *)ABRecordCopyValue(person, kABPersonKindProperty);
        addressBook.remarks = @"hello";
        addressBook.others = @"over";
        
        ABPropertyID multiProperties[] =
        {
            kABPersonPhoneProperty,
            kABPersonEmailProperty,
            kABPersonAddressProperty,
            kABPersonInstantMessageProperty,
            kABPersonURLProperty,
            kABPersonRelatedNamesProperty
        };
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        
        for (NSInteger j = 0; j < multiPropertiesTotal; j++)
        {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            if (valuesCount == 0)
            {
                CFRelease(valuesRef);
                continue;
            }
            
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++)
            {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j)
                {
                    case 0:
                    {
                        NSString* str1 = (__bridge NSString*)value;
                        NSString* str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSString* str3 = [str2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        [addressBook.phonesEx addObject:str3];
                        if (0 == k)
                        {
                            NSString* str1 = (__bridge NSString*)value;
                            NSString* str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
                            addressBook.phones = [str2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        }
                        else if(1 == k) {
                            NSString* str1 = (__bridge NSString*)value;
                            NSString* str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
                            addressBook.phone2 = [str2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        }
                        break;
                    }
                    case 1:
                    {
                        addressBook.mails = (__bridge NSString*)value;
                        break;
                    }
                    case 2:
                    {
                        addressBook.addresses = @"";
                        break;
                    }
                    case 3:
                    {
                        addressBook.ims = (__bridge NSString*)value;
                        break;
                    }
                    case 4:
                    {
                        addressBook.websites = (__bridge NSString*)value;
                        break;
                    }
                    case 5:
                    {
                        addressBook.relations = (__bridge NSString*)value;
                        break;
                    }
                        
                    default:
                        break;
                }
                
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [addressBookArray addObject:addressBook];
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    if (allPeople)
    {
        CFRelease(allPeople);
    }
    
    return addressBookArray;
}


@end
