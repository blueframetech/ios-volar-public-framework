//
//  VVMediaCell.m

//
//  Created by Benjamin Askren on 9/20/12.
//  Copyright (c) 2012 Benjamin Askren. All rights reserved.
//

#import "VVMediaCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VVMediaCell

@synthesize read,favorite,description,meta1,meta2,imgThumb,type,title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setTitle:(NSString *)t {
    if (![title isEqualToString:t]) {
        title = t;
        lblTitle.text = t;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDescription:(NSString *)str {
    if (![description isEqualToString:str]) {
        //description = str;
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
        description = [NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %i\">%@</span>",
                      font.fontName,
                      (int) font.pointSize,
                      str];
        [self.wvDescription loadHTMLString:description baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        [self.wvDescription setBackgroundColor:[UIColor clearColor]];
        [self.wvDescription setOpaque:NO];
    }
}

- (void) setMeta1:(NSString *)str {
    meta1 = str;
    lblMeta1.text = meta1;
}

- (void) setMeta2:(NSString *)str {
    meta2 = str;
    lblMeta2.text = meta2;
}

- (void) setDisabled:(BOOL)disabled {
    UIColor *color = [UIColor blackColor];
    if (disabled)
        color = [UIColor darkGrayColor];
    lblMeta1.textColor = color;
}

-(void) setType:(enum VVMediaCellType)t {
    type = t;
}
- (UIImage *) galleryThumbnailOfImage:(UIImage *)img {
    float imgW    = img.size.width;
    float imgH    = img.size.height;
    float imgR  = imgH/imgW;
    
    float frameX,frameY,frameH,frameW,frameR;
    UIImage *template;
    if (imgR==1) {
        // portrait
        template = [UIImage imageNamed:@"galleryTemplate"];
        frameX = 21;
        frameY = 15;
        frameW = 85-frameX;
        frameH = 75-frameY;
        frameR = frameH/frameW;
    } else if (imgR>1) {
        // portrait
        template = [UIImage imageNamed:@"galleryTemplatePortrait"];
        frameX = 24;
        frameY = 17;
        frameW = 85-frameX;
        frameH = 102-frameY;
        frameR = frameH/frameW;
    } else {
        // lanscape
        template = [UIImage imageNamed:@"galleryTemplateLandscape"];
        frameX = 17;
        frameY = 24;
        frameW = 102-frameX;
        frameH = 85-frameY;
        frameR = frameH/frameW;
    }
    if (imgR>frameR) {
        // image is more portrait than frame so have to shrink width
        int newFrameW = frameH/imgR;
        int newFrameX = frameX + frameW/2.0 - newFrameW/2.0;
        frameX = newFrameX;
        frameW = newFrameW;
    } else  {
        // image is more landscape than frame so have to shrink height
        int newFrameH = frameW*imgR;
        int newFrameY = frameY + frameH/2.0 - newFrameH/2.0;
        frameY = newFrameY;
        frameH = newFrameH;
    }
    UIGraphicsBeginImageContext(template.size);
    [template drawAtPoint:CGPointMake(0, 0)];
    CGRect frame = CGRectMake(frameX, frameY, frameW, frameH);
    [img drawInRect:frame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *) imageWithRoundedCorners:(UIImage *) img {
    if (!img) return nil;
    
    float frameW  = imgThumb.frame.size.width;
    float frameH  = imgThumb.frame.size.height;
    float frameR = frameH/frameW;

    float imgW    = img.size.width;
    float imgH    = img.size.height;
    float imgR  = imgH/imgW;

    float deltaW  = frameW - imgW;
    float deltaH  = frameH - imgH;
    
    float h=0,w=0;
    

    if (deltaH<0 || deltaW<0) {
        //there is a negative delta: we have to shrink image
        if (imgR>frameR) {
            // img is more portrait than frame
            h = frameH;
            w = round(frameH/imgR);
        } else {
            // img is more landscape than frame
            w = frameW;
            h = round(frameW*imgR);
        }
    } else {
        //only positive deltas: no change to the size of the image
        h = imgH;
        w = imgW;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h),FALSE,0.0);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGRect rrect = CGRectMake(0, 0, w, h);
    CGContextFillRect(context, rrect);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
    CGFloat radius = MIN(h,w)*0.1;
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    //CGContextDrawPath(context, kCGPathFill);
    CGContextFillPath(context);
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return maskImage;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h),FALSE,0.0);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return newImg;
    
    CGImageRef maskRef = [maskImage CGImage];
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    //return [UIImage imageWithCGImage:mask];
    
    CGImageRef masked = CGImageCreateWithMask([newImg CGImage], mask);
    UIImage *rcImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    CGImageRelease(mask);
    return rcImage;
    
}

@end
