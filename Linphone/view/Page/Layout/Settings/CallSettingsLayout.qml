
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import Linphone
import SettingsCpp 1.0

AbstractSettingsLayout {
	contentComponent: content
	width: parent?.width
	Component {
		id: content
		ColumnLayout {
			RowLayout {
				spacing: 47 * mainWindow.dp
				ColumnLayout {
					Item {
						Layout.preferredWidth: 341 * mainWindow.dp
					}
				}
				ColumnLayout {
					Layout.rightMargin: 25 * mainWindow.dp
					Layout.topMargin: 36 * mainWindow.dp
					spacing: 20 * mainWindow.dp
					SwitchSetting {
						titleText: qsTr("Annulateur d'écho")
						subTitleText: qsTr("Évite que de l'écho soit entendu par votre correspondant")
						propertyName: "echoCancellationEnabled"
						propertyOwner: SettingsCpp
					}
					SwitchSetting {
						Layout.fillWidth: true
						titleText: qsTr("Activer l’enregistrement automatique des appels")
						subTitleText: qsTr("Enregistrer tous les appels par défaut")
						propertyName: "automaticallyRecordCallsEnabled"
						propertyOwner: SettingsCpp
						visible: !SettingsCpp.disableCallRecordings
					}
				}
			}
			Rectangle {
				Layout.fillWidth: true
				Layout.preferredHeight: 1 * mainWindow.dp
				color: DefaultStyle.main2_500main
				Layout.topMargin: 38 * mainWindow.dp
				Layout.bottomMargin: 16 * mainWindow.dp
			}
			RowLayout {
				spacing: 47 * mainWindow.dp
				ColumnLayout {
					Item {
						Layout.preferredWidth: 341 * mainWindow.dp
						Text {
							id: periphTitle
							text: qsTr("Périphériques")
							font: Typography.p2
							wrapMode: Text.WordWrap
							color: DefaultStyle.main2_600
						}
						Text {
							anchors.top: periphTitle.bottom
							anchors.topMargin: 3 * mainWindow.dp
							anchors.left: parent.left
							anchors.right: parent.right
							text: qsTr("Vous pouvez modifier les périphériques de sortie audio, le microphone et la caméra de capture.")
							font: Typography.p1
							wrapMode: Text.WordWrap
							color: DefaultStyle.main2_600
						}
					}
					Item {
						Layout.fillHeight: true
					}
				}
				MultimediaSettings {
					ringerDevicesVisible: true
					backgroundVisible: false
					spacing: 20 * mainWindow.dp
					Layout.rightMargin: 44 * mainWindow.dp
				}
			}
		}
	}
}
