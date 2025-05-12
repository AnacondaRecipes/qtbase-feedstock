#include <QGuiApplication>
#include <QOffscreenSurface>
#include <QOpenGLContext>
#include <QOpenGLFunctions>
#include <QDebug>

int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);

    // Create offscreen surface
    QOffscreenSurface surface;
    surface.create();
    if (!surface.isValid()) {
        qCritical() << "Failed to create QOffscreenSurface.";
        return 1;
    }

    // Create OpenGL context
    QOpenGLContext context;
    if (!context.create()) {
        qCritical() << "Failed to create QOpenGLContext.";
        return 2;
    }

    // Make context current
    if (!context.makeCurrent(&surface)) {
        qCritical() << "Failed to make OpenGL context current.";
        return 3;
    }

    // Get OpenGL functions
    QOpenGLFunctions *f = context.functions();
    if (!f) {
        qCritical() << "Failed to get QOpenGLFunctions.";
        return 4;
    }

    // Clear buffer
    f->glClearColor(0.1f, 0.2f, 0.3f, 1.0f);
    f->glClear(GL_COLOR_BUFFER_BIT);

    // Query renderer info
    const GLubyte *renderer = f->glGetString(GL_RENDERER);
    const GLubyte *version  = f->glGetString(GL_VERSION);
    const GLubyte *vendor   = f->glGetString(GL_VENDOR);

    if (!renderer || !version || !vendor) {
        qCritical() << "Failed to retrieve OpenGL info strings.";
        return 5;
    }

    // Output results
    qDebug() << "OpenGL Renderer:" << reinterpret_cast<const char *>(renderer);
    qDebug() << "OpenGL Version:"  << reinterpret_cast<const char *>(version);
    qDebug() << "OpenGL Vendor:"   << reinterpret_cast<const char *>(vendor);

    context.doneCurrent();

    return 0;
}
