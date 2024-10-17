import QtQuick 2.7
import QtQuick.Controls.Basic 2.2 as Control
import QtQuick.Effects
import QtQuick.Layouts
import Linphone
  
Button {
	id: mainItem
	textSize: Typography.b3.pixelSize
	textWeight: Typography.b3.weight
	color: DefaultStyle.main1_100
	textColor: DefaultStyle.main1_500_main
	leftPadding: 16 * mainWindow.dp
	rightPadding: 16 * mainWindow.dp
	topPadding: 10 * mainWindow.dp
	bottomPadding: 10 * mainWindow.dp
}
