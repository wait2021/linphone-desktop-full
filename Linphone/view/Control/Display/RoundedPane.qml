import QtQuick
import QtQuick.Controls.Basic as Control
import Linphone

Control.Control {
	id: mainItem
	// width: 360 * mainWindow.dp
	property color backgroundColor: DefaultStyle.grey_0
	padding: 10 * mainWindow.dp
	background: Rectangle {
		anchors.fill: parent
		radius: 15 * mainWindow.dp
		color: mainItem.backgroundColor
	}
}
