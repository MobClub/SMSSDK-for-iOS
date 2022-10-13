# SMSSDK-For-iOS

### [SMSSDK](http://sms.mob.com/) is the most popular social SDK for apps and mobile games ! We've already supported over 1000 country or zone in global world  until now.[中文官网](http://sms.mob.com/)

**Current SMSSDK version**

- iOS v3.2.8

**中文集成文档**

- [iOS](http://wiki.mob.com/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90-11/)

- - - - -

## Usage
SMSSDK is the most popular social SDK for apps and mobile games ! We've already supported over 1000 country or zone in global world  until now. And also it’s easily to use in your app.now, I will tell you the steps liking this:

If you use cocoaPods ,now ,it's easily to import SMSSDK liking this:

##cocoapods import：

> * main module(necessary)

> * pod "mob_smssdk"

Yeah, you are right,it's over using cocoaPods to import SMSSDK. The next is to import the file's header and use the API of the SMSSDK what you wanted.

## Now,tell you the steps of importing SMSSDK manually.

## Step1: Download the SDK from here :[Download SMSSDK_iOS](http://www.mob.com/#/downloadDetail/SMS/ios)

When you download the SDK, you will get something liking this:
![](http://upload-images.jianshu.io/upload_images/4131265-e6a95e82b977bd69.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

It’s contain the three parties:

> * SMSSDK. Including static libraries and local files.When used directly to this folder into the project.
> * SMSSDKDemo. Showing the SDK foundation.
> * SMSSDKUI. If you want to use it, drag SMSSDKUI.xcodeproj to your project directly.

## Step2：Import the SDK

Drag  this folder into the project:
![](http://upload-images.jianshu.io/upload_images/4131265-d1c81101c46f7707.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## Step3: Add libraries 

Required:

> *  libz.dylib
> * libc++.dylib (libstdc++.dylib这个库在XCode10之后以libc++替代)

Show you like this：
![](http://upload-images.jianshu.io/upload_images/4131265-6644e7b04dfd6235.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## Step4: config ur appKey and appSerect in the project's infoplist

![image](http://upload-images.jianshu.io/upload_images/4131265-a57b525679f8810d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## Step5: Using API 

##1. Access to privacy agreement

According to the requirements of national laws and regulations (for details, please refer to the printed and distributed by the network security administration of the Ministry of industry and information technology of the people's Republic of China  <font color="Red"> notice of [identification method for illegal collection and use of personal information by app] (http://www.miit.gov.cn/n1146285/n1146352/n3054355/n3057724/n3057729/c7591259 / content. HTML) </font>). When developers use SDK products provided by mobtech, they need to show the privacy service agreement of mobtech to end users and obtain the authorization of users.
</br>
</br> mobtech provides the corresponding interface of privacy service for developers to use. </br>
Note: all developers are required to access the mobtech privacy service process according to this document, otherwise, the relevant services provided by each SDK of mobtech may not be used. </br></font>

### 1.1 Description</br>

The privacy process of mobtech mainly includes the functions of "privacy agreement authorization" and "privacy agreement secondary confirmation", involving the following interfaces:</br>
<font color="Red"> it is suggested that developers should attach mobtech's privacy protocol in a prominent position (e.g. in the application's own service agreement pop-up box), users
Click to view the agreement.) </br></font>

**</br> (1) show the mobtech privacy protocol to the end user and return the user authorization result</br>
</br> (2) privacy secondary confirmation box switch setting</br>
</br> (3) user defined privacy secondary confirmation box UI</br>
</br> (4) query the content of mobtech privacy agreement </br>**

###</br> 1.2 access process</br>

####</br> 1. Import the latest version of sms_sdk.framework, mobfoundation.framework and mob privacy protocol related interfaces in mobsdk + privacy. H, including 4 interfaces</br>

####Import header file:

```objective-c

#import <MOBFoundation/MobSDK+Privacy.h>

```



Show mobtech privacy agreement</br>
</br> developers need to show mobtech privacy policy first. It is suggested to show it in the following ways:</br>

**</br> (1) embed the URL of mobtech privacy agreement into the description of the app's own privacy agreement</br>
</br> (2) add the title of mobtech privacy agreement in the prominent position of the app privacy agreement authorization box, and click to view the content of the agreement</br>
</br> (3) embed the content of mobtech privacy agreement in the app's own privacy agreement </br>**

####</br> 2. Query the content of mobtech privacy agreement</br>

</br> developers should attach mobtech's privacy protocol in a prominent position (for example, in the application's own service agreement pop-up box), and users can view the content of the protocol by clicking. The function of querying the privacy protocol provides two options: synchronous and asynchronous. </br>

```objective-c
* *
Get user privacy agreement
@Param type protocol type (1 = URL type, 2 = rich text type)
@Param data title = title, content = content (type = 1, return URL, return rich text when type = 2)
* /
+ (void)getPrivacyPolicy:(NSString * _Nullable)type
compeletion:(void (^ _Nullable)(NSDictionary * _Nullable data,NSErro
R
* _Nullable error))result;
```

**The following values are available for </br> type:</br>
</br> (1) obtain the URL address of the privacy agreement, which is used to display the privacy agreement through the web page</br>
</br> (2) obtain the complete content of the privacy agreement, which is used to display the privacy agreement through the rich version </br>**

####</br> 3. Upload privacy agreement authorization status</br>

</br> upload the user's authorization status of the privacy agreement. When the user operates the authorization of the privacy agreement (whether authorized or denied), the status will be correctly fed back to mobtech, so that mobtech can identify whether the corresponding service content can be provided</br>

```objective-c
* *
Upload privacy agreement authorization status
@Whether param isagree agrees (the result of user authorization)
* /
+ (void)uploadPrivacyPermissionStatus:(BOOL)isAgree
onResult:(void (^_Nullable)(BOOL success))handler;
```
#####The scenario is as follows:</br>

<img src="http://download.sdk.mob.com/2020/02/18/20/1582030309701/834_1614_408.23.png" width="300">


####</br> 4. Setting of privacy secondary confirmation box switch (not required)</br>

```objective-c

* *
Set whether pop ups are allowed
@Whether param show allows to display the secondary pop-up window of the privacy protocol (preferably set to yes, otherwise some functions of mobtech may not be able to
Yes by default)
* /
+ (void)setAllowShowPrivacyWindow:(BOOL)show;
```
**It is better to call when application: didfinishlaunchingwithoptions: is used during application initialization to avoid late call and ineffective setting effect. </br>


####</br> 5. User defined privacy secondary confirmation box UI (not required)</br>

```objective-c
* *
Set privacy protocol pop-up tone
@Param backcolorb pop up background color
@Param colors pop-up button tone array (⾸ element is reject button tone, the second element is agree button tone)
* /
+ (void)setPrivacyBackgroundColor:(UIColor *_Nullable)backColor
operationButtonColor:(NSArray <UIColor *>*_Nullable)colors;
```



##2. Import header file
`#import <SMS_SDK/SMSSDK.h>`

- **Get verificationCode**


```
[SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:@"13800138000" zone:@"86" result:^(NSError *error) {

if (!error)
{
// 请求成功 
}
else
{
// error
}
}];
```


- **commit**


```
[SMSSDK commitVerificationCode:@"1234" phoneNumber:@"13800138000" zone:@"86" result:^(NSError *error) {

if (!error)
{
// 验证成功
}
else
{
// error
}
}];
```

## If you want to see the chinese document,please [click here](http://wiki.mob.com/sdk-sms-ios-3-0/) !

