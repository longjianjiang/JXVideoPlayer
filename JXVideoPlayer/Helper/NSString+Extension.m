//
//  NSString+Extension.m
//  JXVideoPlayer
//
//  Created by zl on 2019/2/25.
//  Copyright © 2019 longjianjiang. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)timeMsgBySeconds:(NSUInteger)seconds {
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    if ([str_hour isEqualToString:@"00"]) {
        return [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }else{
        return [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }
}

@end
