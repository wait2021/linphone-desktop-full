import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import Linphone

Control.Page {
	id: mainItem
	property alias headerStack: headerStack
	property alias contentStackView: contentStackView
	property alias customHeaderButtons: customButtonLayout.children
	property bool closeButtonVisible: true
	clip: true

	property string headerTitleText
	property string headerSubtitleText
	property string headerValidateButtonText
	signal returnRequested()
	signal validateRequested()

	topPadding: 16 * mainWindow.dp
	// bottomPadding: 16 * mainWindow.dp

	background: Rectangle {
		width: mainItem.width
		height: mainItem.height
		color: DefaultStyle.grey_100
		radius: 15 * mainWindow.dp
	}
	
	header: Control.Control {
		id: pageHeader
		width: mainItem.width
		height: 56 * mainWindow.dp
		leftPadding: 10 * mainWindow.dp
		rightPadding: 10 * mainWindow.dp
		background: Rectangle {
			id: headerBackground
			width: pageHeader.width
			height: pageHeader.height
			color: DefaultStyle.grey_0
			radius: 15 * mainWindow.dp
			Rectangle {
				y: pageHeader.height/2
				height: pageHeader.height/2
				width: pageHeader.width
			}
		}
		contentItem: StackLayout {
			id: headerStack
			RowLayout {
				Layout.alignment: Qt.AlignVCenter
				spacing: 10 * mainWindow.dp
				Text {
					text: mainItem.headerTitleText
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.alignment: Qt.AlignVCenter
					verticalAlignment: Text.AlignVCenter
					color: DefaultStyle.main1_500_main
					font {
						pixelSize: 16 * mainWindow.dp
						weight: 800 * mainWindow.dp
					}
				}
				RowLayout {
					id: customButtonLayout
				}
				Button {
					id: closeButton
					visible: mainItem.closeButtonVisible
					background: Item {
						visible: false
					}
					icon.source: AppIcons.closeX
					Layout.preferredWidth: 24 * mainWindow.dp
					Layout.preferredHeight: 24 * mainWindow.dp
					icon.width: 24 * mainWindow.dp
					icon.height: 24 * mainWindow.dp
					onClicked: mainItem.visible = false
				}
			}
			RowLayout {
				Layout.alignment: Qt.AlignVCenter
				spacing: 10 * mainWindow.dp
				Button {
					background: Item{}
					icon.source: AppIcons.leftArrow
					icon.width: 24 * mainWindow.dp
					icon.height: 24 * mainWindow.dp
					contentImageColor: DefaultStyle.main1_500_main
					onClicked: mainItem.returnRequested()
				}
				ColumnLayout {
					spacing: 0
					Text {
						Layout.alignment: Qt.AlignVCenter
						verticalAlignment: Text.AlignVCenter
						text: mainItem.headerTitleText
						color: DefaultStyle.main1_500_main
						font {
							pixelSize: 16 * mainWindow.dp
							weight: 800 * mainWindow.dp
						}
					}
					Text {
					Layout.alignment: Qt.AlignVCenter
					verticalAlignment: Text.AlignVCenter

						text: mainItem.headerSubtitleText
						color: DefaultStyle.main2_500main
						font {
							pixelSize: 12 * mainWindow.dp
							weight: 300 * mainWindow.dp
						}
					}
				}
				Item {
					Layout.fillWidth: true
					Layout.fillHeight: true
				}
				Button {
					text: mainItem.headerValidateButtonText
					textSize: 13 * mainWindow.dp
					textWeight: 600 * mainWindow.dp
					onClicked: mainItem.validateRequested()
					topPadding: 6 * mainWindow.dp
					bottomPadding: 6 * mainWindow.dp
					leftPadding: 12 * mainWindow.dp
					rightPadding: 12 * mainWindow.dp
				}
			}
		}
	}
	contentItem: Control.StackView {
		id: contentStackView
	}
}
