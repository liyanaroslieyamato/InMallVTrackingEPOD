//
//  Tenant.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 24/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tenant : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * contact;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * postal_code;
@property (nonatomic, strong) NSString * qr_code;
@property (nonatomic, strong) NSString * remarks;
@property (nonatomic, strong) NSString * b2b_code;
@property (nonatomic, strong) NSString * unit_num;
@property (nonatomic, strong) NSString * shop_code;

@end
