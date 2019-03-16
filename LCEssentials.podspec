Pod::Spec.new do |s|
  s.name             = 'LCEssentials'
  s.version          = '0.2.12.9'
  s.summary          = 'This is a repository of essential scripts written in Swift for Loverde Co.'
 
  s.description      = <<-DESC
This is a repository of essential scripts written in Swift for Loverde Co. used to save time on re-writing and keeping it on all other projects. So this Cocoapods will evolve with Swift and will improve with every release! 
                       DESC
 
  s.homepage         = 'https://github.com/loverde-co/LCEssentials'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Daniel Arantes Loverde' => 'daniel@loverde.com.br' }
  s.source           = { :git => 'https://github.com/loverde-co/LCEssentials.git', :tag => s.version.to_s }
  s.swift_version    = '4.0'
  s.platform         = :ios, '11.0'
  s.platform         = :watchos, '4.0'
  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '5.0'
  #s.source_files     = 'LCEssentials/LCEssentials/Classes/*.{swift}', 'LCEssentials/LCEssentials/PickerViews/*.{swift}', 'LCEssentials/LCEssentials/Notifications/*.{swift}'
  s.ios.source_files     = 'LCEssentials/LCEssentials/Classes/*.{swift}', 'LCEssentials/LCEssentials/PickerViews/*.{swift}', 'LCEssentials/LCEssentials/Notifications/*.{swift}'
  s.watchos.source_files     = 'LCEssentials/LCEssentials/Classes/*.{swift}'
  #s.resources        = ['LCEssentials/LCEssentials/PickerViews/Storyboards/*.{storyboard}', 'LCEssentials/LCEssentials/Notifications/Storyboard/*.{storyboard}', 'LCEssentials/LCEssentials/Notifications/Storyboard/*.{png}']
  s.ios.resources        = ['LCEssentials/LCEssentials/PickerViews/Storyboards/*.{storyboard}', 'LCEssentials/LCEssentials/Notifications/Storyboard/*.{storyboard}', 'LCEssentials/LCEssentials/Notifications/Storyboard/*.{png}']
end