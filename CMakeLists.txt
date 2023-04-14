cmake_minimum_required(VERSION 3.21)

list(APPEND CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")

project(HelloWorldProject VERSION 1.0.0 LANGUAGES CXX)
set(THIS_EXEC hello_world)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(fmt CONFIG REQUIRED)
find_package(Boost REQUIRED COMPONENTS unit_test_framework)

add_executable( ${THIS_EXEC}
        src/main.cpp
    )
target_link_libraries(${THIS_EXEC} 
    PRIVATE 
        fmt::fmt
    )

add_executable(test_${THIS_EXEC} 
        tests/test_main.cpp
    )
target_link_libraries(test_${THIS_EXEC} 
    PRIVATE 
        Boost::unit_test_framework
        fmt::fmt
    )

include(CTest)
add_test(NAME test_${THIS_EXEC} COMMAND test_${THIS_EXEC})

install(TARGETS ${THIS_EXEC} RUNTIME DESTINATION bin)

# For creating installers for Windows and Linux
include(InstallRequiredSystemLibraries)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set(CPACK_PACKAGE_VERSION_MAJOR "${HelloWorldProject_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${HelloWorldProject_VERSION_MINOR}")
if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(CPACK_GENERATOR "NSIS")
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CPACK_GENERATOR "DEB")
endif()
include(CPack)
