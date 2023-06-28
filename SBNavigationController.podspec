Pod::Spec.new do |s|

  s.name        = 'SBNavigationController'
  s.version     = '0.1.0'
  s.summary     = 'A lightweight and pure Swift implemented library for customizable navigation controller.'

  s.description = <<-DESC
                       SBNavigationController is a lightweight and pure Swift implemented library for customizable navigation controller.
                       DESC

  s.homepage    = 'https://github.com/spirit-jsb/SBNavigationController'
  
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  
  s.author      = { 'spirit-jsb' => 'sibo_jian_29903549@163.com' }
  
  s.swift_versions = ['5.0']
  
  s.ios.deployment_target = '11.0'
    
  s.source       = { :git => 'https://github.com/spirit-jsb/SBNavigationController.git', :tag => s.version }
  s.source_files = ["Sources/**/*.swift"]
  
  s.requires_arc = true
end