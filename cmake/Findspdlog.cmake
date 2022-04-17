if(NOT ${CMAKE_FIND_PACKAGE_NAME}_FOUND)
	string(TOUPPER ${CMAKE_FIND_PACKAGE_NAME} PACKAGE_NAME_UPPER)
	string(TOLOWER ${CMAKE_FIND_PACKAGE_NAME} PACKAGE_NAME_LOWER)

	if(NOT ${PACKAGE_NAME_UPPER}_PATH OR "${${PACKAGE_NAME_UPPER}_PATH}" STREQUAL "")
		if(DEFINED PROJECT_NAME_UPPER AND DEFINED ${PROJECT_NAME_UPPER}_LIB_PATH)
			set(${PACKAGE_NAME_UPPER}_PATH ${${PROJECT_NAME_UPPER}_LIB_PATH})
		else()
			set(${PACKAGE_NAME_UPPER}_PATH "" CACHE STRING "Custom ${CMAKE_FIND_PACKAGE_NAME} library path")
		endif()
	endif()

	set(${CMAKE_FIND_PACKAGE_NAME}_NO_DEFAULT_PATH OFF)
	if(${PACKAGE_NAME_UPPER}_PATH)
		set(${CMAKE_FIND_PACKAGE_NAME}_NO_DEFAULT_PATH ON)
	endif()

	set(${PACKAGE_NAME_UPPER}_NO_DEFAULT_PATH ${${CMAKE_FIND_PACKAGE_NAME}_NO_DEFAULT_PATH} CACHE BOOL "Disable search ${CMAKE_FIND_PACKAGE_NAME} library in default path")
	unset(${CMAKE_FIND_PACKAGE_NAME}_NO_DEFAULT_PATH)

	set(${PACKAGE_NAME_UPPER}_NO_DEFAULT_PATH_CMD)
	if(${PACKAGE_NAME_UPPER}_NO_DEFAULT_PATH)
		set(${PACKAGE_NAME_UPPER}_NO_DEFAULT_PATH_CMD NO_DEFAULT_PATH)
	endif()

	if(${PACKAGE_NAME_UPPER}_NO_DEFAULT_PATH)
		file(GLOB REAL_PATH "${${PACKAGE_NAME_UPPER}_PATH}/${CMAKE_FIND_PACKAGE_NAME}-*")

		if(REAL_PATH)
			set(${PACKAGE_NAME_UPPER}_PATH ${REAL_PATH})
			unset(REAL_PATH)
		else()
			file(GLOB REAL_PATH "${${PACKAGE_NAME_UPPER}_PATH}/${PACKAGE_NAME_LOWER}-*")
			if(REAL_PATH)
				set(${PACKAGE_NAME_UPPER}_PATH ${REAL_PATH})
				unset(REAL_PATH)
			endif()
		endif()
	endif()

	if(NOT ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
		set(${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS spdlog)
	endif()

	foreach(COMPONENT ${${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS})
		string(TOUPPER ${COMPONENT} COMPONENT_UPPER)
		string(TOLOWER ${COMPONENT} COMPONENT_LOWER)
		find_path(${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_INCLUDE_DIR
						NAMES
							${COMPONENT}/${COMPONENT}.h
							${COMPONENT}/${COMPONENT_LOWER}.h
							ENV ${PACKAGE_NAME_UPPER}_DIR
							${${PACKAGE_NAME_UPPER}_NO_DEFAULT_PATH_CMD}
						PATH_SUFFIXES
							include
							${CMAKE_FIND_PACKAGE_NAME}*/include
						PATHS
							${${CMAKE_FIND_PACKAGE_NAME}_PATH}
							${${PACKAGE_NAME_UPPER}_PATH}
							${${PACKAGE_NAME_LOWER}_PATH}
							/usr/include
							/usr/local/include
					)

		if(${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_INCLUDE_DIR)
			set(${PACKAGE_NAME_UPPER}_INCLUDE_DIR ${${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_INCLUDE_DIR})
		endif()

		find_library(${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_LIBRARY
							NAMES
								${COMPONENT}
								${COMPONENT_LOWER}
							HINTS
								ENV ${PACKAGE_NAME_UPPER}_DIR
								${${PACKAGE_NAME_UPPER}_NO_DEFAULT_PATH_CMD}
							PATH_SUFFIXES
								lib
								${TARGET_ARCH}
								lib/${TARGET_ARCH}
							PATHS
								${${PACKAGE_NAME_UPPER}_PATH}
								${${PACKAGE_NAME_LOWER}_PATH}
								/usr/lib
								/usr/lib/x86_64-linux-gnu/
								/usr/local/lib
						) 

		if(${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_LIBRARY)
			list(APPEND ${PACKAGE_NAME_UPPER}_LIBRARIES ${${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_LIBRARY})

			set(TARGET_NAME ${CMAKE_FIND_PACKAGE_NAME}::${COMPONENT})

			if(NOT TARGET ${TARGET_NAME})
				add_library(${TARGET_NAME} UNKNOWN IMPORTED)
				set_target_properties(${TARGET_NAME} PROPERTIES
					IMPORTED_LOCATION
						"${${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_LIBRARY}"
					INTERFACE_INCLUDE_DIRECTORIES
						"${${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_INCLUDE_DIR}"
						)
				if(${COMPONENT}_INTERFACE_LINK_OPTIONS)
					set_target_properties(${TARGET_NAME} PROPERTIES LINK_FLAGS ${${COMPONENT}_INTERFACE_LINK_OPTIONS})
				endif()
			endif()
		else()
			set(${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_FOUND OFF)
		endif()
		mark_as_advanced(${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_INCLUDE_DIR ${PACKAGE_NAME_UPPER}_${COMPONENT_UPPER}_LIBRARY)
	endforeach()
	
	set(${PACKAGE_NAME_UPPER}_INCLUDE_DIR ${${PACKAGE_NAME_UPPER}_INCLUDE_DIR} CACHE STRING "${CMAKE_FIND_PACKAGE_NAME} include directories")
	set(${PACKAGE_NAME_UPPER}_LIBRARIES ${${PACKAGE_NAME_UPPER}_LIBRARIES} CACHE STRING "${CMAKE_FIND_PACKAGE_NAME} link libraries")

	include(FindPackageHandleStandardArgs)

	find_package_handle_standard_args(${CMAKE_FIND_PACKAGE_NAME}
													FOUND_VAR
														${PACKAGE_NAME_UPPER}_FOUND
													REQUIRED_VARS
														${PACKAGE_NAME_UPPER}_INCLUDE_DIR
														${PACKAGE_NAME_UPPER}_LIBRARIES
													VERSION_VAR
														${PACKAGE_NAME_UPPER}_VERSION_STRING
												)

	mark_as_advanced(${PACKAGE_NAME_UPPER}_PATH
							${PACKAGE_NAME_UPPER}_NO_DEFAULT_PATH
							${PACKAGE_NAME_UPPER}_INCLUDE_DIR
							${PACKAGE_NAME_UPPER}_LIBRARIES
							${PACKAGE_NAME_UPPER}_VERSION_STRING
						)
endif()
