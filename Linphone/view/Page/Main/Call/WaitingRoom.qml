import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Basic as Control
import Linphone
import UtilsCpp 1.0
import LinphoneAccountsCpp

RowLayout {
	id: mainItem
	property alias localVideoEnabled: preview.videoEnabled
	property bool microEnabled: true
	property bool settingsButtonChecked: settingsButton.checked
	property ConferenceInfoGui conferenceInfo
	signal joinConfRequested(string uri)
	signal cancelJoiningRequested()
	RowLayout {
		Layout.fillWidth: false
		Layout.fillHeight: false
		spacing: 100 * mainWindow.dp
		Layout.alignment: Qt.AlignCenter
		ColumnLayout {
			spacing: 31 * mainWindow.dp
			Sticker {
				id: preview
				previewEnabled: true
				Layout.preferredHeight: 330 * mainWindow.dp
				Layout.preferredWidth: 558 * mainWindow.dp
				qmlName: "WP"
				displayAll: false
				displayPresence: false
				mutedStatus: microButton.checked
				AccountProxy {
					id: accounts
				}
				account: accounts.defaultAccount
			}
			RowLayout {
				Layout.alignment: Qt.AlignHCenter
				spacing: 16 * mainWindow.dp
				CheckableButton {
					id: videoButton
					iconUrl: AppIcons.videoCamera
					checkedIconUrl: AppIcons.videoCameraSlash
					checked: !mainItem.localVideoEnabled
					color: DefaultStyle.grey_500
					contentImageColor: DefaultStyle.main2_0
					Layout.preferredWidth: 55 * mainWindow.dp
					Layout.preferredHeight: 55 * mainWindow.dp
					icon.width: 32 * mainWindow.dp
					icon.height: 32 * mainWindow.dp
					onClicked: mainItem.localVideoEnabled = !mainItem.localVideoEnabled
				}
				CheckableButton {
					id: microButton
					iconUrl: AppIcons.microphone
					checkedIconUrl: AppIcons.microphoneSlash
					color: DefaultStyle.grey_500
					contentImageColor: DefaultStyle.main2_0
					Layout.preferredWidth: 55 * mainWindow.dp
					Layout.preferredHeight: 55 * mainWindow.dp
					icon.width: 32 * mainWindow.dp
					icon.height: 32 * mainWindow.dp
					onCheckedChanged: mainItem.microEnabled = !mainItem.microEnabled
				}
				CheckableButton {
					id: settingsButton
					visible: stackLayout.currentIndex === 0
					icon.source: AppIcons.more
					color: DefaultStyle.grey_500
					checkedColor: DefaultStyle.main2_100
					contentImageColor: checked ? DefaultStyle.grey_500 : DefaultStyle.grey_0
					Layout.preferredWidth: 55 * mainWindow.dp
					Layout.preferredHeight: 55 * mainWindow.dp
					icon.width: 24 * mainWindow.dp
					icon.height: 24 * mainWindow.dp
				}
				CheckableButton {
					id: speakerButton
					visible: stackLayout.currentIndex === 1
					iconUrl: AppIcons.speaker
					checkedIconUrl: AppIcons.speakerSlash
					color: DefaultStyle.grey_500
					contentImageColor: DefaultStyle.main2_0
					Layout.preferredWidth: 55 * mainWindow.dp
					Layout.preferredHeight: 55 * mainWindow.dp
					icon.width: 32 * mainWindow.dp
					icon.height: 32 * mainWindow.dp
				}
			}
		}
		StackLayout {
			id: stackLayout
			currentIndex: 0
			ColumnLayout {
				spacing: 93 * mainWindow.dp
				ColumnLayout {
					Layout.topMargin: 54 * mainWindow.dp
					spacing: 0
					Text {
						Layout.fillWidth: true
						text: qsTr("Participer à :")
						color: DefaultStyle.grey_0
						font {
							pixelSize: 30 * mainWindow.dp
							weight: 300 * mainWindow.dp
						}
					}
					Text {
						Layout.fillWidth: true
						text: mainItem.conferenceInfo && mainItem.conferenceInfo.core.subject
						color: DefaultStyle.grey_0
						font {
							pixelSize: 30 * mainWindow.dp
							weight: 300 * mainWindow.dp
						}
					}
				}
				ColumnLayout {
					spacing: 5 * mainWindow.dp
					Button {
						Layout.preferredWidth: 292 * mainWindow.dp
						leftPadding: 20 * mainWindow.dp
						rightPadding: 20 * mainWindow.dp
						topPadding: 11 * mainWindow.dp
						bottomPadding: 11 * mainWindow.dp
						text: qsTr("Join")
						onClicked: {
							settingsButton.checked = false
							stackLayout.currentIndex = 1
							mainItem.joinConfRequested(mainItem.conferenceInfo.core.uri)
						}
					}
					Button {
						Layout.preferredWidth: 292 * mainWindow.dp
						leftPadding: 20 * mainWindow.dp
						rightPadding: 20 * mainWindow.dp
						bottomPadding: 11 * mainWindow.dp
						inversedColors: true
						text: qsTr("Cancel")
						onClicked: {
							mainItem.cancelJoiningRequested()
						}
					}
				}
			}
			ColumnLayout {
				spacing: 37 * mainWindow.dp
				ColumnLayout {
					spacing: 13 * mainWindow.dp
					Text {
						Layout.fillWidth: true
						text: qsTr("Connexion à la réunion")
						color: DefaultStyle.grey_0
						font {
							pixelSize: 30 * mainWindow.dp
							weight: 300 * mainWindow.dp
						}
					}
					Text {
						Layout.fillWidth: true
						text: qsTr("Vous allez rejoindre la réunion dans quelques instants...")
						color: DefaultStyle.grey_0
						font {
							pixelSize: 14 * mainWindow.dp
							weight: 400 * mainWindow.dp
						}
					}
				}
				BusyIndicator {
					indicatorColor: DefaultStyle.main1_500_main
					Layout.alignment: Qt.AlignHCenter
					Layout.preferredWidth: 48 * mainWindow.dp
					Layout.preferredHeight: 48 * mainWindow.dp
				}
			}
		}
	}
}
