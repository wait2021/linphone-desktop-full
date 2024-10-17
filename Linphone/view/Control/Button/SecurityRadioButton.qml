import QtQuick
import QtQuick.Controls.Basic as Control
import QtQuick.Layouts
import Linphone
  
Control.RadioButton {
	id: mainItem
	property string title
	property string contentText
	property string imgUrl
	property color color
	hoverEnabled: true

	MouseArea {
		anchors.fill: parent
		hoverEnabled: false
		cursorShape: mainItem.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor
		onClicked: if (!mainItem.checked) mainItem.toggle()
	}

	background: Rectangle {
		color: DefaultStyle.grey_100
		border.color: mainItem.checked ? mainItem.color : "transparent"
		radius: 20 * mainWindow.dp
	}

	indicator: RowLayout {
		anchors.left: parent.left
		anchors.leftMargin: 13 * mainWindow.dp
		anchors.top: parent.top
		anchors.topMargin: 8 * mainWindow.dp
		spacing: 4 * mainWindow.dp
		Rectangle {
			implicitWidth: 16 * mainWindow.dp
			implicitHeight: 16 * mainWindow.dp
			radius: implicitWidth/2
			border.color: mainItem.color

			Rectangle {
				width: parent.width/2
				height: parent.height/2
				x: parent.width/4
				y: parent.width/4
				radius: width/2
				color: mainItem.color
				visible: mainItem.checked
			}
		}
		Text {
			visible: mainItem.title.length > 0
			text: mainItem.title
			font.bold: true
			color: DefaultStyle.grey_900
			font.pixelSize: 16 * mainWindow.dp
		}
		Button {
			padding: 0
			background: Item {
				visible: false
			}
			icon.source: AppIcons.info
			Layout.preferredWidth: 2 * mainWindow.dp
			Layout.preferredHeight: 2 * mainWindow.dp
			width: 2 * mainWindow.dp
			height: 2 * mainWindow.dp
			icon.width: 2 * mainWindow.dp
			icon.height: 2 * mainWindow.dp
		}
	}
	
	contentItem: ColumnLayout {
		anchors.top: indicator.bottom
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin: 13 * mainWindow.dp
		RowLayout {
			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.bottomMargin: 10 * mainWindow.dp
			Layout.rightMargin: 10 * mainWindow.dp
			Layout.alignment: Qt.AlignVCenter
			Text {
				id: innerText
				verticalAlignment: Text.AlignVCenter
				Layout.preferredWidth: 220 * mainWindow.dp
				Layout.preferredHeight: 100 * mainWindow.dp
				font.pixelSize: 14 * mainWindow.dp
				text: mainItem.contentText
				Layout.fillHeight: true
			}
			Image {
				id: image
				Layout.fillHeight: true
				Layout.preferredWidth: 100 * mainWindow.dp
				Layout.preferredHeight: 100 * mainWindow.dp
				fillMode: Image.PreserveAspectFit
				source: mainItem.imgUrl
			}
		}
	}
}
