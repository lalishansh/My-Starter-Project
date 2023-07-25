#pragma once

// Tip: This file is for compiler identification

// defaults
#define UNKNOWN_COMPILER 1
#define COMPILER_HAS_WARNING(x) 1
#define PRAGMIFY(x) 
#define SUPPRESS_WARNING(x)

#define ON_GCC_COMPILER(x)
#if defined(__GNUC__) && defined(UNKNOWN_COMPILER)
    #define GCC_COMPILER 1

    #undef  UNKNOWN_COMPILER
    #undef  COMPILER_HAS_WARNING
    #undef  PRAGMIFY
    #undef  SUPPRESS_WARNING
    #undef  ON_GCC_COMPILER
    #define COMPILER_HAS_WARNING(x) __has_warning(x)
    #define PRAGMIFY(x) _Pragma(x)
    #define SUPPRESS_WARNING(x) PRAGMIFY(GCC diagnostic ignored x)
    #define ON_GCC_COMPILER(x) x
#endif

#define ON_CLANG_COMPILER(x)
#if defined(__clang__) && defined(UNKNOWN_COMPILER)
    #define CLANG_COMPILER 1

    #undef  UNKNOWN_COMPILER
    #undef  COMPILER_HAS_WARNING
    #undef  PRAGMIFY
    #undef  SUPPRESS_WARNING
    #undef  ON_CLANG_COMPILER
    #define COMPILER_HAS_WARNING(x) __has_warning(x)
    #define PRAGMIFY(x) _Pragma(x)
    #define SUPPRESS_WARNING(x) PRAGMIFY(clang diagnostic ignored x)
    #define ON_CLANG_COMPILER(x) x
#endif

#define ON_MSVC_COMPILER(x)
#if defined(_MSC_VER) && defined(UNKNOWN_COMPILER)
    #define MSVC_COMPILER 1

    #undef  UNKNOWN_COMPILER
    #undef  COMPILER_HAS_WARNING
    #undef  PRAGMIFY
    #undef  SUPPRESS_WARNING
    #undef  ON_MSVC_COMPILER
    #define COMPILER_HAS_WARNING(x) 1
    #define PRAGMIFY(x) __pragma(x)
    #define SUPPRESS_WARNING(x) PRAGMIFY(warning(disable: x))
    #define ON_MSVC_COMPILER(x) x
#endif


#if defined(__cplusplus) || defined(c_plusplus) || defined(__CPLUSPLUS__)
    #define CPP_COMPILER 1
#endif

#if defined(__OBJC__)
    #define OBJC_COMPILER 1
#endif