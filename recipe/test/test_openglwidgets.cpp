#include <QApplication>
#include <QOpenGLWidget>

class MyGLWidget : public QOpenGLWidget {
protected:
    void initializeGL() override {
        qDebug() << "[QtOpenGLWidgets Test] OpenGL initialized!";
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    MyGLWidget w;
    w.resize(200, 200);
    w.show();

    return 0;
}
