cmake_minimum_required(VERSION 3.21)

## FIND VCPKG TOOLCHAIN FILE
set(NO_VCPKG_TOOLCHAIN_FILE TRUE)
foreach (THE_TOOLCHAIN_FILE ${CMAKE_TOOLCHAIN_FILE})
    if (${THE_TOOLCHAIN_FILE} MATCHES "vcpkg.cmake")
        if (EXISTS ${THE_TOOLCHAIN_FILE})
            set(NO_VCPKG_TOOLCHAIN_FILE FALSE)
        endif ()
    endif ()
    if (NOT NO_VCPKG_TOOLCHAIN_FILE)
        break () # there is a vcpkg toolchain file
    endif ()
endforeach ()
if (${NO_VCPKG_TOOLCHAIN_FILE})
    if (DEFINED ENV{VCPKG_ROOT} AND EXISTS "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
        list(APPEND CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
    elseif (DEFINED ENV{VCPKG_DIR} AND EXISTS "$ENV{VCPKG_DIR}/scripts/buildsystems/vcpkg.cmake")
        list(APPEND CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_DIR}/scripts/buildsystems/vcpkg.cmake")
    else ()
        message(FATAL_ERROR "No VcPkg toolchain file found")
    endif ()
endif ()
## finish block

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

get_property (target_exec_linked_libs TARGET ${THIS_EXEC} PROPERTY LINK_LIBRARIES)
target_link_libraries(test_${THIS_EXEC} PRIVATE Boost::unit_test_framework ${target_exec_linked_libs})
get_property (target_exec_linked_dirs TARGET ${THIS_EXEC} PROPERTY LINK_DIRECTORIES)
if (${target_exec_linked_dirs})
    target_link_directories(test_${THIS_EXEC} PRIVATE ${target_exec_linked_dirs})
endif()
get_property (target_exec_include_dirs TARGET ${THIS_EXEC} PROPERTY INCLUDE_DIRECTORIES)
if (${target_exec_include_dirs})
    target_link_directories(test_${THIS_EXEC} PRIVATE Boost::unit_test_framework ${target_exec_include_dirs})
endif()

include(CTest)
add_test(NAME test_${THIS_EXEC} COMMAND test_${THIS_EXEC})

install(TARGETS ${THIS_EXEC} RUNTIME DESTINATION ./)
get_property (this_target_linked_libs TARGET ${THIS_EXEC} PROPERTY LINK_LIBRARIES)
foreach (lib IN LISTS this_target_linked_libs)
    if (${CMAKE_BUILD_TYPE} STREQUAL "Debug")
        get_target_property (lib_location ${lib} LOCATION_DEBUG)
    else ()
        get_target_property (lib_location ${lib} LOCATION_RELEASE)
    endif ()
    if (lib_location)
        install (FILES ${lib_location} DESTINATION ./ CONFIGURATIONS ${CMAKE_BUILD_TYPE})
    endif ()
endforeach ()

# For creating installers for Windows and Linux
include(InstallRequiredSystemLibraries)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set(CPACK_SET_DESTDIR  "${CMAKE_CURRENT_SOURCE_DIR}/installers/")
set(CPACK_PACKAGE_VERSION_MAJOR "${HelloWorldProject_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${HelloWorldProject_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${HelloWorldProject_VERSION_PATCH}")
set(CPACK_PACKAGE_CONTACT "Ishansh Lal <t.RED.0_0@proton.me>")
if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(CPACK_GENERATOR "NSIS")
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Ishansh Lal <t.RED.0_0@proton.me>")
    set(CPACK_GENERATOR "DEB")
endif()
include(CPack)
