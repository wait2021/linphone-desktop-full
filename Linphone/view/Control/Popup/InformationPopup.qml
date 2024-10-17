import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Linphone

Popup {
	id: mainItem
	property bool isSuccess: true
	property string title
	property string description
	property int index
	signal closePopup(int index)
	onClosed: closePopup(index)
	onAboutToShow: {
		autoClosePopup.restart()
	}
	closePolicy: Popup.NoAutoClose
	x : parent.x + parent.width - width
	// y : parent.y + parent.height - height
	rightMargin: 20 * mainWindow.dp
	bottomMargin: 20 * mainWindow.dp
	padding: 20 * mainWindow.dp
	underlineColor: mainItem.isSuccess ? DefaultStyle.success_500main : DefaultStyle.danger_500main
	radius: 0
	onHoveredChanged: {
		if (hovered) autoClosePopup.stop()
		else autoClosePopup.restart()
	}
	Timer {
		id: autoClosePopup
		interval: 5000
		onTriggered: {
			mainItem.close()
		} 
	}
	contentItem: RowLayout {
		spacing: 24 * mainWindow.dp
		EffectImage {
			imageSource: mainItem.isSuccess ? AppIcons.smiley : AppIcons.smileySad
			colorizationColor: mainItem.isSuccess ? DefaultStyle.success_500main : DefaultStyle.danger_500main
			Layout.preferredWidth: 32 * mainWindow.dp
			Layout.preferredHeight: 32 * mainWindow.dp
			width: 32 * mainWindow.dp
			height: 32 * mainWindow.dp
		}
		Rectangle {
			Layout.preferredWidth: 1 * mainWindow.dp
			Layout.preferredHeight: parent.height
			color: DefaultStyle.main2_200
		}
		ColumnLayout {
			spacing: 2 * mainWindow.dp
			RowLayout {
				spacing: 0
				Text {
					Layout.fillWidth: true
					text: mainItem.title
					color: mainItem.isSuccess ? DefaultStyle.success_500main : DefaultStyle.danger_500main
					font {
						pixelSize: 16 * mainWindow.dp
						weight: 800 * mainWindow.dp
					}
				}
				Button {
					Layout.preferredWidth: 20 * mainWindow.dp
					Layout.preferredHeight: 20 * mainWindow.dp
					icon.width: 20 * mainWindow.dp
					icon.height: 20 * mainWindow.dp
					Layout.alignment: Qt.AlignTop | Qt.AlignRight
					visible: mainItem.hovered || hovered
					background: Item{}
					icon.source: AppIcons.closeX
					onClicked: mainItem.close()
				}
			}
			Text {
				Layout.alignment: Qt.AlignHCenter
				Layout.fillWidth: true
				Layout.maximumWidth: 300 * mainWindow.dp
				text: mainItem.description
				wrapMode: Text.WordWrap
				color: DefaultStyle.main2_500main
				font {
					pixelSize: 12 * mainWindow.dp
					weight: 300 * mainWindow.dp
				}
			}
		}
	}
}
