cmake_minimum_required(VERSION 3.5)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

project(OMeGA-gui LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check https://doc.qt.io/qt/deployment-android.html for more information.
# They need to be set before the find_package( ...) calls below.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets LinguistTools REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets LinguistTools REQUIRED)

set(THIRD_PARTY_DIR_NAME "third_party")
set(OMEGA_LIB_PATH ${CMAKE_CURRENT_LIST_DIR}/OMeGA-lib/${THIRD_PARTY_DIR_NAME})

find_package(SDL2 REQUIRED)
find_package(SDL2_mixer	REQUIRED)

add_subdirectory(OMeGA-lib)

set(TS_FILES OMeGA-gui_en_GB.ts)

set(INCLUDE_LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/OMeGA-lib/include)

set(PROJECT_SOURCES
        main.cpp
        mainwindow.cpp
        mainwindow.h
        mainwindow.ui
        ${TS_FILES}
        )

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(OMeGA-gui
        ${PROJECT_SOURCES}
    )

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
else()
    if(ANDROID)
        add_library(OMeGA-gui SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(OMeGA-gui
            ${PROJECT_SOURCES}
        )
    endif()

    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
endif()
target_include_directories(OMeGA-gui PUBLIC ${INCLUDE_LIB_DIR})
target_link_libraries(OMeGA-gui PRIVATE Qt${QT_VERSION_MAJOR}::Widgets OMeGA_lib)
