# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NewsApp’ do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Kingfisher', '~> 7.0'
  pod 'SnapKit', '~> 5.6.0'

  # Pods for NewsApp

post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64 i386"
   end
   end
end
end