

set(openusd_MAJOR_VERSION "0")
set(openusd_MINOR_VERSION "23")
set(openusd_PATCH_VERSION "11")
set(openusd_VERSION "2311")





include("${CMAKE_CURRENT_LIST_DIR}/openusdTargets.cmake")
if (TARGET usd_ms)
    set(libs "usd_ms")
else()
    set(libs "arch;tf;gf;js;trace;work;plug;vt;ar;kind;sdf;ndr;sdr;pcp;usd;usdGeom;usdVol;usdMedia;usdShade;usdLux;usdProc;usdRender;usdHydra;usdRi;usdSkel;usdUI;usdUtils;usdPhysics;garch;hf;hio;cameraUtil;pxOsd;geomUtil;glf;hgi;hgiGL;hgiInterop;hd;hdar;hdGp;hdsi;hdSt;hdx;usdImaging;usdImagingGL;usdProcImaging;usdRiPxrImaging;usdSkelImaging;usdVolImaging;usdAppUtils")
endif()
set(openusd_LIBRARIES "")
set(openusd_INCLUDE_DIRS "S:/dist/pxr/OpenUSD-23.11/install/usd/include")
set(openusd_INCLUDE_DIRS_DEBUG "S:/dist/pxr/OpenUSD-23.11/install/usd_d/include")

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
        "$<$<CONFIG:Debug>:S:/dist/pxr/OpenUSD-23.11/install/usd_d/include>$<$<CONFIG:Release>:S:/dist/pxr/OpenUSD-23.11/install/usd/include>"
      INTERFACE_LINK_LIBRARIES
        "${openusd_LIBRARIES}"
      INTERFACE_COMPILE_DEFINITIONS
        "NOMINMAX;BOOST_ALL_NO_LIB;_CRT_SECURE_NO_WARNINGS;$<$<CONFIG:Debug>:TBB_USE_ASSERT=0>;$<$<CONFIG:Debug>:TBB_USE_DEBUG=0>"
      INTERFACE_COMPILE_OPTIONS
        "/MP;/bigobj;/EHsc;/Zc:inline-"
  )
endif()


set(openusd_VS_DEBUGGER_ENVIRONMENT_PATH_DEBUG "S:/dist/pxr/OpenUSD-23.11/install/usd_d/bin" "S:/dist/pxr/OpenUSD-23.11/install/usd_d/lib")
set(openusd_VS_DEBUGGER_ENVIRONMENT_PATH_RELEASE "S:/dist/pxr/OpenUSD-23.11/install/usd/bin" "S:/dist/pxr/OpenUSD-23.11/install/usd/lib")
