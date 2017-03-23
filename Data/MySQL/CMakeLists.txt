set(LIBNAME "DataMySQL")
set(POCO_LIBNAME "Poco${LIBNAME}")

# Sources
file(GLOB SRCS_G "src/*.cpp")
POCO_SOURCES_AUTO( POCO_MYSQL_SRCS ${SRCS_G})

# Headers
file(GLOB_RECURSE HDRS_G "include/*.h" )
POCO_HEADERS_AUTO( POCO_MYSQL_SRCS ${HDRS_G})

add_definitions(-DTHREADSAFE -DNO_TCL)

add_library( "${LIBNAME}" ${LIB_MODE} ${POCO_MYSQL_SRCS} )
add_library( "${POCO_LIBNAME}" ALIAS "${LIBNAME}")
set_target_properties( "${LIBNAME}"
    PROPERTIES
    VERSION ${SHARED_LIBRARY_VERSION} SOVERSION ${SHARED_LIBRARY_VERSION}
    OUTPUT_NAME ${POCO_LIBNAME}
    DEFINE_SYMBOL MySQL_EXPORTS
    )

target_link_libraries( "${LIBNAME}" Foundation Data ${POCO_MYSQL_LIB})
target_include_directories( "${LIBNAME}"
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src
    )

POCO_INSTALL("${LIBNAME}")
POCO_GENERATE_PACKAGE("${LIBNAME}")

if (POCO_ENABLETESTS)
    add_subdirectory(testsuite)
endif ()
