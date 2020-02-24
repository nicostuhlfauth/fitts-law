// Copyright (c) 2020 Nicolas Stuhlfauth
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

#include "fileio.h"
#include <QFile>
#include <QTextStream>
#include <QMessageLogger>


FileIO::FileIO(QObject *parent) :
    QObject(parent)
{}

FileIO::~FileIO()
{}

/*
 * This function is used to add a new line to the CSV file for every time the button is clicked.
 */
void FileIO::writeToFile(const QString &inputText)
{
    QString filename = "Results.csv";
    QFile file( filename );
    if ( file.open(QIODevice::ReadWrite | QIODevice::Append | QIODevice::Text ) )
    {
        QTextStream stream( &file );
        if (file.pos() == 0) {
            stream << "Testperson, Testcounter, Distance, RealWidth, Time, DifficultyIndex" << endl;
        }

        stream << inputText << endl;
    }
    return;
}

/*
 * This function returns the last Testperson-ID, which has been written to the CSV file
 */
int FileIO::getPersonID()
{

    QString filename = "Results.csv";
    QFile file(filename);
    QString line;

    if ( file.open(QIODevice::ReadOnly) )
    {
        QTextStream stream(&file);

        while (!stream.atEnd()) {
            line = stream.readLine();
        }
        line = line.split(",")[0];


    }

    m_personID = line.toInt();

    return m_personID;
    }


