Pod::Spec.new do |s|
  s.name         = "WXBaseRequest"                #名称
  s.version      = "0.0.2"                  #版本号
  s.summary      = "ios网络请求"               #简短介绍
  s.description  = <<-DESC 
                      ios网络请求封装
                   DESC
  s.homepage     = "https://github.com/xiexingyu"
  s.license      = "MIT"                    #开源协议
  s.author             = { "xiexingyu" => "281266447@qq.com" }
  s.source       = { :git => "https://github.com/xiexingyu/WXBaseRequest.git", :tag => s.version }
  s.platform     = :ios, "8.0"              #支持的平台及版本
  s.requires_arc = true                     #是否使用ARC
  s.frameworks   = 'UIKit', 'Foundation'    #所需的framework,多个用逗号隔
  s.source_files = 'WXBaseRequest/Classes/**/*'
  s.dependency 'AFNetworking', '~> 3.0.4'
  s.dependency 'YYKit'
  s.dependency 'WXBaseKit'
end