# platform :ios, '13.0'
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
end

def firebase_pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
end

def iqkeyboardmanager_pod
  pod 'IQKeyboardManagerSwift', '6.5.6'
end

target 'Domain' do
  project 'Domain/Domain.project'
  networking_pods
  firebase_pods
end

target 'MyCommunityChat-iOS' do
   project 'MyCommunityChat-iOS'
   rx_pods
   networking_pods
   firebase_pods
   iqkeyboardmanager_pod
   ui_pods
end

target 'MyCommunityChat-iOSTests' do
    inherit! :search_paths
    # Pods for testing
end

target 'MyCommunityChat-iOSUITests' do
    # Pods for testing
end
