//
//  PXFragmentShader.vsh
//  Pixelmator
//
//  Created by rokas on 09/04/14.
//  Copyright (c) 2014 Pixelmator Team Ltd. All rights reserved.
//

//#version 120    // the lowest GLSL version supported by GPUs with SDK v10.9 using OpenGL Legacy Profile
#version 330  // the lowest GLSL version supported by GPUs with SDK v10.9 using OpenGL Core Profile

#if __VERSION__ < 330
#extension GL_EXT_gpu_shader4:require
#define texture texture2D
#define textureRect texture2DRect
#else
#define textureRect texture
#endif

#if __VERSION__ >= 330
in vec4 color;
in vec2 texCoord;
out vec4 fragmentColor;
#else
varying vec4 color;
varying vec2 texCoord;
varying out vec4 fragmentColor;
#endif

uniform sampler2D tex;
uniform sampler2DRect texRect;

void main()
{
    vec4 color2D = texture(tex, texCoord.st);
    vec4 color2DRect = textureRect(texRect, texCoord.st);
    
    // add the color values from both 2D and rectangle samplers
    // when one sampler is used the other one is set to transparent color by the app
    fragmentColor = clamp((color2D + color2DRect) * color, 0.0, 1.0);
}
