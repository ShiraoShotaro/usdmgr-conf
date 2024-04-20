
#include <pxr/base/gf/matrix4d.h>
#include <pxr/base/gf/vec3d.h>
#include <pxr/usd/sdf/path.h>
#include <pxr/usd/usd/stage.h>

#include <string>
#include <iostream>

int main() {

    pxr::GfMatrix4d mat;

    mat.SetTranslate(pxr::GfVec3d{ 1,2,3 });

    auto stage = pxr::UsdStage::CreateInMemory();
    std::string str;
    stage->ExportToString(&str);
    std::cout << str << std::endl;

    return 0;
}
