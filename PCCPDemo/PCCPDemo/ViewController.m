//
//  ViewController.m
//  PCCPDemo
//
//  Created by 杨建亚 on 15/5/15.
//  Copyright (c) 2015年 Dwarven. All rights reserved.
//

#import "ViewController.h"
#import "PCCPViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateViewsWithCountryDic:[PCCPViewController infoFromSimCardAndiOSSettings]];
    NSMutableString * defalultInfo = [[_textField text] mutableCopy];
    [defalultInfo  appendString:@"\n\nAs Default!"];
    [_textField setText:defalultInfo];
}

- (IBAction)pick:(id)sender {
    PCCPViewController * vc = [[PCCPViewController alloc] initWithCompletion:^(id countryDic) {
        [self updateViewsWithCountryDic:countryDic];
    }];
    [vc setIsUsingChinese:[_langSwitch selectedSegmentIndex] == 1];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naviVC animated:YES completion:NULL];
}

- (void)updateViewsWithCountryDic:(NSDictionary*)countryDic{
    [_textField setText:[NSString stringWithFormat:@"country_code: %@\ncountry_en: %@\ncountry_cn: %@\nphone_code: %@",countryDic[@"country_code"],countryDic[@"country_en"],countryDic[@"country_cn"],countryDic[@"phone_code"]]];
    [_imageView setImage:[PCCPViewController imageForCountryCode:countryDic[@"country_code"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
