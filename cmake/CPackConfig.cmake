function(add_cpack_target TARGET TARGET_VERSION)
	get_target_property(TARGET_NAME ${TARGET} NAME)

	set(OS_NAME ${CMAKE_HOST_SYSTEM_NAME})

	if(UNIX AND NOT APPLE AND NOT ANDROID)
		file(READ /etc/os-release OS_INFO)

		if(OS_INFO)
			string(REPLACE "\n" ";" OS_LIST ${OS_INFO})

			foreach(LINE ${OS_LIST})
				string(REGEX MATCH "^ID=(.+)$" ID ${LINE})
				if(ID)
					string(REPLACE "=" ";" ID_LIST ${ID})
					list(GET ID_LIST 1 DISTRO)

					set(OS_NAME ${DISTRO})
				endif()

				string(REGEX MATCH "^VERSION_ID=(.+)$" VER ${LINE})
				if(VER)
					string(REPLACE "=" ";" VER_LIST ${VER})
					list(GET VER_LIST 1 VER_STRING)
					string(REGEX REPLACE "\"(.+)\"" "\\1" VER_STRING ${VER_STRING})

					set(OS_NAME ${OS_NAME}-${VER_STRING})
				endif()
			endforeach()
		endif()
	endif()

	set(CPACK_STRIP_FILES ON)
	set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)
	set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)
	set(CPACK_PACKAGE_FILE_NAME "${TARGET_NAME}-${TARGET_VERSION}-${OS_NAME}-${TARGET_ARCH}")
	set(CPACK_PACKAGE_VENDOR ${PROJECT_NAME})
	set(CPACK_PACKAGE_VERSION ${TARGET_VERSION})
	set(CPACK_PACKAGE_INSTALL_DIRECTORY "${TARGET_NAME}\\\\${TARGET_VERSION}")

	set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
	set(CPACK_PACKAGE_CHECKSUM SHA1)

	set(CPACK_OUTPUT_CONFIG_FILE ${CMAKE_CURRENT_BINARY_DIR}/${TARGET}CpackConfig.cmake)

	add_custom_target(${TARGET}-package COMMAND cpack -C $<CONFIGURATION> --config ${CPACK_OUTPUT_CONFIG_FILE} WORKING_DIRECTORY ${CMAKE_BINARY_DIR})

	include (CPack)
endfunction(add_cpack_target)
