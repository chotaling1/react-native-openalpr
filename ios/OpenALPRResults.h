//
//  OpenALPRResults.h
//  OpenALPR
//
//  Created by Chuck.Hotaling on 7/29/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenALPRResults : NSObject

@property (nonatomic) bool isError;
@property (nonatomic, strong) NSArray *Plates;
@end

NS_ASSUME_NONNULL_END
