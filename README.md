# PhoneCountryCodePicker

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/PhoneCountryCodePicker.svg)](https://img.shields.io/cocoapods/v/PhoneCountryCodePicker.svg)
[![Platform](https://img.shields.io/cocoapods/p/PhoneCountryCodePicker.svg?style=flat)](http://cocoadocs.org/docsets/PhoneCountryCodePicker)
[![Twitter](https://img.shields.io/badge/twitter-@DwarvenYang-blue.svg?style=flat)](http://twitter.com/DwarvenYang)

An iOS tableview picker for PhoneCountryCode

#Preview
<img src="https://raw.github.com/Dwarven/PhoneCountryCodePicker/master/Screenshots/en.png" width="230" align="center" style="margin:10px">
<img src="https://raw.github.com/Dwarven/PhoneCountryCodePicker/master/Screenshots/cn.png" width="230" align="center" style="margin:10px">
<img src="https://raw.github.com/Dwarven/PhoneCountryCodePicker/master/Screenshots/result.png" width="230" align="center" style="margin:10px">

# Podfile
To integrate PhoneCountryCodePicker into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'PhoneCountryCodePicker'
```

# How to use 

```obj-c
#import "PCCPViewController.h"

//first
NSDictionary * countryDic = [PCCPViewController infoFromSimCardAndiOSSettings];
//or
NSDictionary * countryDic = [PCCPViewController infoForPhoneCode:86]; //86 just for China

UIImage * flag = [PCCPViewController imageForCountryCode:countryDic[@"country_code"]];
NSLog(@"%@", countryDic);

//second
PCCPViewController * vc = [[PCCPViewController alloc] initWithCompletion:^(id countryDic) {
    NSLog(@"%@", countryDic);
    UIImage * flag = [PCCPViewController imageForCountryCode:countryDic[@"country_code"]];
}];
[vc setIsUsingChinese:YES or NO];
UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
[self presentViewController:naviVC animated:YES completion:NULL];
```
