Pod::Spec.new do |s|
  s.name = 'DrawerController'
  s.version = '1.1.1'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/sascha/DrawerController'
  s.authors = { 'Sascha Schwabbauer' => 'sascha@evolved.io',
  				'Malte Baumann' => 'malte@codingdivision.com' }
  s.summary = 'A lightweight, easy-to-use side drawer navigation controller (Swift port of MMDrawerController).'
  s.social_media_url = 'http://twitter.com/_saschas'
  s.source = { :git => 'https://github.com/Kukiwon/DrawerController.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.ios.deployment_target = '8.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'DrawerController/DrawerController.swift'
    ss.framework  = 'QuartzCore'
  end
  
  s.subspec 'DrawerVisualStates' do |ss|
  	ss.source_files = 'DrawerController/DrawerBarButtonItem.swift', 'DrawerController/AnimatedMenuButton.swift', 'DrawerController/DrawerVisualState.swift'
  	ss.dependency 'DrawerController/Core'
  end
end
