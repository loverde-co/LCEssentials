def shared_pods
  source 'https://github.com/CocoaPods/Specs.git'
  platform :ios, '10.0'
  use_frameworks!
  project 'LCEssentials/LCEssentials.xcodeproj'

  # - Swift Essentials
  #pod 'Alamofire'
end

target 'LCEssentials' do
  shared_pods
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end

