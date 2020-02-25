Pod::Spec.new do |s|
s.name                = "mob_smssdk"
s.version             = "3.2.6"
s.summary             = 'mob.com免费短信验证码SDK'
s.license             = 'Copyright © 2012-2017 mob.com'
s.author              = { "mob" => "mobproducts@163.com" }
s.homepage            = 'http://www.mob.com'
s.source              = { :http => 'https://dev.ios.mob.com/files/download/smssdk/SMSSDK_For_iOS_v3.2.6.zip' }
s.platform            = :ios, '8.0'
s.libraries           = "z", "c++"
s.vendored_frameworks = 'SMSSDK/SMS_SDK.framework'
s.dependency 'MOBFoundation'
end
