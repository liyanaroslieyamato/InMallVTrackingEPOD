//
//  UviSignature.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 25/8/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocol definition starts here
@protocol UviSignatureViewDelegate <NSObject>
@required
- (void)shakeCompleted;
@end

@interface UviSignatureView : UIView {
    CGPoint previousPoint;
    UIBezierPath *signPath;
    NSMutableArray *pathArray;
    NSArray *backgroundLines;
}

@property (nonatomic, strong, nullable) UIColor *lineColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, readonly) BOOL signatureExists;
- (void)captureSignature;
- (void)erase;
- (UIImage*)signatureImage:(CGPoint)position text:(NSString*)text;

@end
