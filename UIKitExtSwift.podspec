Pod::Spec.new do |s|
  s.name         = "UIKitExtSwift"
  s.version      = "0.1.1"
  s.summary      = "A short description of UIKitExtSwift."

  s.homepage     = "https://github.com/qianshang/UIKitExtSwift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "ChengWei" => "c1027999177@gmail.com" }
  s.source       = { :git => "https://github.com/qianshang/UIKitExtSwift.git", :tag => "#{s.version}" }
  s.source_files = "UIKitExtSwift/**/*.swift"
  
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.swift_versions = '5.0'

end
