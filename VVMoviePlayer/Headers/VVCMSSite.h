//
//  VVCMSSite.h
//  VVMoviePlayer
//
//  Created by user on 6/24/14.
//  Copyright (c) 2014 VolarVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 \brief Parameters to use when querying for VVCMSSite
 */
@interface SiteParams : NSObject

-(NSString*) applyParams:(NSString*)url;

@property(nonatomic,readwrite,strong) NSString *title;
@property(nonatomic,readwrite,strong) NSString *slug;
@property(nonatomic,readwrite,strong) NSNumber *ID;
@property(nonatomic,readwrite,strong) NSNumber *page;
@property(nonatomic,readwrite,strong) NSNumber *resultsPerPage;

@end

#define kKeyID        @"id"
#define kKeyTitle     @"title"
#define kKeySiteSlug  @"slug"

/**
 \brief A wrapper for a site returned from VVCMSAPI
 */
@interface VVCMSSite : NSObject

-(id) initWithDictionary:(NSDictionary*)dict;

/*! VolarVideo ection ID number */
@property(nonatomic,readonly,strong) NSNumber *ID;

/*! Title of section */
@property(nonatomic,readonly,strong) NSString *title;

/*! Shortname of section */
@property(nonatomic,readonly,strong) NSString *slug;

@end
