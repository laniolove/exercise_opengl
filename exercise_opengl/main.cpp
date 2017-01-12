//
//  main.cpp
//  exercise_opengl
//
//  Created by freedragon on 03/01/2017.
//  Copyright © 2017 freedragon. All rights reserved.
//

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
/*
glfwInit(): 初始化GLFW库, succesful：GL_TRUE，failed：GL_FALSE.
glfwWindowHint(int target, int hint):the target param is with the GLFW_.改变这些设置的value，可通过glfwWindowHint／glfwDefaultWindowHints／直到这个库终止了。这个接口不能检测value是否有效；如果没效果，会在glfwCreateWindow时候报错（GLFW_NOT_INITIALIZED／GLFW_INVALID_ENUM）。设置这个要在主线程。glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE): 给macOS系统做兼容的。
glfwCreateWindow: 
ratina屏的macOS在设置viewport时，直接设置高宽会有尺寸问题，应该从缓冲获取窗口的宽高。
获取视口:
    int height, width;
    glfwGetFramebufferSize(Window, &width, &heigt);
    glViewport(0, 0, width, height);
*/


int main(int argc, const char * argv[]) {
    //init GLFW
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_PROFILE);
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    
    //create window object
    GLFWwindow* window = glfwCreateWindow(800, 600, "learn OpenGL", nullptr, nullptr);
    if (window == nullptr) {
        std::cout << "Failed to ceate GLFW window" << std::endl;
        glfwTerminate();
    }
    return 0;
}
