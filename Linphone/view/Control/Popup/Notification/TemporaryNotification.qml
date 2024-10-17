import QtQuick 2.7
import QtQuick.Effects
import Linphone

Control.Control {
	id: mainItem
	// width: 269 * mainWindow.dp
	y: -height
	z: 1
	topPadding: 8 * mainWindow.dp
	bottomPadding: 8 * mainWindow.dp
	leftPadding: 37 * mainWindow.dp
	rightPadding: 37 * mainWindow.dp
	anchors.horizontalCenter: parent.horizontalCenter
	clip: true

	property string text
	property string imageSource
	property color contentColor
	property int yCoord

	signal clicked()

	function open() {
		y = mainItem.yCoord
		autoCloseNotification.restart()
	}
	MouseArea {
		anchors.fill: parent
		onClicked: mainItem.clicked()
	}
	Timer {
		id: autoCloseNotification
		interval: 4000
		onTriggered: {
			mainItem.y = -mainItem.height
		}
	}
	Behavior on y {NumberAnimation {duration: 1000}}
	background: Rectangle {
		anchors.fill: parent
		color: DefaultStyle.grey_0
		border.color: mainItem.contentColor
		border.width:  1 * mainWindow.dp
		radius: 50 * mainWindow.dp
	}
	contentItem: RowLayout {
		Image {
			visible: mainItem.imageSource != undefined
			source: mainItem.imageSource
			Layout.preferredWidth: 24 * mainWindow.dp
			Layout.preferredHeight: 24 * mainWindow.dp
			fillMode: Image.PreserveAspectFit
			Layout.fillWidth: true
		}
		Text {
			color: mainItem.contentColor
			text: mainItem.text
			Layout.fillWidth: true
			font {
				pixelSize: 14 * mainWindow.dp
			}
		}
	}
}