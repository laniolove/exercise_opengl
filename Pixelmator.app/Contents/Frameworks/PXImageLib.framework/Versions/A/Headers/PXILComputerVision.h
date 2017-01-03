//
//  PXILComputerVision.h
//  PXImageLib
//
//  Created by Aidas Dailide on 2010-11-16.
//  Copyright 2010 Pixelmator Team Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Accelerate/Accelerate.h>

@interface PXILComputerVision : NSObject {

}
+(PXILComputerVision *)sharedInstance;

-(BOOL)floodFillGetSize_Grad:(NSSize)size bufSize:(int *)bufSize;
-(BOOL)floodFillRange4ConPlanar:(vImage_Buffer *)imageBuffer seedPoint:(NSPoint)seedPoint newVal:(unsigned char)newVal minDelta:(unsigned char)minDelta maxDelta:(unsigned char)maxDelta filledRegion:(NSRect *)filledRegion tempBuffer:(unsigned char*)pBuffer;
@end
