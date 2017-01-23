//
//  main.cpp
//  exercise_opengl
//
//  Created by freedragon on 03/01/2017.
//  Copyright © 2017 freedragon. All rights reserved.
//
#include "main.h"
/*
glfwInit(): 初始化GLFW库, succesful：GL_TRUE，failed：GL_FALSE.
 
glfwWindowHint(int target, int hint):the target param is with the GLFW_.改变这些设置的value，可通过glfwWindowHint／glfwDefaultWindowHints／直到这个库终止了。这个接口不能检测value是否有效；如果没效果，会在glfwCreateWindow时候报错（GLFW_NOT_INITIALIZED／GLFW_INVALID_ENUM）。设置这个要在主线程。glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE): 给macOS系统做兼容的。
 
glfwCreateWindow(int width, int height, const char* title, GLFWmonitor* monitor, GLFWwindow* share)
    :创建窗口，和opengl／opengles的text相关，很多options控制这窗口和context使用特定的window hint应该怎么创建。share参数和创建窗口成功之后的切换窗口有关。
    对于你创建window，其中framebuffer和context不同于你请求的信息。这是受
 
ratina屏的macOS在设置viewport时，直接设置高宽会有尺寸问题，应该从缓冲获取窗口的宽高。
获取视口:
    int height, width;
    glfwGetFramebufferSize(Window, &width, &heigt);
    glViewport(0, 0, width, height);

glfwSwapBuffers(window);
 double buffer: sigle buffer result:flickering issues. because then resulting output image is not drawn in an instant. ----->use double buffer for rending. swap back/front.
 
https://zh.wikipedia.org/wiki/深度缓冲
https://en.wikipedia.org/wiki/Stencil_buffer
the stencil buffer is used to limit the area of rendering (stenciling)
The most typical application is still to add shadows to 3D applications.
*/

int main(int argc, const char * argv[]) {
//init GLFW init hints value
    if (!glfwInit()){
        std::cout<< "Failed to initialize GLFW" <<std::endl;
        exit(EXIT_FAILURE);
    }

//set hints value
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, GL_CLIENT_VERSION_MAJOR);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, GL_CLIENT_VERSION_MINOR);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
//mac forward compat
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    
//create window object
    GLFWwindow* window = glfwCreateWindow(800, 600, "learnOpenGL", nullptr, nullptr);
    if (window == nullptr) {
        std::cout << "Failed to ceate GLFW window" << std::endl;
        glfwTerminate();
        exit(EXIT_FAILURE);
    }
//make the window to current window
    glfwMakeContextCurrent(window);
    
    
//set true: use more moderm techniques for managing OpenGL functionality.
//default value: false.give us some issues when using the opengl core profile.
    glewExperimental = GL_TRUE;
//init GLEW
    if (glewInit() != GLEW_OK)
    {
        std::cout << "Failed to initialize GLEW" << std::endl;
        exit(EXIT_FAILURE);
    }
    int width, height;
    glfwGetFramebufferSize(window, &width, &height);
//don't set the w,h to 800,600. it can use on high DPI screens(rp:retina.).
    glViewport(0, 0, width, height);
    
    std::cout<< "version:" << glfwGetVersionString() <<std::endl;
    
    glfwSetKeyCallback(window, key_callback);
    
//game loop.
    while (!glfwWindowShouldClose(window)) {
        // Check and call events
        glfwPollEvents();
        // Rendering commands here
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        //GL_DEPTH_BUFFER_BIT GL_
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        // Swap the buffers
        glfwSwapBuffers(window);
    }
    
// Terminate GLFW, clearing any resources allocated by GLFW.
    glfwTerminate();
    exit(EXIT_SUCCESS);
}

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode){
    if (key == GLFW_KEY_ESCAPE && action == GLFW_RELEASE) {
        glfwSetWindowShouldClose(window, GL_TRUE);
    }
}
