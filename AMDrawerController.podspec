Pod::Spec.new do |s|
  s.name = 'AMDrawerController'
  s.version = '4.2.4'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/Anumothu/DrawerController'
  s.authors = { 'Sascha Schwabbauer' => 'sascha@evolved.io',
  				'Malte Baumann' => 'malte@codingdivision.com','Alen' => 'alenbala11@gmail.com' }
  s.summary = 'A lightweight, easy-to-use side drawer navigation controller (Swift port of MMDrawerController).'
  s.social_media_url = 'http://twitter.com/_saschas'
  s.source = { :git => 'https://github.com/Anumothu/DrawerController.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.ios.deployment_target = '9.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'DrawerController/DrawerController.swift', 'DrawerController/DrawerSegue.swift'
    ss.framework  = 'QuartzCore'
  end

  s.subspec 'DrawerVisualStates' do |ss|
  	ss.source_files = 'DrawerController/DrawerBarButtonItem.swift', 'DrawerController/AnimatedMenuButton.swift', 'DrawerController/DrawerVisualState.swift'
  	ss.dependency 'DrawerController/Core'
  end
end
