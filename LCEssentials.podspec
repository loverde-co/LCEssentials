Pod::Spec.new do |s|
  s.name             = 'LCEssentials'
  s.version          = '0.5.9'
  s.summary          = 'This is a repository of essential scripts written in Swift for Loverde Co.'
 
  s.description      = <<-DESC
This is a repository of essential scripts written in Swift for Loverde Co. used to save time on re-writing and keeping it on all other projects. So this Cocoapods will evolve with Swift and will improve with every release! 
                       DESC
 
  s.homepage         = 'https://github.com/loverde-co/LCEssentials'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Daniel Arantes Loverde' => 'daniel@loverde.com.br' }
  s.source           = { :git => 'https://github.com/loverde-co/LCEssentials.git', :tag => s.version }
  s.swift_version    = '5.0'
  s.platform         = :ios, '11.4'
  s.platform         = :watchos, '4.0'
  s.ios.deployment_target = '11.4'
  s.watchos.deployment_target = '5.0'
  s.ios.source_files     = 'Sources/LCEssentials/Classes/*.{swift}', 'Sources/LCEssentials/PickerViews/*.{swift}', 'Sources/LCEssentials/Notifications/*.{swift}', 'Sources/LCEssentials/ImageZoom/*.{swift}', 'Sources/LCEssentials/ImagePicker/*.{swift}', 'Sources/LCEssentials/HUDAlert/*.{swift}'
  s.ios.resources        = ['Sources/LCEssentials/PickerViews/Storyboards/*.{storyboard}', 'Sources/LCEssentials/Notifications/Storyboard/*.{storyboard}', 'Sources/LCEssentials/Notifications/Storyboard/*.{png}', 'Sources/LCEssentials/ImageZoom/Storyboard/*.{storyboard}', 'Sources/LCEssentials/ImagePicker/Storyboard/*.{storyboard}', 'Sources/LCEssentials/HUDAlert/Storyboard/*.{storyboard}']
  
  s.watchos.source_files     = 'Sources/LCEssentials/Classes/*.{swift}'

  # LCEMinimal Extensions
  s.subspec 'Classes' do |sp|
    sp.source_files  		= 'Sources/LCEssentials/Classes/*.{swift}'
    sp.watchos.source_files     = 'Sources/LCEssentials/Classes/*.{swift}'
  end

  # LCEPickerViews Extensions
  s.subspec 'PickerViews' do |sp|
    sp.source_files  = 'Sources/LCEssentials/Classes/*.{swift}', 'Sources/LCEssentials/PickerViews/*.{swift}'
    sp.ios.resources = ['Sources/LCEssentials/PickerViews/Storyboards/*.{storyboard}']
  end

  # LCENotifications Extensions
  s.subspec 'Notifications' do |sp|
    sp.source_files  = 'Sources/LCEssentials/Classes/*.{swift}', 'Sources/LCEssentials/Notifications/*.{swift}'
    sp.ios.resources = ['Sources/LCEssentials/Notifications/Storyboards/*.{storyboard}', 'Sources/LCEssentials/Notifications/Storyboard/*.{png}']
  end

  # LCEImageZoom Extensions
  s.subspec 'ImageZoom' do |sp|
    sp.source_files  = 'Sources/LCEssentials/Classes/*.{swift}', 'Sources/LCEssentials/ImageZoom/*.{swift}'
    sp.ios.resources = ['Sources/LCEssentials/ImageZoom/Storyboard/*.{storyboard}']
  end

  # LCEImagePicker Extensions
  s.subspec 'ImagePicker' do |sp|
    sp.source_files  = 'Sources/LCEssentials/Classes/*.{swift}', 'Sources/LCEssentials/ImagePicker/*.{swift}'
    sp.ios.resources = ['Sources/LCEssentials/ImagePicker/Storyboard/*.{storyboard}']
  end

  # LCEHUDAlert Extensions
  s.subspec 'HUDAlert' do |sp|
    sp.source_files  = 'Sources/LCEssentials/Classes/*.{swift}', 'Sources/LCEssentials/HUDAlert/*.{swift}'
    sp.ios.resources = ['Sources/LCEssentials/HUDAlert/Storyboard/*.{storyboard}']
  end
end
