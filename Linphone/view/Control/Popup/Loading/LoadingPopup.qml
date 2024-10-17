import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Linphone

Popup {
	id: mainItem
	property string text
	property bool cancelButtonVisible: false
	modal: true
	closePolicy: Control.Popup.NoAutoClose
	anchors.centerIn: parent
	padding: 20 * mainWindow.dp
	underlineColor: DefaultStyle.main1_500_main
	radius: 15 * mainWindow.dp
	// onAboutToShow: width = contentText.implicitWidth
	contentItem: ColumnLayout {
		spacing: 15 * mainWindow.dp
		// width: childrenRect.width
		// height: childrenRect.height
		BusyIndicator{
			Layout.alignment: Qt.AlignHCenter
			Layout.preferredWidth: 33 * mainWindow.dp
			Layout.preferredHeight: 33 * mainWindow.dp
		}
		Text {
			id: contentText
			Layout.alignment: Qt.AlignHCenter
			Layout.fillWidth: true
			Layout.fillHeight: true
			text: mainItem.text
			font.pixelSize: 14 * mainWindow.dp
		}
		Button {
			visible: mainItem.cancelButtonVisible
			Layout.alignment: Qt.AlignHCenter
			text: qsTr("Annuler")
			onClicked: mainItem.close()
		}
	}
}
