//
//  PXILResynthesize.h
//  PXImageLib
//
//  Created by Aidas Dailide on 2011-09-07.
//  Copyright 2011 Pixelmator Team Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "imageBuffer.h"
#import "engineParams.h"
#import "imageFormat.h"

@interface PXILResynthesize : NSObject {

}
+(int)imageSynth:(ImageBuffer * )imageBuffer  // IN/OUT RGBA Pixels described by imageFormat
mask:(ImageBuffer * )mask         // IN one mask Pixelel
imageFormat:(TImageFormat)imageFormat
parameters:(TImageSynthParameters *)parameters
callback:(void *)progressCallback  // int percentDone, void *contextInfo
contextInfo:(void *)contextInfo
cancelFlag:(int *)cancelFlag;
				

@end
