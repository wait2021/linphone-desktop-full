
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control

import Linphone

Rectangle {
	id: mainItem
	width: container.width
	height: container.height
	property string titleText
	property var contentComponent
	property var topbarOptionalComponent
	property var model
	color: 'white'
	property var container

	Control.ScrollView {
		id: scrollView
		height: parent.height
		width: parent.width - 2 * 45 * mainWindow.dp
		anchors.centerIn: parent
		contentHeight: content.height + 20 * mainWindow.dp
		contentWidth: parent.width - 2 * 45 * mainWindow.dp
		Control.ScrollBar.vertical: ScrollBar {
			active: scrollView.contentHeight > container.height
			interactive: true
			policy: Control.ScrollBar.AsNeeded
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			anchors.rightMargin: -15 * mainWindow.dp
		}
		Control.ScrollBar.horizontal: ScrollBar {
			active: false
		}
		ColumnLayout {
			id: content
			width: parent.width
			spacing: 10 * mainWindow.dp
			RowLayout {
				Layout.fillWidth: true
				Layout.topMargin: 20 * mainWindow.dp
				spacing: 5 * mainWindow.dp
				Button {
					id: backButton
					Layout.preferredHeight: 24 * mainWindow.dp
					Layout.preferredWidth: 24 * mainWindow.dp
					icon.source: AppIcons.leftArrow
					width: 24 * mainWindow.dp
					height: 24 * mainWindow.dp
					focus: true
					visible: mainItem.container.depth > 1
					Layout.rightMargin: 41 * mainWindow.dp
					onClicked: {
						mainItem.container.pop()
					}
					background: Item {
						anchors.fill: parent
					}
				}
				Text {
					text: titleText
					color: DefaultStyle.main2_600
					font: Typography.h3
				}
				Item {
					Layout.fillWidth: true
				}
				Loader {
					Layout.alignment: Qt.AlignRight
					sourceComponent: mainItem.topbarOptionalComponent
					Layout.rightMargin: 34 * mainWindow.dp
				}
			}
			Rectangle {
				Layout.fillWidth: true
				Layout.topMargin: 16 * mainWindow.dp
				height: 1 * mainWindow.dp
				color: DefaultStyle.main2_500main
			}
			Loader {
				Layout.fillWidth: true
				sourceComponent: mainItem.contentComponent
			}
			Item {
				Layout.fillHeight: true
			}
		}
	}
}

