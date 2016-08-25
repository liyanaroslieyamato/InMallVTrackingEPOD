//
//  Order.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 20/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSString *web_id;
@property (nonatomic, strong) NSString *do_number;
@property (nonatomic, strong) NSString *order_type;
@property (nonatomic, strong) NSString *cod_amount;
@property (nonatomic, strong) NSString *exchange_code;
@property (nonatomic, strong) NSString *payment_term;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *receiver;
@property (nonatomic, strong) NSString *latest_status;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *sender_name;
@property (nonatomic, strong) NSString *sender_addr;
@property (nonatomic, strong) NSString *sender_contact_no;
@property (nonatomic, strong) NSString *sender_unit_no;
@property (nonatomic, strong) NSString *sender_postcode;
@property (nonatomic, strong) NSString *receiver_name;
@property (nonatomic, strong) NSString *receiver_addr;
@property (nonatomic, strong) NSString *receiver_contact_no;
@property (nonatomic, strong) NSString *receiver_unit_no;
@property (nonatomic, strong) NSString *receiver_postcode;

@end
