# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Chika' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Chika
  pod 'Firebase'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Kingfisher'
  pod 'DateTools'
  pod 'Fabric'
  pod 'Crashlytics'

  target 'ChikaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ChikaUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    if config.name == 'Release'
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
    end
  end
end
