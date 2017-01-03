//
//  PXGLVertexShader.vsh
//  Pixelmator
//
//  Created by rokas on 04/04/14.
//  Copyright (c) 2014 Pixelmator Team Ltd. All rights reserved.
//

//#version 120    // the lowest GLSL version supported by GPUs with SDK v10.9 using OpenGL Legacy Profile
#version 330  // the lowest GLSL version supported by GPUs with SDK v10.9 using OpenGL Core Profile

// transformation matrix for each frame
uniform mat4 modelViewProjectionMatrix;

#if __VERSION__ >= 330
// vertex attributes
layout (location = 0) in vec3 inPosition;
layout (location = 1) in vec4 inColor;
layout (location = 2) in vec2 inTexCoord;

// vertex shader output for fragment shader
out vec4 color;
out vec2 texCoord;
#else
attribute vec3 inPosition;
attribute vec4 inColor;
attribute vec2 inTexCoord;

varying vec4 color;
varying vec2 texCoord;
#endif

void main()
{
    gl_Position = modelViewProjectionMatrix * vec4(inPosition, 1.0);
    color = inColor;
    texCoord = inTexCoord;
}
