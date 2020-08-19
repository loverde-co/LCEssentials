Pod::Spec.new do |s|
  s.name             = 'LCEssentialsWatch'
  s.version          = '0.0.1'
  s.summary          = 'This is a repository of essential scripts written in Swift for Loverde Co.'
 
  s.description      = <<-DESC
This is a repository of essential watchOS scripts written in Swift for Loverde Co. used to save time on re-writing and keeping it on all other projects. So this Cocoapods will evolve with Swift and will improve with every release!
                       DESC
 
  s.homepage         = 'https://github.com/loverde-co/LCEssentials'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Daniel Arantes Loverde' => 'daniel@loverde.com.br' }
  s.source           = { :git => 'https://github.com/loverde-co/LCEssentials.git', :tag => s.version }
  s.swift_version    = '5.0'
  s.platform         = :watchos, '4.0'
  s.watchos.deployment_target = '5.0'
  s.watchos.source_files     = 'Sources/LCEssentials/Classes/*.{swift}'
end
