
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import SettingsCpp 1.0
import Linphone
import UtilsCpp

AbstractSettingsLayout {
    id: mainItem
    width: parent?.width
    contentModel: [
        {
            //: Appel
            title: "Appel",
            subTitle: "",
            contentComponent: callKeyboardShortcutsComponent 
        }
    ]
	onSave: {
		SettingsCpp.save()
	}
	onUndo: SettingsCpp.undo()


	// Call shortcuts
	/////////////////

    Component {
        id: callKeyboardShortcutsComponent
        ColumnLayout {
            spacing: Math.round(20 * DefaultStyle.dp)
            KeyboardShortcutSetting{
                titleText: "Accepter l'appel"
                keySequence: "Ctrl+Shift+A"
            }
        }
    }
}