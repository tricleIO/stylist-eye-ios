source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

platform :ios, ’9.0’

def shared_pods
    pod 'AlamofireObjectMapper'
    pod 'Alamofire'
    pod 'Kingfisher'
    pod 'KVNProgress'
    pod 'ObjectMapper'
    pod 'SnapKit'
end

target ‘StylistEye’ do
    shared_pods
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
