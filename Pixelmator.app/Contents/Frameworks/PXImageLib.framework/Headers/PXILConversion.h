//
//  PXILConversion.h
//  PXImageLib
//
//  Created by Aidas Dailide on 2008-11-17.
//  Copyright 2008 Pixelmator Team Ltd.. All rights reserved.
//

#ifndef PXIL_CONVERSION_H_INCLUDED
#define PXIL_CONVERSION_H_INCLUDED

#import <Cocoa/Cocoa.h>
#import <Accelerate/Accelerate.h>
#import "PXImageLib/PXILTypes.h"


typedef enum PXILReduceBitsTypes
{
	PXILReduceBitsNone,
	PXILReduceBitsStucki,
	PXILReduceBitsFloidSteinberg,
	PXILReduceBitsJJN,
	PXILReduceBitsBayer
} PXILReduceBitsType;

@interface PXILConversion : NSObject {
}
+(PXILConversion *)sharedInstance;
-(BOOL)imageLibConvertARGBtoBGRA:( const vImage_Buffer *)src;
-(BOOL)imageLibAddRandomGaussian:(const vImage_Buffer *)src mean:(int)mean stDev:(int)stDev pSeed:(unsigned int)pSeed;
-(BOOL)imageLibAddRandomGaussianInteger:(const vImage_Buffer *)src mean:(int)mean stDev:(int)stDev pSeed:(unsigned int)pSeed;
-(BOOL)imageLibAddRandomGaussianFloat:(const vImage_Buffer *)src mean:(int)mean stDev:(int)stDev pSeed:(unsigned int)pSeed;
-(BOOL)imageLibReduceBits:( const vImage_Buffer *)dest noise:(int)noise levels:(int)levels reduceType:(PXILReduceBitsType)_type;

-(BOOL)imageLibGetMinimumValuesFromRGBA888:(const vImage_Buffer *)src minValues:(unsigned char *)minValues;

-(BOOL)imageLibCopyRGBA8888:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;
-(BOOL)imageLibCopyRGBA8888:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest multithreadOptions:(PXILMultithreadOptions)multithreadOptions;
-(BOOL)imageLibCopyRGBA16:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;
-(BOOL)imageLibCopyRGBA16:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest multithreadOptions:(PXILMultithreadOptions)multithreadOptions;
-(BOOL)imageLibCopyRGBA:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest multithreadOptions:(PXILMultithreadOptions)multithreadOptions bitsPerChannel:(NSUInteger)bitsPerChannel;
-(BOOL)imageLibCopyPlanar8:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;

-(BOOL)imageLibCopyPlanar8ToRGBA8888:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;

-(BOOL)imageLibMultiplyAndScaleRGBA8888:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;
-(BOOL)imageLibMultiplyAndScalePlanar8:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;

-(BOOL)imageLibConvertARGBtoBGRA8888:(const vImage_Buffer *)src;
-(BOOL)imageLibSwapChannels:(const vImage_Buffer *)src destination:(const vImage_Buffer *)dest order:(int *)order;

-(BOOL)imageLibInvertBuffer:(vImage_Buffer *)src;

-(BOOL)imageLibThresholdGreaterPlanar:(vImage_Buffer *)src threshold:(unsigned char)threshold newValue:(unsigned char)value;

-(BOOL)imageLibSetPlanar8:(vImage_Buffer *)src toValue:(unsigned char)value;

-(BOOL)imageLibCopyRGBA8888SelectedChannel:(vImage_Buffer *)src toDest:(vImage_Buffer *)dest;


-(BOOL)imageLibAbsDiffBufferOne:(vImage_Buffer *)src1 bufferTwo:(vImage_Buffer *)src2 dest:(vImage_Buffer *)dest;

-(BOOL)imageLibMaxEveryBuffer:(vImage_Buffer *)src toDest:(vImage_Buffer *)dest;
-(BOOL)imageLibSetRGBA8888:(vImage_Buffer *)src toValue:(unsigned char[4])value;
-(BOOL)imageLibMultiplyPlanar8:(vImage_Buffer *)src byValue:(unsigned char)value;

-(BOOL)imageLibGetMinimumValueFromPlanar8:(vImage_Buffer *)src minValue:(unsigned char *)minValue;
-(BOOL)imageLibGetMaximumValueFromPlanar8:(vImage_Buffer *)src maxValue:(unsigned char *)minValue;

-(BOOL)imageLibCompositeOverPremultipliedRGBASource:(vImage_Buffer *)src toDest:(vImage_Buffer *)dest;

/**
 *  Converts 8 bits (4 channels) image buffer into 16 bits (4 channels) image buffer.
 *  Channels remain unpermuted.
 *
 *  @param src      the buffer with the source image data which has to be in 8 bits per component format
 *  @param dest     the buffer with the dat for destination image which has to be in 16 bits per component format
 *  @return         YES if conversion was successful, NO otherwise
 */
-(BOOL)imageLibConvert8888Uto16U:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;

/**
 *  Converts 8 bits image buffer in BGRA format into 16 bits image buffer in RGBA format.
 *
 *  @param src      the buffer with the source image data which has to be in 8 bits per component format
 *  @param dest     the buffer with the dat for destination image which has to be in 16 bits per component format
 *  @return         YES if conversion was successful, NO otherwise
 */
-(BOOL)imageLibConvertBGRA8toRGBA16:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;

/**
 *  Converts 16 bits (4 channels) image buffer into 8 bits (4 channels) image buffer.
 *  Channels remain unpermuted.
 *
 *  @param src      the buffer with the source image data which has to be in 16 bits per component format
 *  @param dest     the buffer with the dat for destination image which has to be in 8 bits per component format
 *  @return         YES if conversion was successful, NO otherwise
 */
-(BOOL)imageLibConvert16Uto8888U:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;

/**
 *  Converts 16 bits image buffer in RGBA format into 8 bits image buffer in BGRA format.
 *
 *  @param src      the buffer with the source image data which has to be in 16 bits per component format
 *  @param dest     the buffer with the dat for destination image which has to be in 8 bits per component format
 *  @return         YES if conversion was successful, NO otherwise
 */
-(BOOL)imageLibConvertRGBA16toBGRA8:(const vImage_Buffer *)src dest:(const vImage_Buffer *)dest;

@end

#endif//PXIL_CONVERSION_H_INCLUDED