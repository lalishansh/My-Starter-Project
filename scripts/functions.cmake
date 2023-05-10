# copy property from target to target
# params:
#   target_from: the target to copy from
#   target_to: the target to copy to
#   property_name: the property to copy
FUNCTION(COPY_PROPERTY_FROM_TARGET_TO_TARGET target_from target_to property_name)
    GET_PROPERTY(the_property TARGET ${target_from} PROPERTY ${property_name})
    IF (NOT the_property STREQUAL "the_property-NOTFOUND")
        SET_PROPERTY(TARGET ${target_to} PROPERTY ${property_name} ${the_property})
    ENDIF ()
ENDFUNCTION()

include(CTest)
# add test target for target
# params:
#   target: the target to build tests for
#   tests_target: the name of the test target
#   tests_src_dir: the source-dir of the target
#   ...: the properties to copy from target to tests_target
FUNCTION(ADD_TESTS_TARGET_FOR_TARGET_FROM_TESTS_DIR target tests_target tests_src_dir)
    # get the source-dir of the target
    IF (tests_src_dir STREQUAL "")
        GET_TARGET_PROPERTY(target_src_dir ${target} SOURCE_DIR)
        IF (target_src_dir STREQUAL "target_src_dir-NOTFOUND")
            MESSAGE(WARNING "Target ${target} does not have EXAMPLE_SOURCE_DIR property set, will not build tests for it")
            RETURN()
        ENDIF ()
        SET(tests_src_dir "${target_src_dir}/tests")
    ENDIF ()

    MESSAGE(STATUS "Building test target for ${target}")

    # collect <source-dir>/tests/**/*.cpp files
    FILE(GLOB_RECURSE tests_src_files
            "${tests_src_dir}/**.c"
            "${tests_src_dir}/**.cc"
            "${tests_src_dir}/**.cpp"
            "${tests_src_dir}/**.cxx"
            "${tests_src_dir}/**.cppm"
            )

    # add test target
    ADD_EXECUTABLE(${tests_target} ${tests_src_files})
    IF (NOT TARGET Boost::unit_test_framework)
        FIND_PACKAGE(Boost REQUIRED COMPONENTS unit_test_framework)
    ENDIF ()

    TARGET_LINK_LIBRARIES(${tests_target} PRIVATE Boost::unit_test_framework)

    # copy properties from target to tests_target
    FOREACH (property_name IN LISTS ARGN)
        COPY_PROPERTY_FROM_TARGET_TO_TARGET(${target} ${tests_target} ${property_name})
    ENDFOREACH ()

    ADD_TEST(NAME ${tests_target} COMMAND ${tests_target})
ENDFUNCTION()
