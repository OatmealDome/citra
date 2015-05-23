set(SRCS
            AppDelegate.m
            GLView.m
            main.m
            ViewController.mm
            emu_window_ios.mm
            Config.cpp
            )
set(HEADERS
            AppDelegate.h
            GLView.h
            ViewController.h
            emu_window_ios.h
            thread_local_storage.h
            Config.h
            )
set(RESOURCES
            LaunchScreen.nib
            3dscraft.3dsx
            Default-568h@2x.png
)

create_directory_groups(${SRCS} ${HEADERS})

set(MACOSX_BUNDLE_GUI_IDENTIFIER "org.citra-emu.citra-ios")
add_executable(citra_ios MACOSX_BUNDLE ${SRCS} ${HEADERS} ${RESOURCES})
target_link_libraries(citra_ios core common video_core)
target_link_libraries(citra_ios inih)
target_link_libraries(citra_ios ${PLATFORM_LIBRARIES})
set_xcode_property(citra_ios IPHONEOS_DEPLOYMENT_TARGET "8.1") # for my jailbroken device
set_xcode_property(citra_ios CODE_SIGN_ENTITLEMENTS "src/citra_ios/Entitlements.plist")
set_xcode_property(citra_ios CODE_SIGN_IDENTITY "-")
set_xcode_property(citra_ios MACOSX_BUNDLE_INFO_PLIST "src/citra_ios/Info.plist")
set_target_properties(citra_ios PROPERTIES RESOURCE ${RESOURCES})
set_source_files_properties(3dscraft.3dsx PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

#install(TARGETS citra_ios RUNTIME DESTINATION ${bindir})
