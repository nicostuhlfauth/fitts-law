// Copyright (c) 2020 Nicolas Stuhlfauth
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

import QtQuick.Controls.Styles 1.4

import hrw.FileIO 1.0
import "FittsLaw.js" as FittsLaw

ApplicationWindow {
    title: qsTr("Fitts Law")

    visible: true

    minimumWidth: 1000
    minimumHeight: 750
    maximumWidth: 1000
    maximumHeight: 750

    onVisibilityChanged: {
        FittsLaw.setPersonCounter(myio.getPersonID()+1);
    }

    FileIO {
        //nothing to do here
        id:fileIO
    }

    Text{
        /*
         * Text item, shows current instruction
         */
        id: instructionText
        x:10
        y:10

        font.pixelSize: 18

        text: "Hello and welcome to Fitts Law.\nPlease move your mouse pointer to the red rectangle and wait for a new task."
    }

    Rectangle{
        /*
         * Rectangle with hover listener
         */
        id: startRectangle

        anchors.centerIn: parent

        width: 50
        height: 50
        color: "red"

        MouseArea{
            /*
             * Mouse Area, needed for hover actions
             */
            anchors.fill: parent
            hoverEnabled: true

            onEntered:{
                // when entering the rectangle, instruction changes, button gets visible
                targetButton.visible = true;
                instructionText.text = "Great! I created a button for you. Move your mouse pointer to it and press it."

            }

            onExited: {
                // when leaving the rectangle area, timer starts
                FittsLaw.StopWatch.start();
            }
        }
    }

    Button{
        /*
         * Button, which the testperson needs to click
         */

        id: targetButton

        text: "Click me!"

        visible: false

        // position and dimensions of button are taken from ListModel element properties
        x: testCases.get(0).x
        y: testCases.get(0).y
        width: testCases.get(0).width
        height: testCases.get(0).height

        // onclick: writeToFile (CPP) is called to save the data (compare calculateResults in FittsLaw.js for details)
        // timer is stopped
        onClicked:{

            fileIO.writeToFile(FittsLaw.calculateResults(startRectangle, targetButton, FittsLaw.StopWatch.stop()));

            targetButton.visible = false;

            if (FittsLaw.getTestCounter() + 1 === testCases.count) {
                FittsLaw.incrementTestCounter(false);
                createNextTest(true);
            } else {
                FittsLaw.incrementTestCounter(true);
                createNextTest(false);
            }

        }

        style: ButtonStyle {
            background: Rectangle {
                border.width: 3
                border.color: "black"
            }
        }

    }

    // next test case will be created as soon as the button is clicked
    // position and dimensions of button changes with data from ListModel
    // instruction text discriminates between new users and returning users (2nd+ round)
    function createNextTest(change){

        var counter = FittsLaw.getTestCounter();

        if (counter < testCases.count) {
            targetButton.x = testCases.get(counter).x;
            targetButton.y = testCases.get(counter).y;
            targetButton.width = testCases.get(counter).width;
            targetButton.height = testCases.get(counter).height;

            if (change === false) {
                instructionText.text = "Great! Move your mouse back to the red form. Button " + (counter+1) + " is prepared for you";
            }
            else {
                thankyou.visible = true;
                instructionText.text = "Hello and welcome to Fitts Law.\nPlease move your mouse pointer to the red rectangle and wait for a new task.";
            }

        } else {
            console.log("Something with the TestCases Index went totally wrong. Aborted.");
        }

    }

    // Model holds test cases
    ListModel{

        id: testCases;
        ListElement{name: "t1";  x: 500; y:400; width: 180; height: 80}
        ListElement{name: "t2";  x: 580; y: 100; width: 120; height: 50}
        ListElement{name: "t3";  x: 200; y: 600; width: 90; height: 120}
        ListElement{name: "t4";  x: 20; y: 40; width: 590; height: 40}
        ListElement{name: "t5";  x: 900; y: 300; width: 50; height: 50}
        ListElement{name: "t6";  x: 320; y: 570; width: 70; height: 20}
        ListElement{name: "t7";  x: 15; y: 5; width: 800; height: 30}
        ListElement{name: "t8";  x: 500; y: 300; width: 100; height: 100}
        ListElement{name: "t9";  x: 850; y: 700; width: 70; height: 20}
        ListElement{name: "t10";  x: 510; y: 20; width: 60; height: 60}




    }

    // dialog to say good bye
    Dialog {
        id: thankyou
        visible: false

        title: "Thank you"

        width: 200
        height: 100

        contentItem: Rectangle {
            Text {
                text: "You solved all the tasks!\nThank you for your participation!\nWaiting for next person..."
                anchors.centerIn: parent
            }
        }
    }

}
