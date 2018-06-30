Pod::Spec.new do |s|
  s.name             = 'LCEssentials'
  s.version          = '0.1.28'
  s.summary          = 'This is a repository of essential scripts written in Swift for Loverde Co.'
 
  s.description      = <<-DESC
This is a repository of essential scripts written in Swift for Loverde Co. used to save time on re-writing and keeping it on all other projects. So this Cocoapods will evolve with Swift and will improve with every release! 
                       DESC
 
  s.homepage         = 'https://github.com/loverde-co/LCEssentials'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Daniel Arantes Loverde' => 'daniel@loverde.com.br' }
  s.source           = { :git => 'https://github.com/loverde-co/LCEssentials.git', :tag => s.version.to_s }
  s.swift_version    = '4.0'
  s.platform         = :ios, '9.0'
  s.ios.deployment_target = '10.0'
  s.source_files     = 'LCEssentials/LCEssentials/Classes/*.{swift}', 'LCEssentials/LCEssentials/PickerViews/*.{swift}', 'LCEssentials/LCEssentials/Notifications/*.{swift}'
  s.resources        = ['LCEssentials/LCEssentials/PickerViews/Storyboards/*.{storyboard}', 'LCEssentials/LCEssentials/Notifications/Storyboard/*.{storyboard}', 'LCEssentials/LCEssentials/Notifications/Storyboard/*.{png}']
end