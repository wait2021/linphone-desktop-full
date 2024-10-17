import QtQuick
import QtQuick.Controls.Basic as Control
import QtQuick.Effects

import Linphone

Control.Switch {
    id: mainItem
    property bool shadowEnabled: mainItem.hovered || mainItem.activeFocus
    hoverEnabled: true
	font {
		pixelSize: 14 * mainWindow.dp
		weight: 400 * mainWindow.dp
	}
    indicator: Item{
		implicitWidth: 32 * mainWindow.dp
		implicitHeight: 20 * mainWindow.dp
		x: mainItem.leftPadding
		y: parent.height / 2 - height / 2
		Rectangle {
			id: indicatorBackground
			anchors.fill: parent			
			radius: 10 * mainWindow.dp
			color: mainItem.checked? DefaultStyle.success_500main : DefaultStyle.main2_400
	
			Rectangle {
				anchors.verticalCenter: parent.verticalCenter
				property int margin: 4 * mainWindow.dp
				x: mainItem.checked ? parent.width - width - margin : margin
				width: 12 * mainWindow.dp
				height: 12 * mainWindow.dp
				radius: 10 * mainWindow.dp
				color: DefaultStyle.grey_0
				Behavior on x {
					NumberAnimation{duration: 100}
				}
			}
		}
        MultiEffect {
			enabled: mainItem.shadowEnabled
			anchors.fill: indicatorBackground
			source: indicatorBackground
			visible:  mainItem.shadowEnabled
			// Crash : https://bugreports.qt.io/browse/QTBUG-124730
			shadowEnabled: true //mainItem.shadowEnabled
			shadowColor: DefaultStyle.grey_1000
			shadowBlur: 0.1
			shadowOpacity: mainItem.shadowEnabled ? 0.5 : 0.0
		}
    }

    contentItem: Text {
        text: mainItem.text
        font: mainItem.font
        opacity: enabled ? 1.0 : 0.3
        verticalAlignment: Text.AlignVCenter
        leftPadding: mainItem.indicator.width + mainItem.spacing
    }
}
