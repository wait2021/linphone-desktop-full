
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import SettingsCpp 1.0
import Linphone

AbstractSettingsLayout {
	contentComponent: content
	Component {
		id: content
		ColumnLayout {
			spacing: 5 * mainWindow.dp
			RowLayout {
				spacing: 5 * mainWindow.dp
				ColumnLayout {
					Layout.fillWidth: true
					spacing: 5 * mainWindow.dp
					ColumnLayout {
						Layout.preferredWidth: 341 * mainWindow.dp
						Layout.maximumWidth: 341 * mainWindow.dp
						spacing: 5 * mainWindow.dp
						Text {
							text: qsTr("Réseau")
							font: Typography.h4
							wrapMode: Text.WordWrap
							color: DefaultStyle.main2_600
							Layout.fillWidth: true
						}
					}
					Item {
						Layout.fillHeight: true
					}
				}
				ColumnLayout {
					Layout.rightMargin: 25 * mainWindow.dp
					Layout.topMargin: 36 * mainWindow.dp
					Layout.leftMargin: 64 * mainWindow.dp
					spacing: 40 * mainWindow.dp
					SwitchSetting {
						Layout.fillWidth: true
						titleText: qsTr("Autoriser l'IPv6")
						propertyName: "ipv6Enabled"
						propertyOwner: SettingsCpp
					}
				}
			}
		}
	}
}

