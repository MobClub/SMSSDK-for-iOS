Pod::Spec.new do |s|
s.name                = "SMSSDK"
s.version             = "1.2.0"
s.summary             = 'mob.com免费短信验证码SDK'
s.license             = 'Copyright © 2012-2015 mob.com'
s.author              = { "Jinghuang Liu" => "liujinghuang@icloud.com" }
s.homepage            = 'http://www.mob.com'
s.source              = { :git => "https://github.com/ShareSDKPlatform/SMSSDK-for-iOS.git", :tag => s.version.to_s }
s.platform            = :ios, '6.0'
s.frameworks          = "MessageUI", "AddressBook", "AddressBookUI", "javascriptcore"
s.libraries           = "icucore", "z", "stdc++"
s.vendored_frameworks = 'SMS_SDK/SMS_SDK.framework'
s.resources           = 'SMS_SDK/en.lproj', 'SMS_SDK/zh-Hans.lproj'
end
