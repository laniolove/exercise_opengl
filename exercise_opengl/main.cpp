//
//  main.cpp
//  exercise_opengl
//
//  Created by freedragon on 03/01/2017.
//  Copyright © 2017 freedragon. All rights reserved.
//

#include <iostream>

//Be sure to include GLEW before GLFW.
//The includes(like GL/gl.h),
//so include GLEW before other header files that require OpenGL does the thick.

//GLEW
#define GLEW_STATIC // using the static version of the GLEW library
#include "glew.h"

//GLFW
#include "glfw3.h"
/*
glfwInit(): init the GLFW library, before most GLFW func can b used, The Func returns GL_TRUE if succesful,otherwise GL_FALSE is returned when an error.
glfwWindowHint(int target, int hint): the func sets hints for the next call to glfwCreateWindow.the hints, once set, retain their values until changed by a another call to glfwWindowHint. the target param is with the GLFW_.


*/
int main(int argc, const char * argv[]) {
    // insert code here...
//    std::cout << "Hello, World!" <<std::endl;
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_PROFILE);
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
    return 0;
}
