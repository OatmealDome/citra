#include "emu_window_ios.h"

/// EmuWindow_iOS constructor
EmuWindow_iOS::EmuWindow_iOS(CAEAGLLayer* layer) {
    // create our context
    DoneCurrent();
    NSLog(@"Creating new EAGLContext.");
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    MakeCurrent();
    
    // generate renderbuffer
    NSLog(@"Generating color renderbuffer.");
    glGenRenderbuffers(1, &colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    
    // generate framebuffer and bind it to the renderbuffer
    NSLog(@"Generating framebuffer");
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    
    int width, height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
    /*
    
    For when we need to do things in THREE DIMENSIONS!!!
     
    NSLog(@"Generating depth renderbuffer.");
    glGenRenderbuffers(1, &depthRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
    
    */
    
    NotifyFramebufferLayoutChanged(EmuWindow::FramebufferLayout::DefaultScreenLayout(width, height));
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    //GLubyte* err = gluErrorString(glGetError());
    if(status != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"framebuffer generation failed, %s", "err");
    }
}

/// EmuWindow_iOS destructor
EmuWindow_iOS::~EmuWindow_iOS() {
    // destroy our buffers
    glDeleteRenderbuffers(1, &colorRenderbuffer);
    glDeleteFramebuffers(1, &framebuffer);
    
    // destroy our context
    DoneCurrent();
    [context release];
}

/// Swap buffers to display the next frame
void EmuWindow_iOS::SwapBuffers() {
    //NSLog(@"SwapBuffers called.");
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
    //glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
}

/// Polls window events
void EmuWindow_iOS::PollEvents() {
    // TODO
}

/// Makes the GLFW OpenGL context current for the caller thread
void EmuWindow_iOS::MakeCurrent() {
    [EAGLContext setCurrentContext:context];
}

/// Releases (dunno if this is the "right" word) the GLFW context from the caller thread
void EmuWindow_iOS::DoneCurrent() {
    //[EAGLContext setCurrentContext:nil];
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
}

void EmuWindow_iOS::ReloadSetKeymaps() {
    // TODO
}