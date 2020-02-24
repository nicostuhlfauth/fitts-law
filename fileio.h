// Copyright (c) 2020 Nicolas Stuhlfauth
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QTextStream>

class FileIO: public QObject
{
     Q_OBJECT
     Q_PROPERTY(int personID READ getPersonID())
public:
    ~FileIO();
    explicit FileIO(QObject *parent = 0);
    Q_INVOKABLE void writeToFile(const QString &inputText);
    Q_INVOKABLE int getPersonID();

private:
    int m_personID;
};

#endif // FILEIO_H

