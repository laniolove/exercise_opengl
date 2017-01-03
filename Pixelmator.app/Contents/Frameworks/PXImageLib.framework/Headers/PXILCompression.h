//
//  PXILCompression.h
//  PXImageLib
//
//  Created by Aidas Dailide on 2010-05-24.
//  Copyright 2010 Pixelmator Team Ltd.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Accelerate/Accelerate.h>

@interface PXILCompression : NSObject {

}
+(PXILCompression *)sharedInstance;
-(int)intelDeflateInitStream:(void *)strm level:(int)level;
-(int)intelDeflateStream:(void *)strm flush:(int)flush;
-(void)intelDeflateEnd:(void *)strm;

-(unsigned char *)intelCompressRLE:(unsigned char *)inputData sourceLength:(size_t)sourceLength destinationLength:(size_t *)destLength;
-(int)intelDecompressRLE:(unsigned char *)sourceData sourceLength:(size_t)sourceLength destination:(unsigned char *)destBuffer destLength:(int)_destLen;

-(unsigned char *)intelCompressLZSS:(unsigned char *)inputData sourceLength:(size_t)sourceLength destinationLength:(size_t *)destLength;
-(int)intelDecompressLZSS:(unsigned char *)sourceData sourceLength:(size_t)sourceLength destination:(unsigned char *)destBuffer destLength:(int)_destLen;
@end

