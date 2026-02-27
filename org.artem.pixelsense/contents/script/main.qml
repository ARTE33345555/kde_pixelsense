import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.folderlistmodel 2.15

ApplicationWindow {
    id: root
    width: 1200
    height: 800
    visible: true
    title: "Internet Archive App" // По твоей просьбе переименовали заголовок
    color: "#050505"

    // --- Глобальные свойства ---
    property string authorSearch: ""
    property string activeApp: ""

    // --- Фон и 3D Сцена (Место для твоих скриптов) ---
    Rectangle {
        id: background3D
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a1a2e" }
            GradientStop { position: 1.0; color: "#000000" }
        }
    }

    // --- Логика сканирования иконок (папка Content/Image/Icons) ---
    FolderListModel {
        id: iconModel
        folder: "Content/Image/Icons" 
        nameFilters: ["*.png", "*.svg"]
    }

    // --- Верхняя панель поиска ([AuthorName] dev) ---
    TextField {
        id: searchBar
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 20 }
        width: 400
        placeholderText: "Поиск: [AuthorName] dev"
        color: "white"
        background: Rectangle { radius: 10; color: "#33ffffff" }

        onTextChanged: {
            // Твоя кастомная логика фильтрации
            if (text.includes("[") && text.includes("] dev")) {
                let name = text.match(/\[(.*?)\]/)[1];
                authorSearch = name; 
                console.log("Фильтр по автору:", authorSearch);
            } else {
                authorSearch = "";
            }
        }
    }

    // --- Сетка приложений (Icons + Scripts) ---
    GridView {
        id: appGrid
        anchors.fill: parent
        anchors.topMargin: 100
        cellWidth: 150; cellHeight: 180
        model: iconModel

        delegate: Item {
            width: appGrid.cellWidth
            height: appGrid.cellHeight
            
            // Фильтрация: показываем всё, или только то, что содержит имя автора
            visible: authorSearch === "" || fileName.toLowerCase().includes(authorSearch.toLowerCase())

            Column {
                anchors.centerIn: parent
                spacing: 10

                // Иконка программы
                Image {
                    source: fileUrl
                    width: 80; height: 80
                    smooth: true
                    scale: mouseArea.containsMouse ? 1.1 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            let appName = fileName.split('.')[0];
                            activeApp = appName;
                            // Загружаем скрипт из папки Script
                            appLoader.source = "Content/Script/" + appName + ".qml";
                            console.log("Запущен скрипт для:", appName);
                        }
                    }
                }

                Text {
                    text: fileName.split('.')[0]
                    color: "white"
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    // --- Контейнер для запуска скриптов программ ---
    Loader {
        id: appLoader
        anchors.fill: parent
        visible: source != ""
        
        // Кнопка закрытия запущенной программы
        Button {
            text: "Назад в 3D"
            anchors.right: parent.right
            anchors.top: parent.top
            visible: appLoader.source != ""
            onClicked: appLoader.source = ""
        }
    }
}