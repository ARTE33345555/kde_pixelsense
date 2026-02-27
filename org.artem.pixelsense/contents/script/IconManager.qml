import Qt.labs.folderlistmodel 2.15

// Внутри твоего 3D рабочего стола
Item {
    id: root
    
    // Модель, которая "видит" все иконки в папке автоматически
    FolderListModel {
        id: iconModel
        folder: "../Image/Icons" // Путь к твоей папке с иконками
        nameFilters: ["*.png", "*.svg"] // Только картинки
    }

    // Твое 3D Колесо или Сетка приложений
    Repeater {
        model: iconModel
        delegate: Item {
            // fileUrl — это путь к иконке, который нашелся САМ
            
            Image {
                source: fileUrl 
                // Если имя файла совпадает с программой автора — подсвечиваем!
                opacity: fileName.includes(authorSearch) ? 1.0 : 0.5
            }
        }
    }
}