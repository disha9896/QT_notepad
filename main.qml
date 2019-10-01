import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1
import org.qtproject.temp 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Notepad")

    FileDialog {
        id: fileDialog
        nameFilters: ["Text files (*.txt)", "HTML files (*.html, *.htm)"]
        onAccepted: {
            if (fileDialog.selectExisting){
                document.fileUrl = fileUrl
            }
            else
                document.saveAs(fileUrl, selectedNameFilter)
        }
    }

    Action{
        id: newFile
        text: "New"
        shortcut: StandardKey.New
        onTriggered: {
  //          if(document.fileUrl == ""){
  //              textArea.text = ""
  //          }
            document.fileUrl = ""
            document.text = ""
        }
    }

    Action {
        id: openAction
        text: "Open"
        shortcut: StandardKey.Open
        onTriggered:{
            fileDialog.selectExisting = true
            fileDialog.open()
        }
    }
    Action{
        id:saveFile
        text: "Save"
        shortcut: StandardKey.Save
        onTriggered:{
            if(document.fileUrl == "")
                saveasFile.trigger()
            else{
                document.save(document.fileUrl)
            }
        }
    }
    Action{
        id:saveasFile
        text: "SaveAs"
        shortcut: StandardKey.SaveAs
        onTriggered: {
            fileDialog.selectExisting = false
            fileDialog.open()
        }
    }

    Action {
        id: cutAction
        text: "Cut"
        shortcut: "ctrl+x"
        iconName: "edit-cut"
        onTriggered: textArea.cut()
    }
    Action {
        id: copyAction
        text: "copy"
        shortcut: StandardKey.Copy
        iconName: "copy-icon"
        onTriggered: textArea.copy()
    }
    Action{
        id: pasteAction
        text: "Paste"
        shortcut: StandardKey.Paste
        onTriggered: textArea.paste()
    }

    menuBar: MenuBar{
        Menu{
           title:"&File"
           MenuItem{ action: newFile }
           MenuItem{ action: openAction }
           MenuItem{ action: saveFile }
           MenuItem{ action: saveasFile }
        }
        Menu{
            title: "&Edit"
            MenuItem{ action: cutAction }
            MenuItem{ action: copyAction }
            MenuItem{ action: pasteAction }
        }
    }
    TextArea{
        Accessible.name: "document"
        id: textArea
        frameVisible: false
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        baseUrl: "qrc:/"
        text: document.text
        textFormat: Qt.RichText
        Component.onCompleted: forceActiveFocus()
    }
    DocumentHandler {
        id: document
        fileUrl: ""
        target: textArea
//        Component.onCompleted: document.fileUrl = "qrc:/example.html"
        onError: {
            errorDialog.text = message
            errorDialog.visible = true
        }
    }
}


