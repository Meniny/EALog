Pod::Spec.new do |s|
  s.name        = 'EALog'
  s.module_name = 'EALog'
  s.version     = '1.0.0'
  s.summary     = 'A tiny logging framework written in Swift.'

  s.homepage    = 'https://github.com/Meniny/EALog'
  s.license     = { type: 'MIT', file: 'LICENSE.md' }
  s.authors     = { 'Elias Abel' => 'admin@meniny.cn' }
  s.social_media_url = 'https://meniny.cn/'
  # s.screenshot = ''

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.9'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source              = { git: 'https://github.com/Meniny/EALog.git', tag: s.version.to_s }

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
  s.swift_version       = '4.1'
  s.requires_arc        = true

  s.default_subspecs = 'Core'

  s.subspec 'Core' do |sp|
    sp.source_files  = 'EALog/Core/**/*.swift'
  end
end
