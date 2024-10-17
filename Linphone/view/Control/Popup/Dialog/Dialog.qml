import QtQuick
import QtQuick.Controls.Basic as Control
import QtQuick.Effects
import QtQuick.Layouts
import Linphone
  
Popup {
	id: mainItem
	modal: true
	anchors.centerIn: parent
	closePolicy: Control.Popup.NoAutoClose
	rightPadding: 10 * mainWindow.dp
	leftPadding: 10 * mainWindow.dp
	topPadding: 10 * mainWindow.dp
	bottomPadding: 10 * mainWindow.dp
	underlineColor: DefaultStyle.main1_500_main
	property int radius: 16 * mainWindow.dp
	property string title
	property string text
	property string details
  	property alias content: contentLayout.data
  	property alias buttons: buttonsLayout.data
	property alias firstButton: firstButtonId
	property alias secondButton: secondButtonId
	property bool firstButtonAccept: true
	property bool secondButtonAccept: false

	signal accepted()
	signal rejected()

	contentItem: FocusScope {
		implicitWidth: child.implicitWidth
		implicitHeight: child.implicitHeight
		onVisibleChanged: {
			if(visible) forceActiveFocus()
		}
		Keys.onPressed: (event) => {
			if(visible && event.key == Qt.Key_Escape){
				mainItem.close()
				event.accepted = true
			}
		}
		ColumnLayout {
			id: child
			anchors.fill: parent
			spacing: 15 * mainWindow.dp
			
			Text{
				id: titleText
				Layout.fillWidth: true
				visible: text.length != 0
				text: mainItem.title
				font {
					pixelSize: 16 * mainWindow.dp
					weight: 800 * mainWindow.dp
				}
				wrapMode: Text.Wrap
				horizontalAlignment: Text.AlignLeft
			}
			Rectangle{
				Layout.fillWidth: true
				Layout.preferredHeight: 1
				color: DefaultStyle.main2_400
				visible: titleText.visible
			}
	
			Text {
				id: defaultText
				visible: text.length != 0
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignCenter
				text: mainItem.text
				font {
					pixelSize: 14 * mainWindow.dp
					weight: 400 * mainWindow.dp
				}
				wrapMode: Text.Wrap
				horizontalAlignment: titleText.visible ?  Text.AlignLeft : Text.AlignHCenter
			}
			Text {
				id: detailsText
				visible: text.length != 0
				Layout.fillWidth: true
				//Layout.preferredWidth: 278 * mainWindow.dp
				Layout.alignment: Qt.AlignCenter
				text: mainItem.details
				font {
					pixelSize: 13 * mainWindow.dp
					weight: 400 * mainWindow.dp
					italic: true
				}
				wrapMode: Text.Wrap
				horizontalAlignment: Text.AlignHCenter
			}
	
			ColumnLayout {
				id: contentLayout
				Layout.alignment: Qt.AlignHCenter
				Layout.fillHeight: false
			}
			
			RowLayout {
				id: buttonsLayout
				Layout.alignment: Qt.AlignBottom | ( titleText.visible ? Qt.AlignRight : Qt.AlignHCenter)
				spacing: 10 * mainWindow.dp
	
				// Default buttons only visible if no other children
				// have been set
				Button {
					id:firstButtonId
					visible: mainItem.buttons.length === 2
					text: qsTr("Oui")
					leftPadding: 20 * mainWindow.dp
					rightPadding: 20 * mainWindow.dp
					topPadding: 11 * mainWindow.dp
					bottomPadding: 11 * mainWindow.dp
					focus: !firstButtonAccept
					onClicked: {
						if(firstButtonAccept)
							mainItem.accepted()
						else
							mainItem.rejected()
						mainItem.close()
					}
					KeyNavigation.left: secondButtonId
					KeyNavigation.right: secondButtonId
				}
				Button {
					id: secondButtonId
					visible: mainItem.buttons.length === 2
					text: qsTr("Non")
					leftPadding: 20 * mainWindow.dp
					rightPadding: 20 * mainWindow.dp
					topPadding: 11 * mainWindow.dp
					bottomPadding: 11 * mainWindow.dp
					focus: !secondButtonAccept
					onClicked: {
						if(secondButtonAccept)
							mainItem.accepted()
						else
							mainItem.rejected()
						mainItem.close()
					}
					KeyNavigation.left: firstButtonId
					KeyNavigation.right: firstButtonId
				}
			}
		}
	}
}
