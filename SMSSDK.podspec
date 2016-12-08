Pod::Spec.new do |s|
s.name                = "SMSSDK"
s.version             = "2.0.9"
s.summary             = 'mob.com免费短信验证码SDK'
s.license             = 'Copyright © 2012-2015 mob.com'
s.author              = { "liyuansheng" => "763497804@qq.com" }
s.homepage            = 'http://www.mob.com'
s.source              = { :git => "https://github.com/ShareSDKPlatform/SMSSDK-for-iOS.git", :tag => s.version.to_s }
s.platform            = :ios, '6.0'
s.frameworks          = "MessageUI", "AddressBook", "AddressBookUI", "JavaScriptCore"
s.libraries           = "icucore", "z", "stdc++"
s.vendored_frameworks = 'SMS_SDK/SMS_SDK.framework'
s.resources           = 'SMSSDKUI.bundle','SMS_SDK/SMSSDK.bundle'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '2.3' }
end
