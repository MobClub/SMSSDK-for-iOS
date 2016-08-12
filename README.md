# SMSSDK-for-iOS

SMSSDK is the most popular social SDK for apps and mobile games ! We've already supported over 1000 country or zone in global world  until now. And also it’s easily to use in your app.now, I will tell you the steps liking this:
## Step1: Download the SDK from here :
### [SMSSDK for iOS](http://www.mob.com/#/downloadDetail/SMS/ios)
        
 When you download the SDK, you will get something liking this:
 ![image](http://wiki.mob.com/wp-content/uploads/2014/09/SMSSDK.jpg)

  It’s contain the three parties:

      1.SMSSDK. Including static libraries and local files.When used directly to this folder into the project.
      2.SMSSDKDemo. Showing the SDK foundation.

      3.SMSSDKUI. If you want to use it, drag SMSSDKUI.xcodeproj to your project directly.

##Step2：Import the SDK

        Drag  SMSSDK this folder into the project,like this:
![](http://wiki.mob.com/wp-content/uploads/2014/09/SMS_SKD-drag.png)
  
##Step3: Add libraries 

     Required:

      a.  libz.dylib
      b.  libicucore.dylib
      c.  MessageUI.framework
      d. JavaScriptCore.framework
      e. libstdc++.dylib

    Optional

      a.  AddressBook.framework （Needed by the AddressBook foundation）
      b.  AddressBookUI.framework（Needed by the AddressBook foundation）

  Show you like this：
![](http://wiki.mob.com/wp-content/uploads/2014/09/SMSSDKAddFramework.png)
  
##Step4: Add the initialization code


    1.Import the header file of the SDK  in this appDelegate  file of your project

       #import <SMS_SDK/SMSSDK.h>

    2. Add register SDK method

       In your project ,add register SDK method in this method,like this:
         - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   //初始化应用，appKey和appSecret从后台申请得
   [SMSSDK registerApp:appKey
            withSecret:appSecret];
}

    AppKey and appSerect:

    (1) Register as a Mob developers 
### [点击注册](http://www.mob.com/#/reg)
    (2) New application,the steps of new application,please reference:
### [新建应用参考文档](http://bbs.mob.com/forum.php?mod=viewthread&tid=8212&extra=page%3D1)

##Step5: Using API 
![](http://wiki.mob.com/wp-content/uploads/2014/09/%E7%9F%AD%E4%BF%A1%E4%BB%A3%E7%A0%81.jpg)

In the SMSSDK file ,it contains all the API in the SDK, and here,you can use anyone that you wanted liking this:

[SMSSDK  ********];
