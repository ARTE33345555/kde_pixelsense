import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root
    width: 100
    height: 100

    Image {
        id: menuBtn
        source: "contents/images/system/menu_button.png" // <- твоя картинка
        anchors.centerIn: parent
        width: 64
        height: 64
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            onReleased: {
                // проверка, дошла ли до «кольца входа»
                if (Math.hypot(parent.x - 400, parent.y - 300) < 100) {
                    console.log("Меню активировано!")
                    // Здесь можно вызвать открытие меню или KRunner
                }
            }
        }
    }

    // визуализация «кольца входа»
    Canvas {
        anchors.centerIn: parent
        width: 200
        height: 200
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0,0,width,height)
            ctx.beginPath()
            ctx.arc(width/2, height/2, 100, 0, 2*Math.PI)
            ctx.strokeStyle = "lightblue"
            ctx.lineWidth = 4
            ctx.stroke()
        }
    }
}
