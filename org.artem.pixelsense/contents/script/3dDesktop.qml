import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15

Item {
    id: root
    anchors.fill: parent

    // --- НАЛАШТУВАННЯ (Properties) ---
    // Ці змінні KDE Plasma зможе міняти через меню конфігурації
    property bool useCityMap: true  // Перемикач: Карта або просто Акваріум
    property string themeMode: "Aquarium" // Стиль інтерфейсу

    // 1. Шар КАРТИ (Твоє місто)
    Rectangle {
        id: mapContainer
        anchors.fill: parent
        visible: useCityMap // Показувати тільки якщо увімкнено в налаштуваннях
        opacity: 0 
        Behavior on opacity { NumberAnimation { duration: 1000 } }

        Map {
            id: map
            anchors.fill: parent
            plugin: Plugin { name: "osm" }
            center: QtPositioning.coordinate(50.9475, 28.6417)
            zoomLevel: 15
        }
    }

    // 2. Шар АКВАРІУМА (wallpaper.jpg)
    Image {
        id: aquariumOverlay
        source: "wallpaper.jpg" 
        anchors.fill: parent
        // Якщо вибрана карта, робимо акваріум напівпрозорим фоном
        opacity: useCityMap ? 0.4 : 1.0 
        fillMode: Image.PreserveAspectCrop
        visible: !useCityMap || mapContainer.opacity > 0
    }

    // 3. Твій жест
    MouseArea {
        anchors.fill: parent
        onReleased: {
            if (draggedEnough) {
                mapContainer.opacity = 1 
                desktopLoader.source = "Scripts/Desktop3D.qml"
            }
        }
    }
}