//
//  VVCMSClip.h
//  VVMoviePlayer
//
//  Created by user on 7/16/14.
//  Copyright (c) 2014 VolarVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 \brief Parameters to use when querying for VVCMSClip
 */
@interface ClipParams : NSObject

-(NSString*) applyParams:(NSString*)url;

@property(nonatomic,readwrite,strong) NSString *sites;
@property(nonatomic,readwrite,strong) NSString *title;
@property(nonatomic,readwrite,strong) NSNumber *ID;
@property(nonatomic,readwrite,strong) NSNumber *sectionID;
@property(nonatomic,readwrite,strong) NSDate *after;
@property(nonatomic,readwrite,strong) NSDate *before;
@property(nonatomic,readwrite,strong) NSNumber *page;
@property(nonatomic,readwrite,strong) NSNumber *resultsPerPage;
@property(nonatomic,readwrite,strong) NSString *sortBy;
@property(nonatomic,readwrite,strong) NSString *sortDir;

@end

#define kKeyID                    @"id"
#define kKeyTitle                 @"title"
#define kKeyDescription           @"description"
#define kKeyEmbedURL              @"vmap"
#define kKeyVMAPURL               @"vmap"
#define kKeyThumbURL              @"thumbnail"
#define kKeyBroadcastEditDate     @"edit_date"
#define kKeyBroadcastRating       @"rating"
#define kKeyBroadcastAudioOnly    @"audioOnly"
#define kKeyBroadcastAuthorDict   @"author"
#define kKeyAuthorDictName        @"full_name"

/**
 \brief A wrapper for a clip returned from VVCMSAPI
 */
@interface VVCMSClip : NSObject

-(id) initWithDictionary:(NSDictionary*)dict;

/*! VolarVideo clip ID number */
@property(nonatomic,readonly,strong) NSNumber *ID;

/*! Title of clip */
@property(nonatomic,readonly,strong) NSString *title;

/*! Description of clip */
@property(nonatomic,readonly,strong) NSString *description;

/*! URL where a thumbnail version of the clip's Poster can be found */
@property(nonatomic,readonly,strong) NSString *thumbnailURL;

/*! Date at which the clip was last edited */
@property(nonatomic,readonly,strong) NSDate *editDate;

/*!
 Average rating of this broadcast
 
 #### Availability
 NOT YET AVAILABLE
 */
@property(nonatomic,readonly,assign) double rating;

/*! YES if broadcast is only available as an audio stream */
@property(nonatomic,readonly,assign) BOOL audioOnly;

/*! The content creator / owner */
@property(nonatomic,readonly,strong) NSString *authorName;

/*! URL where the iframe embed can be found */
@property(nonatomic,readonly,strong) NSString *embedURL;

/*!
 String representing URL of VolarExtended VMAP of broadcast.  Pass this string to [VVMoviePlayerViewController initWithExtendedVMAPURIString:], [VVMoviePlayerViewController initAndStartWithExtendedVMAPURIString:], [VVMoviePlayerController initWithExtendedVMAPURIString:], or [VVMoviePlayerController initAndStartWithExtendedVMAPURIString:] to initialize a VolarVideo broadcast for playback as a movie.
 */
@property(nonatomic,readonly,strong) NSString *vmapURL;

@end
