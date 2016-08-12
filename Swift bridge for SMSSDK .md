# Bridge for SMSSDK
In this document ,I will tell you the  bridge method to import the SMSSDK that was completed by objective-c language. Before this, I think that you have also know  the method to import the SMSSDK, if no, the other document is right for you firstly. It’s link is:[Document of importing the SMSSDK](https://github.com/MobClub/SMSSDK-for-iOS/blob/master/README.md).

##Pre-preparation work：
1. the SDK that had downloaded ([Download the SMSSDK](http://www.mob.com/#/downloadDetail/SMS/ios)) and unzip it,when you unzip it ,it's like this:

  ![](http://ww2.sinaimg.cn/mw690/9fbf66d3gw1f6qr5l038zj20h50brjrx.jpg)
  
  As shown in the figure,it's contains three parties:
  
> * SMSSDK. Including static libraries and local files.When used directly to this folder into the project.
> * SMSSDKDemo. Showing the SDK foundation.
> * SMSSDKUI. If you want to use it, drag SMSSDKUI.xcodeproj to your project directly.

2. Had gotten the appKey and appSerect 

> * if you don’t have the appKey and appSerect,please get it from Mob.com [ Document for getting appkey and appSerect](http://bbs.mob.com/forum.php?mod=viewthread&tid=8212&extra=page%3D1)

#Now ,it's the show time:
##Step1:Drag the SMSSDK to your project directly,like this:
![](http://ww4.sinaimg.cn/mw690/9fbf66d3gw1f6r04o8gnij21db0pswru.jpg)

##Attention:
when drag the SMSSDK to your project ,you must select “Create groups ” button,otherwise,the file of  a blue folder that had imported to your project will don’t find in your project.
 it’s right  after importing SMSSDK to your project,liking this:
 
 ![](http://ww3.sinaimg.cn/mw690/9fbf66d3gw1f6r04owlhfj20710ahmxl.jpg)
 
##Step2: Add libraries
 
Required:
> * libz.dylib
> * libicucore.dylib
> * MessageUI.framework
> * JavaScriptCore.framework
> * libstdc++.dylib

Optional
> * AddressBook.framework （Needed by the AddressBook foundation）
> * AddressBookUI.framework（Needed by the AddressBook foundation）

Liking this:

![](http://ww3.sinaimg.cn/mw690/9fbf66d3gw1f6r04phn1jj21av0bpafa.jpg)

##Step3: setup the header file and then setting the bridge

![](http://ww2.sinaimg.cn/mw690/9fbf66d3gw1f6r04q9i1ij20ke0ed40n.jpg)

![](http://ww4.sinaimg.cn/mw690/9fbf66d3gw1f6r04qx2pej20js0lmtbk.jpg)

![](http://ww2.sinaimg.cn/mw690/9fbf66d3gw1f6r04rizlbj213e0san7r.jpg)

##Step4: Open the bridge file ,and then importing the header files,like this:
> * //  SMSSDK-Bridging-Header.h
> * SMS-SDK(swift)
> * //#ifndef SMS_SDK_swift__SMSSDK_Bridging_Header_h
> * //#define SMS_SDK_swift__SMSSDK_Bridging_Header_h

> * //导入SMS-SDK的头文件
> * // #import <SMS_SDK/SMSSDK.h>
> * //关闭访问通讯录需要导入的头文件
> * //#import <SMS_SDK/SMSSDK+AddressBookMethods.h>

##Step5:  Initializing the SDK

Initializing the SMSSDK, you’d better do this in this method “application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool” that is belong to the “Appdelegate.Swift” class.liking this:

![](http://ww3.sinaimg.cn/mw690/9fbf66d3gw1f6r04saqw1j20ww0akq4z.jpg)

##From now ,you can use the SMSSDK API what you want ,liking this:

![](http://ww1.sinaimg.cn/mw690/9fbf66d3gw1f6r04t930sj21gw0qftdr.jpg)

##The end,we provide the Demo for you ,just enjoy it ~

###[Demo is here,please just enjoy it ~~~](https://github.com/kengsir/SMSSDK-Swift-)

