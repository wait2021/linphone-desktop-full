
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import SettingsCpp 1.0
import Linphone

AbstractSettingsLayout {
	contentComponent: content
	Component {
		id: content
		Column {
			spacing: 40 * mainWindow.dp
			SwitchSetting {
				titleText: qsTr("Chiffrer tous les fichiers")
				subTitleText: qsTr("Attention, vous ne pourrez pas revenir en arrière !")
				propertyName: "vfsEnabled"
				propertyOwner: SettingsCpp
			}
		}
	}
}
