//
//  main.h
//  exercise_opengl
//
//  Created by freedragon on 22/01/2017.
//  Copyright © 2017 freedragon. All rights reserved.
//

#ifndef main_h
#define main_h

#include <iostream>
//using namespace std;
//Be sure to include GLEW before GLFW.
//The includes(like GL/gl.h),
//so include GLEW before other heade`r files that require OpenGL does the thick.
//GLEW
#define GLEW_STATIC // using the static version of the GLEW library
#include "glew.h"

//GLFW
#include "glfw3.h"

#define GL_CLIENT_VERSION_MINOR 3
#define GL_CLIENT_VERSION_MAJOR 3

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode);

#endif /* main_h */
