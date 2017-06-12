Pod::Spec.new do |s|
s.name                = "SMSSDK"
s.version             = "3.0.0"
s.summary             = 'mob.com免费短信验证码SDK'
s.license             = 'Copyright © 2012-2017 mob.com'
s.author              = { "qc123456" => "vhbvbqc@gmail.com" }
s.homepage            = 'http://www.mob.com'
s.source              = { :git => "https://github.com/ShareSDKPlatform/SMSSDK-for-iOS.git", :tag => s.version.to_s }
s.platform            = :ios, '7.0'
s.libraries           = "z", "stdc++"
s.vendored_frameworks = 'MobProducts/SDK/SMSSDK/SMS_SDK.framework'
s.dependency 'MOBFoundation'
end
