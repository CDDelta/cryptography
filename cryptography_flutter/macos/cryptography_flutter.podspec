#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint cryptography_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'cryptography_flutter'
  s.version          = '0.1.0'
  s.summary          = 'A cryptography plugin for Flutter.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://github.com/dint-dev/cryptography'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Gohilla Ltd' => 'opensource@gohilla.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
