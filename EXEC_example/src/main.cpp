#include <fmt/core.h>

#include <iostream>

#include "version.h"

#if _WIN32
#include <Windows.h>
#undef min
#undef max
#endif

#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>

int 
#if _WIN32
    WINAPI
    WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
#else
    main(int __argc, const char *__argv[])
#endif
{
    fmt::print("Hello, World! from VERSION {}\n",
                HelloWorldProject_VERSION_STRING);

    if (!glfwInit())
        return -1;
    auto wnd = glfwCreateWindow(640, 480, "Hello World", nullptr, nullptr);
    if (!wnd) {
        glfwTerminate();
        return -1;
    }

    glfwMakeContextCurrent(wnd);
    while (glfwWindowShouldClose(wnd) == 0) {
        glfwSwapBuffers(wnd);
        glfwPollEvents();
    }

    std::cin.ignore();
    return 0;
}
