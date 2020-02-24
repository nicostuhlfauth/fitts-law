// Copyright (c) 2020 Nicolas Stuhlfauth
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

#include <QApplication>
#include <QQmlApplicationEngine>

#include <QQmlEngine>
#include <QtQml>
#include "fileio.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<FileIO>("hrw.FileIO", 1, 0, "FileIO");
    FileIO myio;

    QQmlApplicationEngine engine;

    // bind the CPP property, so it may be used in QML
    engine.rootContext()->setContextProperty("myio", &myio);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    return app.exec();
}
