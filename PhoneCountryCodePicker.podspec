Pod::Spec.new do |s|

  s.name                  = 'PhoneCountryCodePicker'
  s.version               = '0.2.0'
  s.summary               = 'An iOS tableview picker for PhoneCountryCode.'
  s.homepage              = 'https://github.com/Dwarven/PhoneCountryCodePicker'
  s.ios.deployment_target = '7.0'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Dwarven' => 'prison.yang@gmail.com' }
  s.social_media_url      = "https://twitter.com/DwarvenYang"
  s.source                = { :git => 'https://github.com/Dwarven/PhoneCountryCodePicker.git', :tag => s.version, :submodules => true }
  s.source_files          = 'PhoneCountryCodePicker/*.{h,m}'
  s.dependency              'Phone-Country-Code-and-Flags'

end
