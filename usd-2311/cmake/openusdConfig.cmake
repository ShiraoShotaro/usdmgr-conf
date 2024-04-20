{% if false %}
# - Configuration file for the pxr project
# Defines the following variables:
# openusd_MAJOR_VERSION - Major version number.
# openusd_MINOR_VERSION - Minor version number.
# openusd_PATCH_VERSION - Patch version number.
# openusd_VERSION       - Complete pxr version string.
# openusd_INCLUDE_DIRS  - Root include directory for the installed project.
# openusd_LIBRARIES     - List of all libraries, by target name.
# openusd_foo_LIBRARY   - Absolute path to individual libraries.
# The preprocessor definition openusd_STATIC will be defined if appropriate
{% endif %}

set(openusd_MAJOR_VERSION "0")
set(openusd_MINOR_VERSION "23")
set(openusd_PATCH_VERSION "11")
set(openusd_VERSION "2311")

{% if python.enabled %}
# If Python support was enabled for this USD build, find the import
# targets by invoking the appropriate FindPython module. Use the same
# LIBRARY and INCLUDE_DIR settings from the original build if they
# were set. This can be overridden by specifying different values when
# running cmake.
if (NOT DEFINED Python3_VERSION)
    find_package(Python3 "3.9.13" EXACT COMPONENTS Development REQUIRED)
else()
    find_package(Python3 COMPONENTS Development REQUIRED)
endif()
message("Python3 Executable: ${Python3_EXECUTABLE}")
message("Python3 Library: ${Python3_LIBRARIES}")
message("Python3 Include Dir: ${Python3_INCLUDE_DIRS}")
message("Python3 Found: ${Python3_FOUND}")
message("Python3 Version: ${Python3_VERSION}")
{% endif %}

{% if materialX.enabled %}
# If MaterialX support was enabled for this USD build, try to find the
# associated import targets by invoking the same FindMaterialX.cmake
# module that was used for that build. This can be overridden by
# specifying a different MaterialX_DIR when running cmake.
# TODO:
if (NOT DEFINED MaterialX_DIR)
    if (NOT [[]] STREQUAL "")
        set(MaterialX_DIR [[]])
    endif()
endif()
find_package(MaterialX REQUIRED)
{% endif %}

include("${CMAKE_CURRENT_LIST_DIR}/openusdTargets.cmake")
if (TARGET usd_ms)
    set(libs "usd_ms")
else()
    set(libs "arch;tf;gf;js;trace;work;plug;vt;ar;kind;sdf;ndr;sdr;pcp;usd;usdGeom;usdVol;usdMedia;usdShade;usdLux;usdProc;usdRender;usdHydra;usdRi;usdSkel;usdUI;usdUtils;usdPhysics;garch;hf;hio;cameraUtil;pxOsd;geomUtil;glf;hgi;hgiGL;hgiInterop;hd;hdar;hdGp;hdsi;hdSt;hdx;usdImaging;usdImagingGL;usdProcImaging;usdRiPxrImaging;usdSkelImaging;usdVolImaging;usdAppUtils")
endif()
set(openusd_LIBRARIES "")
set(openusd_INCLUDE_DIRS "{{ openUsd.rootDir.release }}/include")
set(openusd_INCLUDE_DIRS_DEBUG "{{ openUsd.rootDir.debug }}/include")

string(REPLACE " " ";" libs "${libs}")
foreach(lib ${libs})
    get_target_property(location ${lib} LOCATION)
    set(openusd_${lib}_LIBRARY ${location})
    list(APPEND openusd_LIBRARIES ${lib})
endforeach()

if (NOT TARGET openusd::openusd)
  add_library(openusd::openusd INTERFACE IMPORTED)
  set_target_properties(openusd::openusd
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES
        "$<$<CONFIG:Debug>:{{ openUsd.rootDir.debug }}/include>$<$<CONFIG:Release>:{{ openUsd.rootDir.release }}/include>"
      INTERFACE_LINK_LIBRARIES
        "${openusd_LIBRARIES}{% if python.enabled %};$<$<CONFIG:Debug>:{{ python.library.release }}>{% endif %}"
      INTERFACE_COMPILE_DEFINITIONS
        "NOMINMAX;BOOST_ALL_NO_LIB;_CRT_SECURE_NO_WARNINGS;$<$<CONFIG:Debug>:TBB_USE_ASSERT=0>;$<$<CONFIG:Debug>:TBB_USE_DEBUG=0>"
      INTERFACE_COMPILE_OPTIONS
        "/MP;/bigobj;/EHsc;/Zc:inline-"
  )
endif()

{% if python.enabled %}
set(openusd_VS_DEBUGGER_ENVIRONMENT_PATH_DEBUG "{{ openUsd.rootDir.debug }}/bin" "{{ openUsd.rootDir.debug }}/lib" "{{ python.executable.debug | dirpath }}")
set(openusd_VS_DEBUGGER_ENVIRONMENT_PATH_RELEASE "{{ openUsd.rootDir.release }}/bin" "{{ openUsd.rootDir.release }}/lib" "{{ python.executable.release | dirpath }}")
{% else %}
set(openusd_VS_DEBUGGER_ENVIRONMENT_PATH_DEBUG "{{ openUsd.rootDir.debug }}/bin" "{{ openUsd.rootDir.debug }}/lib")
set(openusd_VS_DEBUGGER_ENVIRONMENT_PATH_RELEASE "{{ openUsd.rootDir.release }}/bin" "{{ openUsd.rootDir.release }}/lib")
{% endif %}
