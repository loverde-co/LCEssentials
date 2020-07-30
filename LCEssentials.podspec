Pod::Spec.new do |s|
  s.name             = 'LCEssentials'
  s.version          = '0.4.6.3'
  s.summary          = 'This is a repository of essential scripts written in Swift for Loverde Co.'
 
  s.description      = <<-DESC
This is a repository of essential scripts written in Swift for Loverde Co. used to save time on re-writing and keeping it on all other projects. So this Cocoapods will evolve with Swift and will improve with every release! 
                       DESC
 
  s.homepage         = 'https://github.com/loverde-co/LCEssentials'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Daniel Arantes Loverde' => 'daniel@loverde.com.br' }
  s.source           = { :git => 'https://github.com/loverde-co/LCEssentials.git', :tag => s.version }
  s.swift_version    = '4.0'
  #s.dependency       'Alamofire'
  s.platform         = :ios, '11.0'
  s.platform         = :watchos, '4.0'
  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '5.0'
  s.ios.source_files     = 'LCEssentials/Classes/*.{swift}', 'LCEssentials/PickerViews/*.{swift}', 'LCEssentials/Notifications/*.{swift}', 'LCEssentials/ImageZoom/*.{swift}', 'LCEssentials/ImagePicker/*.{swift}'
  s.watchos.source_files     = 'LCEssentials/Classes/*.{swift}'
  s.ios.resources        = ['LCEssentials/PickerViews/Storyboards/*.{storyboard}', 'LCEssentials/Notifications/Storyboard/*.{storyboard}', 'LCEssentials/Notifications/Storyboard/*.{png}', 'LCEssentials/ImageZoom/Storyboard/*.{storyboard}', 'LCEssentials/ImagePicker/Storyboard/*.{storyboard}']

  # LCEMinimal Extensions
  s.subspec 'Classes' do |sp|
    sp.source_files  		= 'LCEssentials/Classes/*.{swift}'
    sp.watchos.source_files     = 'LCEssentials/Classes/*.{swift}'
  end

  # LCEPickerViews Extensions
  s.subspec 'PickerViews' do |sp|
    sp.source_files  = 'LCEssentials/Classes/*.{swift}', 'LCEssentials/PickerViews/*.{swift}'
    sp.ios.resources = ['LCEssentials/PickerViews/Storyboards/*.{storyboard}']
  end

  # LCENotifications Extensions
  s.subspec 'Notifications' do |sp|
    sp.source_files  = 'LCEssentials/Classes/*.{swift}', 'LCEssentials/Notifications/*.{swift}'
    sp.ios.resources = ['LCEssentials/Notifications/Storyboards/*.{storyboard}', 'LCEssentials/Notifications/Storyboard/*.{png}']
  end

  # LCEImageZoom Extensions
  #s.subspec 'ImagesZoom' do |sp|
  #  sp.source_files  = 'LCEssentials/Classes/*.{swift}', 'LCEssentials/ImageZoom/*.{swift}'
  #  sp.ios.resources = ['LCEssentials/ImageZoom/Storyboards/*.{storyboard}']
  #end

  # LCEImagePicker Extensions
  #s.subspec 'ImagePicker' do |sp|
  #  sp.source_files  = 'LCEssentials/Classes/*.{swift}', 'LCEssentials/ImagePicker/*.{swift}'
  #  sp.ios.resources = ['LCEssentials/ImagePicker/Storyboards/*.{storyboard}']
  #end
end
