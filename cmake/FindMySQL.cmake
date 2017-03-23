find_path(POCO_MYSQL_INCLUDE_DIR mysql.h
		/usr/include/mysql
		/usr/local/include/mysql
		/opt/mysql/mysql/include
		/opt/mysql/mysql/include/mysql
		/usr/local/mysql/include
		/usr/local/mysql/include/mysql
		$ENV{POCO_MYSQL_INCLUDE_DIR}
		$ENV{POCO_MYSQL_DIR}/include
		$ENV{ProgramFiles}/MySQL/*/include
		$ENV{SystemDrive}/MySQL/*/include)

if (WIN32)
	if (CMAKE_BUILD_TYPE STREQUAL Debug)
		set(libsuffixDist debug)
		set(libsuffixBuild Debug)
	else (CMAKE_BUILD_TYPE STREQUAL Debug)
		set(libsuffixDist opt)
		set(libsuffixBuild Release)
		add_definitions(-DDBUG_OFF)
	endif (CMAKE_BUILD_TYPE STREQUAL Debug)

	find_library(POCO_MYSQL_LIB NAMES mysqlclient
				 PATHS
				 $ENV{POCO_MYSQL_DIR}/lib/${libsuffixDist}
				 $ENV{POCO_MYSQL_DIR}/libmysql/${libsuffixBuild}
				 $ENV{POCO_MYSQL_DIR}/client/${libsuffixBuild}
				 $ENV{ProgramFiles}/MySQL/*/lib/${libsuffixDist}
				 $ENV{SystemDrive}/MySQL/*/lib/${libsuffixDist})
else (WIN32)
	find_library(POCO_MYSQL_LIB NAMES mysqlclient_r
				 PATHS
				 /usr/lib/mysql
				 /usr/local/lib/mysql
				 /usr/local/mysql/lib
				 /usr/local/mysql/lib/mysql
				 /opt/mysql/mysql/lib
				 /opt/mysql/mysql/lib/mysql
				 $ENV{POCO_MYSQL_DIR}/libmysql_r/.libs
				 $ENV{POCO_MYSQL_DIR}/lib
				 $ENV{POCO_MYSQL_DIR}/lib/mysql)
endif (WIN32)

if(POCO_MYSQL_LIB)
	get_filename_component(POCO_MYSQL_LIB_DIR ${POCO_MYSQL_LIB} PATH)
endif(POCO_MYSQL_LIB)

if (POCO_MYSQL_INCLUDE_DIR AND POCO_MYSQL_LIB_DIR)
	set(POCO_MYSQL_FOUND TRUE)
	message(STATUS "MySQL Include directory: ${POCO_MYSQL_INCLUDE_DIR}  library directory: ${POCO_MYSQL_LIB_DIR}")
	include_directories(${POCO_MYSQL_INCLUDE_DIR})
	link_directories(${POCO_MYSQL_LIB_DIR})
else (POCO_MYSQL_INCLUDE_DIR AND POCO_MYSQL_LIB_DIR)
	message(STATUS "Couldn't find MySQL")
endif (POCO_MYSQL_INCLUDE_DIR AND POCO_MYSQL_LIB_DIR)
