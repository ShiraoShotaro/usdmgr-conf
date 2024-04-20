

set(openusd_MAJOR_VERSION "0")
set(openusd_MINOR_VERSION "23")
set(openusd_PATCH_VERSION "11")
set(openusd_VERSION "2311")


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




include("${CMAKE_CURRENT_LIST_DIR}/openusdTargets.cmake")
if (TARGET usd_ms)
    set(libs "usd_ms")
else()
    set(libs "arch;tf;gf;js;trace;work;plug;vt;ar;kind;sdf;ndr;sdr;pcp;usd;usdGeom;usdVol;usdMedia;usdShade;usdLux;usdProc;usdRender;usdHydra;usdRi;usdSkel;usdUI;usdUtils;usdPhysics;garch;hf;hio;cameraUtil;pxOsd;geomUtil;glf;hgi;hgiGL;hgiInterop;hd;hdar;hdGp;hdsi;hdSt;hdx;usdImaging;usdImagingGL;usdProcImaging;usdRiPxrImaging;usdSkelImaging;usdVolImaging;usdAppUtils")
endif()
set(openusd_LIBRARIES "")
set(openusd_INCLUDE_DIRS "S:/dist/pxr/OpenUSD-23.11/install/python39/include")
set(openusd_INCLUDE_DIRS_DEBUG "S:/dist/pxr/OpenUSD-23.11/install/python39_d/include")

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
        "$<$<CONFIG:Debug>:S:/dist/pxr/OpenUSD-23.11/install/python39_d/include>$<$<CONFIG:Release>:S:/dist/pxr/OpenUSD-23.11/install/python39/include>"
      INTERFACE_LINK_LIBRARIES
        "${openusd_LIBRARIES};$<$<CONFIG:Debug>:C:/Users/shirao/AppData/Local/Programs/Python/Python39/libs/python39.lib>"
      INTERFACE_COMPILE_DEFINITIONS
        "NOMINMAX;BOOST_ALL_NO_LIB;_CRT_SECURE_NO_WARNINGS;$<$<CONFIG:Debug>:TBB_USE_ASSERT=0>;$<$<CONFIG:Debug>:TBB_USE_DEBUG=0>"
      INTERFACE_COMPILE_OPTIONS
        "/MP;/bigobj;/EHsc;/Zc:inline-"
  )
endif()


set(openusd_VS_DEBUGGER_ENVIRONMENT_PATH_DEBUG "S:/dist/pxr/OpenUSD-23.11/install/python39_d/bin" "S:/dist/pxr/OpenUSD-23.11/install/python39_d/lib" "C:/Users/shirao/AppData/Local/Programs/Python/Python39")
set(openusd_VS_DEBUGGER_ENVIRONMENT_PATH_RELEASE "S:/dist/pxr/OpenUSD-23.11/install/python39/bin" "S:/dist/pxr/OpenUSD-23.11/install/python39/lib" "C:/Users/shirao/AppData/Local/Programs/Python/Python39")
