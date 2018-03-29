#
# Be sure to run `pod lib lint Brotli.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Brotli'
  s.version          = '1.0.0'
  s.summary          = 'An NSData category pod that provides Brotli compression and decompression for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An NSData category pod that provides Brotli compression and decompression for iOS.
                       DESC

  s.homepage         = 'https://github.com/karlvr/Brotli'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Karl von Randow' => 'karl@xk72.com' }
  s.source           = { :git => 'https://github.com/karlvr/Brotli.git', :tag => s.version.to_s, :submodules => true }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Brotli/Classes/**/*', 'Brotli/Source/c/common/*.c', 'Brotli/Source/c/dec/*.c', 'Brotli/Source/c/enc/*.c'
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/Brotli/Source/c/include'
  }
  s.preserve_paths = 'Brotli/Source/c/common/*.h', 'Brotli/Source/c/dec/*.h', 'Brotli/Source/c/enc/*.h', 'Brotli/Source/c/include/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
end
