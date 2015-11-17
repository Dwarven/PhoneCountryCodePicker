Pod::Spec.new do |s|

  s.name                  = 'PhoneCountryCodePicker'
  s.version               = '0.1.1'
  s.summary               = 'Array of phone country codes and flags.'
  s.homepage              = 'https://github.com/Dwarven/PhoneCountryCodePicker'
  s.ios.deployment_target = '7.0'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Dwarven' => 'prison.yang@gmail.com' }
  s.source                = { :git => 'https://github.com/Dwarven/PhoneCountryCodePicker.git', :tag => s.version, :submodules => true }
  s.source_files          = 'PhoneCountryCodePicker/*.{h,m}'
  s.resource              = 'PhoneCountryCodePicker/Phone-Country-Code-and-Flags/*.{json,png}'

end
