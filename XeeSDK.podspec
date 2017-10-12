#
# Be sure to run `pod lib lint XeeSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XeeSDK'
  s.version          = '2.0.3'
  s.summary          = 'This SDK make easier the usage of Xee API (dev.xee.com) on iOS devices.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/xee-lab/xee-sdk-ios/tree/cocoapods'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'Eliocity' => 'jbdujardin@xee.com' }
  s.source           = { :git => 'https://github.com/xee-lab/xee-sdk-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.facebook.com/XeeFR'

  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.public_header_files = 'XeeSDK/*.h'
  s.source_files = 'XeeSDK/*.{h,m}'
  s.resource_bundle = { 'XeeSDKBundle' => 'XeeSDK/Resources/**/*'}

  s.subspec 'Model' do |ss|
    ss.source_files = 'XeeSDK/Model/*.{h,m}'
    ss.public_header_files = 'XeeSDK/Model/*.h'
  end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 3.0'
end
