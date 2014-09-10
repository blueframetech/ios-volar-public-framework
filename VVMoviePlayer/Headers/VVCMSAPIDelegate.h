//
//  VVCMSAPIDelegate.h
//  VVMoviePlayer
//
//  Created by Benjamin Askren on 6/7/13.
//  Copyright (c) 2013 Zach Freeman. All rights reserved.
//

#ifndef VVMoviePlayer_VVCMSAPIDelegate_h
#define VVMoviePlayer_VVCMSAPIDelegate_h

@class VVCMSAPI;

/*!
 \brief Response handlers for asynchronous VVCMSAPI calls.
 */
@protocol VVCMSAPIDelegate <NSObject>
@optional

/*!
 Completion method for credential validation
 @param vvapi The instance of VVCMSAPI used to make the request
 @param error An error detailing what went wrong (or nil if no error)
 */
- (void)VVCMSAPI:(VVCMSAPI *)vvapi checkCredentialsCompleteWithError:(NSError *)error;

/*!
 Completion method for sites list requests
 @param vvapi The instance of VVCMSAPI used to make the request
 @param sites An array of VVCMSSite
 @param page The requested page
 @param totalPages The total number of pages with the specified results per page
 @param totalResults The total number of result regardless of the specified results per page
 @param error An error detailing what went wrong (or nil if no error)
 */
- (void)VVCMSAPI:(VVCMSAPI *)vvapi requestForSitesResult:(NSArray *)sites page:(int)page
      totalPages:(int)totalPages totalResults:(int)totalResults error:(NSError *)error;

/*!
 Completion method for broadcasts list requests
 @param vvapi The instance of VVCMSAPI used to make the request
 @param broadcasts An array of VVCMSBroadcast
 @param status The status of the broadcasts contained in the didFinishWithArray: parameter.
 @param page The requested page
 @param totalPages The total number of pages with the specified results per page
 @param totalResults The total number of result regardless of the specified results per page
 @param error An error detailing what went wrong (or nil if no error)
 */
- (void)VVCMSAPI:(VVCMSAPI *)vvapi requestForBroadcastsResult:(NSArray *)broadcasts
      withStatus:(VVCMSBroadcastStatus)status page:(int)page totalPages:(int)totalPages
      totalResults:(int)totalResults error:(NSError *)error;

/*!
 Completion method for slips list requests
 @param vvapi The instance of VVCMSAPI used to make the request
 @param clips An array of VVCMSClip
 @param page The requested page
 @param totalPages The total number of pages with the specified results per page
 @param totalResults The total number of result regardless of the specified results per page
 @param error An error detailing what went wrong (or nil if no error)
 */
- (void)VVCMSAPI:(VVCMSAPI *)vvapi requestForClipsResult:(NSArray *)clips page:(int)page
      totalPages:(int)totalPages totalResults:(int)totalResults error:(NSError *)error;

/*!
 Completion method for sections list requests
 @param vvapi The instance of VVCMSAPI used to make the request
 @param sections An array of VVCMSSection
 @param page The requested page
 @param totalPages The total number of pages with the specified results per page
 @param totalResults The total number of result regardless of the specified results per page
 @param error An error detailing what went wrong (or nil if no error)
 */
- (void)VVCMSAPI:(VVCMSAPI *)vvapi requestForSectionsResult:(NSArray *)sections page:(int)page
      totalPages:(int)totalPages totalResults:(int)totalResults error:(NSError *)error;

@end


#endif
