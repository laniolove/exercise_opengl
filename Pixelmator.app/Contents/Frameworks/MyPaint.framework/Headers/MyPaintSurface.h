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


@interface MyPaintSurface : NSObject {
	NSValue *_surface;
}
-(void)getColorForPoint:(NSPoint)point radius:(float)radius red:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a;
-(BOOL)drawAtPoint:(NSPoint)point radius:(float)radius r:(float)color_r g:(float)color_g b:(float)color_b opaque:(float)opaque hardness:(float)hardness alpha_eraser:(float)alpha_eraser;
-(void *)_surface;
@end
