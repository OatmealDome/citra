
#include "ViewController.h"
#include "GLView.h"

#include "common/logging/log.h"
#include "common/logging/text_formatter.h"
#include "common/logging/backend.h"
#include "common/logging/filter.h"
#include "common/scope_exit.h"

#include "core/settings.h"
#include "core/system.h"
#include "core/core.h"
#include "core/loader/loader.h"

#include "citra_ios/Config.h"
#include "citra_ios/emu_window_ios.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Waiting 3 seconds before initialization.");
    [NSThread sleepForTimeInterval:3];
    
    // create our GLView
    NSLog(@"Creating GLView.");
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    GLView *glView = [[GLView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    self.view = glView;
    
    CAEAGLLayer* layer = (CAEAGLLayer*) glView.layer;
    
    layer.opaque = TRUE;
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
    NSLog(@"Spawning cpuThread.");
    [NSThread detachNewThreadSelector:@selector(cpuThread) toTarget:self withObject:nil];
}

- (void) cpuThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // TODO: some way to shut the thing off
    
    NSLog(@"Retrieving ROM to load.");
    NSBundle *applicationBundle = [NSBundle mainBundle];
    NSString *homebrewPath = [applicationBundle pathForResource:@"3dscraft" ofType:@"3dsx"];
    
    NSLog(@"Setting log filter.");
    Log::Filter log_filter(Log::Level::Warning);
    Log::SetFilter(&log_filter);
    
    NSLog(@"Processing config.");
    Config config;

    NSLog(@"Creating emu_window.");
    EmuWindow_iOS *emu_window = new EmuWindow_iOS((CAEAGLLayer*)self.view.layer);
    
    NSLog(@"Calling System::Init.");
    System::Init(emu_window);
    
    NSLog(@"Loading ROM.");
    Loader::ResultStatus load_result = Loader::LoadFile([homebrewPath UTF8String]);
    if (Loader::ResultStatus::Success != load_result)
    {
        LOG_CRITICAL(Frontend, "Failed to load ROM (Error %i)!", load_result);
        return;
    }
    
    NSLog(@"Entering CPU loop.");
    while (true)
    {
        Core::RunLoop();
        //glClearColor(0.5f, 0.5f, 0.1f, 1.0f);
        //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        //emu_window->MakeCurrent();
        //emu_window->SwapBuffers();
    }
    [pool release];
}

@end
