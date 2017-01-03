/* brushlib - The MyPaint Brush Library
 * Copyright (C) 2007-2008 Martin Renold <martinxyz@gmx.ch>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY. See the COPYING file for more details.
 */


#import <Cocoa/Cocoa.h>
#import "MyPaintSurface.h"

@interface MyPaintBrush : NSObject <NSCopying> {
	NSValue *_brushHolder;
}
+(int)brushStatesCount;
-(BOOL)isPreview;
-(void)setIsPreview:(BOOL)val;
-(BOOL)strokeTo:(NSPoint)point pressure:(float)pressure dTime:(double)dtime surface:(MyPaintSurface *)surface;
-(double)getActualRadius;
-(void)newStroke;
-(void)setBaseValueOfID:(int)bID toValue:(float)value;
-(float)getBaseValueOfID:(int)bID;
-(void)setMappingNumberOfID:(int)bID input:(int)input number:(int)n;
-(void)setMappingPointOfID:(int)bID input:(int)input index:(int)index xy:(NSPoint)xy;
-(NSValue *)_brushHolder;
-(void)setStateOfID:(int)sid toValue:(float)value;
-(float)angle;
-(void)setAngle:(float)newAngle;
-(float)getStateOfID:(int)sid;

@end
