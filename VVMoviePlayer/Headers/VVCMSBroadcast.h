//
//  VVCMSBroadcast.h
//  mobileapidev
//
//  Created by Benjamin Askren on 1/18/13.
//  Copyright (c) 2013 42nd Parallel. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef NS_ENUM
typedef NS_ENUM(NSInteger, VVCMSBroadcastStatus) {
    VVCMSBroadcastStatusUnknown,
    VVCMSBroadcastStatusScheduled,
    VVCMSBroadcastStatusStreaming,
    VVCMSBroadcastStatusStopped,
    VVCMSBroadcastStatusTest,
    VVCMSBroadcastStatusArchived,
    VVCMSBroadcastStatusAll    // used for requests to CMS, never returned
} ;
#endif

/**
 \brief Parameters to use when querying for VVCMSBroadcast
 */
@interface BroadcastParams : NSObject

-(NSString*) applyParams:(NSString*)url;

@property(nonatomic,readwrite,assign) VVCMSBroadcastStatus status;
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

#define kKeyBroadcastStatus           @"status"
#define kKeyBroadcastStatusScheduled  @"scheduled"
#define kKeyBroadcastStatusStreaming  @"streaming"
#define kKeyBroadcastStatusStopped    @"stopped"
#define kKeyBroadcastStatusTest       @"test"
#define kKeyBroadcastStatusTesting    @"testing"
#define kKeyBroadcastStatusArchived   @"archived"
#define kKeyBroadcastID               @"id"
#define kKeyBroadcastSection          @"section"
#define kKeyBroadcastTitle            @"title"
#define kKeyBroadcastDescr            @"description"
#define kKeyBroadcastURL              @"vmap"
#define kKeyBroadcastVMAPURL          @"vmap"
#define kKeyBroadcastThumbURL         @"thumbnail"
#define kKeyBroadcastStartDate        @"start_date"
#define kKeyBroadcastEditDate         @"edit_date"
#define kKeyBroadcastRating           @"rating"
#define kKeyBroadcastAudioOnly        @"audioOnly"
#define kKeyBroadcastProgress         @"progress"
#define kKeyBroadcastAuthorDict       @"author"
#define kKeyAuthorDictName            @"full_name"
#define kKeyBroadcastIsStreaming      @"isStreaming"

/**
 \brief A wrapper for a broadcast returned from VVCMSAPI
 */
@interface VVCMSBroadcast : NSObject

-(id) initWithDictionary:(NSDictionary*)dict;

/*! VolarVideo broadcast ID number */
@property(nonatomic,readonly,strong) NSNumber *ID;

/*! VolarVideo broadcast section ID number */
@property(nonatomic,readonly,strong) NSNumber *sectionID;

/*! Title of broadcast */
@property(nonatomic,readonly,strong) NSString *title;

/*! Description of broadcast */
@property(nonatomic,readonly,strong) NSString *description;

/*! Stream Status */
@property(nonatomic,readonly,assign) VVCMSBroadcastStatus status;

/*! URL where a thumbnail version of the broadcast's Poster can be found */
@property(nonatomic,readonly,strong) NSString *thumbnailURL;

/*! Date at which the broadcast is (was) scheduled to start */
@property(nonatomic,readonly,strong) NSDate *startDate;

/*! Last date at which the broadcast or its meta data was changed */
@property(nonatomic,readonly,strong) NSDate *editDate;

/*!
 Average rating of this broadcast
 
 #### Availability
 NOT YET AVAILABLE
 */
@property(nonatomic,readonly,assign) double rating;

/*! YES if broadcast is only available as an audio stream */
@property(nonatomic,readonly,assign) BOOL audioOnly;

/*!
 The last known viewing position in the broadcast for the currently authenticated user
 
 #### Availability
 NOT YET AVAILABLE
 */
@property(nonatomic,readonly,assign) double progress;

/*! The content creator / owner */
@property(nonatomic,readonly,strong) NSString *authorName;

/*! YES if the broadcast is live streaming */
@property(nonatomic,readonly,assign) BOOL isStreaming;

/*! URL where the iframe embed can be found */
@property(nonatomic,readonly,strong) NSString *embedURL;

/*!
 String representing URL of VolarExtended VMAP of broadcast.  Pass this string to [VVMoviePlayerViewController initWithExtendedVMAPURIString:], [VVMoviePlayerViewController initAndStartWithExtendedVMAPURIString:], [VVMoviePlayerController initWithExtendedVMAPURIString:], or [VVMoviePlayerController initAndStartWithExtendedVMAPURIString:] to initialize a VolarVideo broadcast for playback as a movie.
 */
@property(nonatomic,readonly,strong) NSString *vmapURL;


@end
