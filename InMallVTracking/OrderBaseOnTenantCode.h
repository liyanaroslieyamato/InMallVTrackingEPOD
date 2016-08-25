//
//  OrderBaseOnTenantCode.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 26/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderBaseOnTenantCode : NSObject

@property (nonatomic, strong) NSString * shop_id;
@property (nonatomic, strong) NSString * do_number;
@property (nonatomic, strong) NSString * order_type;
@property (nonatomic, strong) NSString * cod_amount;
@property (nonatomic, strong) NSString * exchange_code;
@property (nonatomic, strong) NSString * payment_term;
@property (nonatomic, strong) NSString * sender;
@property (nonatomic, strong) NSString * receiver;
@property (nonatomic, strong) NSString * latest_status;
@property (nonatomic, strong) NSString * principal_name;

@end
