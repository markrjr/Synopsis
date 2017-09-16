# project name
project (Synopsis)

cmake_minimum_required (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

set (PKGDATADIR "${DATADIR}/Synopsis")

set (EXEC_NAME "Synopsis")

set (RELEASE_NAME "Synopsis")
set (VERSION "0.1")
set (VERSION_INFO "A simple and concise archive manager.")

find_package(PkgConfig)

pkg_check_modules(DEPS REQUIRED gtk+-3.0 granite gee-0.8)
add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)

include(ValaVersion)

ensure_vala_version("0.16" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    src/Synopsis.vala
    src/ImageFile.vala
# tell what libraries to use when compiling
PACKAGES
    gtk+-3.0
    granite
    gee-0.8
)

add_executable(${EXEC_NAME} ${VALA_C})

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/synopsis.desktop DESTINATION ${DATADIR}/applications/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/uncompressed.png DESTINATION ${DATADIR}/Synopsis/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/compressed.png DESTINATION ${DATADIR}/Synopsis/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/synopsis.svg DESTINATION share/icons/hicolor/scalable/apps)
