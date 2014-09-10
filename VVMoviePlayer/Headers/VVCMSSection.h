//
//  VVCMSSection.h
//  VVMoviePlayer
//
//  Created by user on 7/16/14.
//  Copyright (c) 2014 VolarVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 \brief Parameters to use when querying for VVCMSSection
 */
@interface SectionParams : NSObject

-(NSString*) applyParams:(NSString*)url;

@property(nonatomic,readwrite,strong) NSString *sites;
@property(nonatomic,readwrite,strong) NSString *title;
@property(nonatomic,readwrite,strong) NSNumber *ID;
@property(nonatomic,readwrite,strong) NSNumber *page;
@property(nonatomic,readwrite,strong) NSNumber *resultsPerPage;

@end

#define kKeyID      @"id"
#define kKeyTitle   @"title"

/**
 \brief A wrapper for a section returned from VVCMSAPI
 */
@interface VVCMSSection : NSObject

-(id) initWithDictionary:(NSDictionary*)dict;

/*! VolarVideo section ID number */
@property(nonatomic,readonly,strong) NSNumber *ID;

/*! Title of section */
@property(nonatomic,readonly,strong) NSString *title;

@end
