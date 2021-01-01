vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO spectra-fund/prometheus-cpp
    REF 7f34e9cd2796bbcab11eb90f37e0b039da6755c1
    SHA512 ad9f9f03d6d7d2ac79d414519ef27d83407573af70265037c58c5397e4e8f373d6d9962a3ad75e9267906f25fadac0722c48874e1bbe4d5b2b7bfd0ff3497e89
    HEAD_REF master
)

macro(feature FEATURENAME OPTIONNAME)
    if("${FEATURENAME}" IN_LIST FEATURES)
        list(APPEND FEATURE_OPTIONS -D${OPTIONNAME}=TRUE)
    else()
        list(APPEND FEATURE_OPTIONS -D${OPTIONNAME}=FALSE)
    endif()
endmacro()

feature(compression ENABLE_COMPRESSION)
feature(pull ENABLE_PULL)
feature(push ENABLE_PUSH)
feature(tests ENABLE_TESTING)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DUSE_THIRDPARTY_LIBRARIES=OFF # use vcpkg packages
        ${FEATURE_OPTIONS}
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/prometheus-cpp)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
configure_file(${SOURCE_PATH}/LICENSE ${CURRENT_PACKAGES_DIR}/share/prometheus-cpp/copyright COPYONLY)
