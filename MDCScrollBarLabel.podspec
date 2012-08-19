Pod::Spec.new do |s|
  s.name         = 'MDCScrollBarLabel'
  s.version      = '0.0.1'
  s.summary      = 'Like Path\'s timestamp scrollbar label.'
  s.homepage     = 'https://github.com/modocache/MDCScrollBarLabel'
  s.license      = 'MIT'
  s.author       = { 'modocache' => 'modocache@gmail.com' }
  s.source       = { :git => 'https://github.com/modocache/MDCScrollBarLabel.git', :commit => 'f4e1cdfd1e0d4a23f0acab56c67f93f8f20b4f37' }
  s.source_files = '*.{h,m}'
  s.requires_arc = true
  s.platform     = :ios, '5.0'
  s.framework    = 'UIKit'
end
