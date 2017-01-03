//
//  PXILHash.h
//  PXImageLib
//
//  Created by Aidas Dailide on 2010-10-25.
//  Copyright 2010 Pixelmator Team Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Accelerate/Accelerate.h>

@interface PXILHash : NSObject {

}
+(PXILHash *)sharedInstance;
-(NSString *)imageLibComputeFastestChecksumForData:(unsigned char *)srcData sourceLength:(int)sourceLength;
@end
