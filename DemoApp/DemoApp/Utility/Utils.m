//
//  Utils.m
//  DemoApp
//
//  Created by user on 9/6/14.
//  Copyright (c) 2014 VolarVideo. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	[outputFormatter setTimeZone:[NSTimeZone localTimeZone]];			//display time in local time zone
	NSString *timestamp_str = [outputFormatter stringFromDate:date];
	return timestamp_str;
}

@end
