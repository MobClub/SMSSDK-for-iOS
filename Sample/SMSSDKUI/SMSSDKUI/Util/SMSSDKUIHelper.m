//
//  SMSSDKUIHelper.m
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/5/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SMSSDKUIHelper.h"
#import <AddressBook/AddressBook.h>
#import <SMS_SDK/SMSSDKAddressBook.h>

@implementation SMSSDKUIHelper

+ (NSString *)currentZone
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *defaultCode = [[self _zoneCodes] objectForKey:[locale objectForKey:NSLocaleCountryCode]];
    
    return [@"+" stringByAppendingString:defaultCode];
}

+ (NSString *)currentCountryName
{
    NSLocale *locale = [NSLocale currentLocale];
    return [locale displayNameForKey:NSLocaleCountryCode value:[locale objectForKey:NSLocaleCountryCode]];
}

+ (NSDictionary *)_zoneCodes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
     @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
     @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
     @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
     @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
     @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
     @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
     @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
     @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
     @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
     @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
     @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
     @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
     @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
     @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
     @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
     @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
     @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
     @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
     @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
     @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
     @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
     @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
     @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
     @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
     @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
     @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
     @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
     @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
     @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
     @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
     @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
     @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
     @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
     @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
     @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
     @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
     @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
     @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
     @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
     @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
     @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
     @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
     @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
     @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
     @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
     @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
     @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
     @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
     @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
     @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
     @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
     @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
     @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
     @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
     @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
     @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
     @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
     @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
     @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
     @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
}

+ (void)readContacts:(void(^)(BOOL authorized,NSMutableArray *contacts))result
{
    
    
    NSMutableArray *addressBookArray = [NSMutableArray array];
    
    ABAddressBookRef addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
        
        if (!granted || error)
        {
            if (error)
            {
                SMSUILog(@"request access error:%@",error);
            }
            
            if (result)
            {
                result(granted,nil);
            }
            
            return;
        }
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
        for (NSInteger i = 0; i < nPeople; i++)
        {
            SMSSDKAddressBook *addressBook = [[SMSSDKAddressBook alloc] init];
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
        
        if (result)
        {
            result(YES,addressBookArray);
        }
    });
}

+ (NSString *)errorTextWithError:(NSError *)error
{
    
    if(error && error.userInfo && error.userInfo[@"description"])
    {
        return error.userInfo[@"description"];
    }
    
    if(error && error.userInfo && error.userInfo[NSLocalizedDescriptionKey])
    {
        return error.userInfo[NSLocalizedDescriptionKey];
    }
    return [NSString stringWithFormat:@"%@",error];
}

@end
