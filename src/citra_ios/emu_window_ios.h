
#pragma once

#import "OpenGLES/ES3/gl.h"
#import "OpenGLES/ES3/glext.h"
#import <UIKit/UIKit.h>
#include "common/emu_window.h"

class EmuWindow_iOS : public EmuWindow {
public:
    EmuWindow_iOS(CAEAGLLayer* layer);
    ~EmuWindow_iOS();

    /// Swap buffers to display the next frame
    void SwapBuffers() override;
    
    /// Polls window events
    void PollEvents() override;
    
    /// Makes the graphics context current for the caller thread
    void MakeCurrent() override;
    
    /// Releases (dunno if this is the "right" word) the GLFW context from the caller thread
    void DoneCurrent() override;
    
    void ReloadSetKeymaps() override;

private:
    EAGLContext *context;
    GLuint framebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
};