Pod::Spec.new do |s|
s.name                = "mob_smssdk"
s.version             = "3.1.0"
s.summary             = 'mob.com免费短信验证码SDK'
s.license             = 'Copyright © 2012-2017 mob.com'
s.author              = { "mob" => "mobproducts@163.com" }
s.homepage            = 'http://www.mob.com'
s.source              = { :git => "https://github.com/MobClub/SMSSDK-for-iOS.git", :tag => s.version.to_s }
s.platform            = :ios, '8.0'
s.libraries           = "z", "stdc++"
s.vendored_frameworks = 'SDK/SMSSDK/SMS_SDK.framework'
s.dependency 'MOBFoundation'
end
