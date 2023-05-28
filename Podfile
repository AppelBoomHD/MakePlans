# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MakePlans' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MakePlans

  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  # add pods for any other desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods
  pod 'GoogleSignIn'
  pod 'Introspect'
  
  pod 'Resolver'
  pod 'Firebase/Functions'
  
  pod 'Firebase/DynamicLinks'

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.5'
      end
    end
end 
