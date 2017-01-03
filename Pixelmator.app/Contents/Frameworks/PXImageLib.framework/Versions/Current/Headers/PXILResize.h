//
//  PXILResize.h
//  PXImageLib
//
//  Created by Aidas Dailide on 2008-10-23.
//  Copyright 2008 Pixelmator Team Ltd.. All rights reserved.
//

#ifndef PXIL_RESIZE_H_INCLUDED
#define PXIL_RESIZE_H_INCLUDED

#import <Cocoa/Cocoa.h>
#import <Accelerate/Accelerate.h>
#import <PXImageLib/PXILTypes.h>

typedef struct PXILPerspectiveQuad_ {
    CGPoint topLeft;
    CGPoint topRight;
    CGPoint bottomLeft;
    CGPoint bottomRight;
    
} PXILPerspectiveQuad;

extern NSString* NSStringFromPXILPerspectiveQuad(PXILPerspectiveQuad quad);

typedef enum PXILResizeInterpolationModes
	{
		PXILResizeNearestNeighbor,
		PXILResizeLinear,
		PXILResizeCubic,
		PXILResizeSupersample,
		PXILResizeLanczos3,
		PXILResizeLanczos5,
		PXILResizeAppleLanczos3,
		PIXLResizeAppleNone,
		PIXLResizeAppleLow,
		PIXLResizeAppleMedium,
		PIXLResizeAppleHigh,
	} PXILResizeInterpolationMode;

@interface PXILResize : NSObject {

}

+(PXILResize *)sharedInstance;
-(BOOL)imageLibScaleRGBA8888:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest interpolationMode:(PXILResizeInterpolationMode)iMode;
-(BOOL)imageLibScaleRGBA8888:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest interpolationMode:(PXILResizeInterpolationMode)iMode multiThreadOptions:(PXILMultithreadOptions)aMultiThreadedOptions;
-(BOOL)imageLibScaleRGBA16:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest interpolationMode:(PXILResizeInterpolationMode)iMode;
-(BOOL)imageLibScaleRGBA16:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest interpolationMode:(PXILResizeInterpolationMode)iMode multiThreadOptions:(PXILMultithreadOptions)aMultiThreadedOptions;
-(BOOL)imageLibScaleRGBA:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest interpolationMode:(PXILResizeInterpolationMode)iMode multiThreadOptions:(PXILMultithreadOptions)aMultiThreadedOptions bitsPerChannel:(NSUInteger)bitsPerChannel;
-(BOOL)imageLibScalePlanar8:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest interpolationMode:(PXILResizeInterpolationMode)iMode;
-(BOOL)imageLibAffineWarpIntelPlanar8:( const vImage_Buffer *)src destination:(const vImage_Buffer*)dest interpolationMode:(PXILResizeInterpolationMode)iMode transform:(vImage_AffineTransform)tr;

/**
 * Performs perspective warp (transform) of the image buffer.
 * @param quad Vertex coordinates of quadrangle according which perspective transform should be performed.
 *             Coordinates should be in such space that {0, 0} should be at top left.
 * @param bounds On success will contain new image buffer bounds in quad space.
 *                {0, 0} point will be at top left.
 * @param interpolationMode Intrepolation mode which should be used for warp.
 *                          Supported modes: PXILResizeNearestNeighbor
 *                                           PXILResizeLinear   
 *                                           PXILResizeCubic
 **/
-(BOOL)imageLibPerspectiveWarpRGBA8888:(const vImage_Buffer *)src
                           destination:(vImage_Buffer*)dest
                                  quad:(const PXILPerspectiveQuad*)quad
                     interpolationMode:(PXILResizeInterpolationMode)iMode
                              bounds:(CGRect*)bounds;

-(BOOL)imageLibAffineTransformMatrixFrom:(const PXILPerspectiveQuad *)normalizedQuad sourceWidth:(unsigned int)sourceWidth sourceHeight:(unsigned int)sourceHeight toMatrix:(vImage_AffineTransform *)affineTransform;

-(BOOL)imageLibRotateIntelPlanar8:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest interpolationMode:(PXILResizeInterpolationMode)iMode angle:(float)angle;

/**
 *  Rotates the images by the specified angle (counterclockwise for positive angle values).
 *
 *  @param src                  the source buffer with the data which has to be rotated
 *  @param dest                 the destination buffer where the rotated data has to be written
 *  @param iMode                the interpolation mode to be used by the algorithm
 *  @param angle                the number of degress the images has to be rotated
 *  @param bitsPerChannel       the number of bits per each channel of the pixel
 */
-(BOOL)imageLibRotateRGBA:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest interpolationMode:(PXILResizeInterpolationMode)iMode angle:(float)angle bitsPerChannel:(NSUInteger)bitsPerChannel;

-(BOOL)imageLibScaleRGBA8888:(const vImage_Buffer *)src destination:(const vImage_Buffer *)dest interpolationMode:(PXILResizeInterpolationMode)iMode sourceROI:(NSRect)sourceROI destinationROI:(NSRect)destinationROI bufferCallback:(SEL)bufferCallback owner:(id)owner;

/**
 *  Flips the image by reflecting it along the vertical axis.
 *
 *  @param src                  the source image which has to be flipped
 *  @param dest                 the destination image where flipped image has to be written
 *  @param bitsPerChannel       the number of bits per each channel of the pixel
 */
-(BOOL)imageLibFlipRGBA:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest bitsPerChannel:(NSUInteger)bitsPerChannel;

/**
 *  Flops the image by reflecting it along the horizontal axis.
 *
 *  @param src                  the source image which has to be flopped
 *  @param dest                 the destination image where flopped image has to be written
 *  @param bitsPerChannel       the number of bits per each channel of the pixel
 */
-(BOOL)imageLibFlopRGBA:( const vImage_Buffer *)src destination:(const vImage_Buffer *)dest bitsPerChannel:(NSUInteger)bitsPerChannel;

@end

#endif//!PXIL_RESIZE_H_INCLUDED
