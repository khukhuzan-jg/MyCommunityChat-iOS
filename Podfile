 platform :ios, '13.0'
use_frameworks!

def linkProject (name)
  project '#{name}/#{name}.project'
end

workspace 'MyCommunityChat-iOS'

def rx_pods
  pod 'RxSwift', '6.5.0'
  # Reactive Extensions
  pod 'RxSwiftExt', '6.2.1'
end

def networking_pods
  pod 'ReachabilitySwift'
  # Network debugging tool
  #
  # Shake to display network activities
  pod 'netfox'
  pod 'KeychainAccess', '4.2.2'
end

def ui_pods
  pod 'Kingfisher', '6.3.0'
  pod 'lottie-ios', '4.3.4'
  pod 'iOSPhotoEditor'
  pod 'CHIPageControl', '~> 0.1.3'
  pod 'SwiftGifOrigin', '~> 1.7.0'
end

def firebase_pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
#  pod 'Firebase/Messaging'
  pod 'Firebase/Database'
end

def iqkeyboardmanager_pod
  pod 'IQKeyboardManagerSwift', '6.5.6'
end

def one_signal_pods
  pod 'OneSignal/OneSignal' #, '>= 5.0.0', '< 6.0'
  pod 'OneSignal/OneSignalInAppMessages' #, '>= 5.0.0', '< 6.0'
end

target 'Domain' do
  project 'Domain/Domain.project'
  networking_pods
  firebase_pods
end

def db_pod
  pod 'RealmSwift'
end

target 'MyCommunityChat-iOS' do
   project 'MyCommunityChat-iOS'
   rx_pods
   networking_pods
   firebase_pods
   iqkeyboardmanager_pod
   ui_pods
   one_signal_pods
   db_pod
end

target 'OneSignalNotificationServiceExtension' do
  one_signal_pods
end

target 'MyCommunityChat-iOSTests' do
    inherit! :search_paths
    # Pods for testing
end

target 'MyCommunityChat-iOSUITests' do
    # Pods for testing
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
