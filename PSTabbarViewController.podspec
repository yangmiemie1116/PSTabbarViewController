Pod::Spec.new do |s|
  s.name         = "PSTabbarViewController"
  s.version      = "0.0.1"
  s.summary      = "自定义tabbarcontroller，tabbar的位置可以在左边和底部"
  s.description  = <<-DESC
  自定义tabbarcontroller，tabbar的位置可以在左边和底部
                   DESC

  s.homepage     = "https://github.com/yangmiemie1116/PSTabbarViewController.git"
  s.license      = "MIT"
  s.author             = { "杨志强" => "yangzhiqiang116@gmail.com" }
  s.social_media_url   = "http://www.jianshu.com/u/bd06a732c598"
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/yangmiemie1116/PSTabbarViewController.git", :tag => "#{s.version}" }
  s.source_files  = "PSTabbarViewController/*.swift"
  s.requires_arc = true
  s.dependency "SnapKit"

end
