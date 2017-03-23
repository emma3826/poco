set(LIBNAME "Data")
set(POCO_LIBNAME "Poco${LIBNAME}")

# Sources
file(GLOB SRCS_G "src/*.cpp")
POCO_SOURCES_AUTO( SRCS ${SRCS_G})

# Headers
file(GLOB_RECURSE HDRS_G "include/*.h" )
POCO_HEADERS_AUTO( SRCS ${HDRS_G})

if (NOT POCO_STATIC)
    add_definitions(-DTHREADSAFE)
endif (NOT POCO_STATIC)

if(MSVC AND NOT(MSVC_VERSION LESS 1400))
    set_source_files_properties(src/StatementImpl.cpp
        PROPERTIES COMPILE_FLAGS "/bigobj")
endif()

add_library( "${LIBNAME}" ${LIB_MODE} ${SRCS} )
add_library( "${POCO_LIBNAME}" ALIAS "${LIBNAME}")
set_target_properties( "${LIBNAME}"
    PROPERTIES
    VERSION ${SHARED_LIBRARY_VERSION} SOVERSION ${SHARED_LIBRARY_VERSION}
    OUTPUT_NAME ${POCO_LIBNAME}
    DEFINE_SYMBOL Data_EXPORTS
    )

target_link_libraries( "${LIBNAME}" Foundation)
target_include_directories( "${LIBNAME}"
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src
    )

POCO_INSTALL("${LIBNAME}")
POCO_GENERATE_PACKAGE("${LIBNAME}")

if(POCO_ENABLEDATA_SQLITE)
    # SQlite3 is built in any case
    add_subdirectory( SQLite )
endif(POCO_ENABLEDATA_SQLITE)

if(POCO_ENABLEDATA_MYSQL)
    find_package(MySQL)
    if(POCO_MYSQL_FOUND)
        include_directories("${POCO_MYSQL_INCLUDE_DIR}")
        message(STATUS "MySQL Support Enabled")
        add_subdirectory( MySQL )
    else()
        message(STATUS "MySQL Support Disabled - no MySQL library")
    endif(POCO_MYSQL_FOUND)
endif(POCO_ENABLEDATA_MYSQL)

if(POCO_ENABLEDATA_ODBC)
    find_package(ODBC)
    if(WIN32 AND NOT WINCE)
        set(ODBC_LIBRARIES "odbc32" "odbccp32")
        message(STATUS "Windows native ODBC Support Enabled")
        add_subdirectory( ODBC )
    else(WIN32 AND NOT WINCE)
        if(ODBC_FOUND)
            include_directories("${ODBC_INCLUDE_DIRECTORIES}")
            message(STATUS "ODBC Support Enabled")
            add_subdirectory( ODBC )
        else()
            message(STATUS "ODBC Support Disabled - no ODBC runtime")
        endif()
    endif(WIN32 AND NOT WINCE)
endif(POCO_ENABLEDATA_ODBC)

if (POCO_ENABLETESTS)
    add_subdirectory(samples)
    add_subdirectory(testsuite)
endif ()
