import QtQuick
import QtQuick.Controls as Control
import 'qrc:/qt/qml/Linphone/view/Control/Tool/Helper/utils.js' as Utils

Control.TextField {

    id: root
    property string keySequence
    property string savedKeySequence: keySequence
    placeholderText: "Press a key sequence"

    onFocusChanged: {
        if (focus) {
            savedKeySequence = keySequence
        } else {
            if (keySequence === StandardKey.Undefined) {
                keySequence = savedKeySequence
            }
            savedKeySequence = StandardKey.Undefined
        }
    }

    Keys.onPressed: event => {
        var keys = []
        event.accepted = true

        // If escape key, stop
        if (event.key === Qt.Key_Escape) {
            return
        }

        if (event.modifiers & Qt.ControlModifier)
        keys.push("Ctrl")
        if (event.modifiers & Qt.AltModifier)
        keys.push("Alt")
        if (event.modifiers & Qt.ShiftModifier)
        keys.push("Shift")
        if (event.modifiers & Qt.MetaModifier)
        keys.push("Meta")

        // https://doc.qt.io/qt-6/qt.html#Key-enum
        if (event.key !== Qt.Key_Control &&
            event.key !== Qt.Key_Shift &&
            event.key !== Qt.Key_Alt &&
            event.key !== Qt.Key_Meta) {
            console.log(event.key)
            console.log(event.text)
            console.log(event.text.toUpperCase())
            var key = event.text
            var keyupper = event.text.toUpperCase()
            console.log(key)
            console.log(keyupper)
            keys.push(event.text.toUpperCase())
        }

        var seqString = keys.join("+")
        if (seqString.length > 0) {
            root.keySequence = seqString
            root.text = seqString
        }

    }
}
