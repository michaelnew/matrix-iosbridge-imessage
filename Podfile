platform :ios, '8.0'

plugin 'cocoapods-rome', { :pre_compile => Proc.new { |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end

    installer.pods_project.save
},

    dsym: false,
    configuration: 'Release'
}

target 'caesar' do
  pod 'SwiftMatrixSDK'
end
