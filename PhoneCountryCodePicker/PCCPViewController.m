//
//  PCCPViewController.m
//  PCCPDemo
//
//  Created by 杨建亚 on 15/5/15.
//  Copyright (c) 2015年 Dwarven. All rights reserved.
//

#import "PCCPViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface PCCPViewController (){
    NSDictionary * _PCCs;
    NSArray * _keys;
    void(^_completion)(id);
}
@end

@implementation PCCPViewController

- (id)initWithCompletion:(void (^)(id))completion{
    self = [super init];
    if (self) {
        _completion = completion;
    }
    return self;
}

- (void)dealloc{
    _PCCs = nil;
    _keys = nil;
    _completion = NULL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    UIView *currentTitleView = [[self navigationItem] titleView];
    
    UIActivityIndicatorView *aiview = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:aiview]];
    [aiview startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * array = [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"phone_country_code" ofType:@"json"]
                                                                                                   encoding:NSUTF8StringEncoding
                                                                                                      error:NULL]
                                                                   dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:kNilOptions
                                                            error:nil];
        
        if (_isUsingChinese) {
            _PCCs = [self chineseSortWithDictionaryArray:array];
        }else{
            _PCCs = [self englishSortWithDictionaryArray:array];
        }
        _keys = [[_PCCs allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [aiview stopAnimating];
            [[self navigationItem] setTitleView:currentTitleView];
            
            [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:_isUsingChinese?@"取消":@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)]];
            
            [self.tableView reloadData];
        });
    });
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PCCs data for en

- (NSDictionary*)englishSortWithDictionaryArray:(NSArray*)dictionaryArray {
    NSMutableArray * sourceArray = [dictionaryArray mutableCopy];
    [sourceArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 objectForKey:@"country_en"] compare:[obj2 objectForKey:@"country_en"]];
    }];
    
    NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
    for (unichar firstChar = 'A'; firstChar <= 'Z'; firstChar ++) {
        [resultDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%C",firstChar]];
    }
    for (NSDictionary * dic in sourceArray) {
        [resultDic[[dic[@"country_en"] substringToIndex:1]] addObject:dic];
    }
    for (NSString * key in [resultDic allKeys]) {
        if ([resultDic[key] count] == 0) {
            [resultDic removeObjectForKey:key];
        }
    }
    return resultDic;
}

#pragma mark - PCCs data for cn

- (NSDictionary*)chineseSortWithDictionaryArray:(NSArray*)dictionaryArray {
    if (dictionaryArray == nil) {
        return nil;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [dictionaryArray count] ; i++) {
        if (![[dictionaryArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:[dictionaryArray objectAtIndex:i], @"info", [self chineseStringTransformPinyin:[[dictionaryArray objectAtIndex:i] objectForKey:@"country_cn"]], @"pinyin", nil];
        [tempArray addObject:tempDic];
    }
    // 排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 objectForKey:@"pinyin"] compare:[obj2 objectForKey:@"pinyin"]];
    }];
    
    NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
    for (unichar firstChar = 'A'; firstChar <= 'Z'; firstChar ++) {
        [resultDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%C",firstChar]];
    }
    for (NSDictionary * dic in tempArray) {
        [resultDic[[dic[@"pinyin"] substringToIndex:1]] addObject:dic[@"info"]];
    }
    for (NSString * key in [resultDic allKeys]) {
        if ([resultDic[key] count] == 0) {
            [resultDic removeObjectForKey:key];
        }
    }
    return resultDic;
}

- (NSString*) chineseStringTransformPinyin: (NSString*)chineseString {
    if (chineseString == nil) {
        return nil;
    }
    // 拼音字段
    NSMutableString *tempNamePinyin = [chineseString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)tempNamePinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)tempNamePinyin, NULL, kCFStringTransformStripDiacritics, NO);
    return tempNamePinyin.uppercaseString;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_PCCs) {
        return [_PCCs count];
    }
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_PCCs) {
        return [[_PCCs valueForKey: [_keys objectAtIndex:section]] count];
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_keys objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    if (_PCCs) {
        NSDictionary * countryDic = [_PCCs valueForKey:[_keys objectAtIndex:[indexPath section]]][indexPath.row];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:15]];
        if (_isUsingChinese) {
            [[cell textLabel] setText:countryDic[@"country_cn"]];
        }else{
            [[cell textLabel] setText:countryDic[@"country_en"]];
        }
        [[cell imageView] setImage:[PCCPViewController imageForCountryCode:countryDic[@"country_code"]]];
        return cell;
    }
    return cell;;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _completion([_PCCs valueForKey:[_keys objectAtIndex:[indexPath section]]][indexPath.row]);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

+ (UIImage *)imageForCountryCode:(NSString *)code{
    NSNumber * y = [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flag_indices" ofType:@"json"]
                                                                                            encoding:NSUTF8StringEncoding
                                                                                               error:NULL]
                                                            dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:kNilOptions
                                                     error:nil][code];
    if (!y) {
        y = @0;
    }
    CGImageRef cgImage = CGImageCreateWithImageInRect([[UIImage imageNamed:@"flags"] CGImage], CGRectMake(0, y.integerValue * 2, 32, 32));
    UIImage * result = [UIImage imageWithCGImage:cgImage scale:2.0 orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    return result;
}

+ (id)infoFromSimCardAndiOSSettings{
    
    NSArray * array = [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"phone_country_code" ofType:@"json"]
                                                                                               encoding:NSUTF8StringEncoding
                                                                                                  error:NULL]
                                                               dataUsingEncoding:NSUTF8StringEncoding]
                                                      options:kNilOptions
                                                        error:nil];
    
    NSString * carrierIsoCountryCode = [[[[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider] isoCountryCode] uppercaseString];
    
    id(^getCountryDic)(NSString*) = ^(NSString * code){
        id result = nil;
        if (code) {
            for (NSDictionary * dic in array) {
                if ([dic[@"country_code"] isEqualToString:code]) {
                    result = dic;
                    break;
                }
            }
        }
        return result;
    };
    
    id info = getCountryDic(carrierIsoCountryCode);
    if (!info) {
        info = getCountryDic([[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] uppercaseString]);
    }
    return info;
}

@end
