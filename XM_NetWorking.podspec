#
# Be sure to run `pod lib lint XM_NetWorking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XM_NetWorking'
  s.version          = '1.0.1'
  s.summary          = 'XM_NetWorking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '网络框架类很好用，很便捷，好'

  s.homepage         = 'https://github.com/zhangxiaomeng1/XM_NetWorking.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangxieomeng1' => 'zhangxiaomeng@xiangshang360.com' }
  s.source           = { :git => 'https://github.com/zhangxiaomeng1/XM_NetWorking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'XM_NetWorking/Classes/**/*'

  # s.resource_bundles = {
  #   'XM_NetWorking' => ['XM_NetWorking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'AFNetworking', '~> 3.1.0'

end
