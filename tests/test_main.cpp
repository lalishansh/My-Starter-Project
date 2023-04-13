#define BOOST_TEST_MODULE HelloWorldTests
#include <boost/test/included/unit_test.hpp>
#include <fmt/core.h>

BOOST_AUTO_TEST_CASE(hello_world_test) {
    std::string output = fmt::format("Hello, World!\n");
    BOOST_TEST(output == "Hello, World!\n");
}
