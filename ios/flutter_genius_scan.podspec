#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_genius_scan'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for the Genius Scan SDK.'
  s.description      = <<-DESC
Flutter plugin for the Genius Scan SDK.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  s.preserve_paths = 'GSSDKCore.xcframework', 'GSSDKScanFlow.xcframework', 'GSSDKOCR.xcframework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework GSSDKCore -framework GSSDKScanFlow -framework GSSDKOCR' }
  s.vendored_frameworks = 'GSSDKCore.xcframework', 'GSSDKScanFlow.xcframework', 'GSSDKOCR.xcframework'
end
