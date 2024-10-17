import QtQuick
import QtQuick.Controls.Basic as Control
import QtQuick.Layouts as Layout
import QtQuick.Effects
import Linphone
import UtilsCpp
import LinphoneCallsCpp

Control.Popup {
	id: mainItem
	closePolicy: Control.Popup.CloseOnEscape
	leftPadding: 72 * mainWindow.dp
	rightPadding: 72 * mainWindow.dp
	topPadding: 41 * mainWindow.dp
	bottomPadding: 18 * mainWindow.dp
	property bool closeButtonVisible: true
	property bool roundedBottom: false
	property bool lastRowVisible: true
	property var currentCall
	onOpened: numPad.forceActiveFocus()
	signal buttonPressed(string text)
	signal launchCall()
	signal wipe()

	background: Item {
		anchors.fill: parent
		Rectangle {
			id: numPadBackground
			width: parent.width
			height: parent.height
			color: DefaultStyle.grey_100
			radius: 20 * mainWindow.dp
		}
		MultiEffect {
			id: effect
			anchors.fill: numPadBackground
			source: numPadBackground
			shadowEnabled: true
			shadowColor: DefaultStyle.grey_1000
			shadowOpacity: 0.1
			shadowBlur: 0.1
			z: -1
		}
		Rectangle {
			width: parent.width
			height: parent.height / 2
			anchors.bottom: parent.bottom
			color: DefaultStyle.grey_100
			visible: !mainItem.roundedBottom
		}
		MouseArea {
			anchors.fill: parent
			onClicked: numPad.forceActiveFocus()
		}
		Button {
			id: closeButton
			visible: mainItem.closeButtonVisible
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.topMargin: 10 * mainWindow.dp
			anchors.rightMargin: 10 * mainWindow.dp
			background: Item {
				anchors.fill: parent
				visible: false
			}
			icon.source: AppIcons.closeX
			width: 24 * mainWindow.dp
			height: 24 * mainWindow.dp
			icon.width: 24 * mainWindow.dp
			icon.height: 24 * mainWindow.dp
			onClicked: mainItem.close()
		}
	}
	contentItem: NumericPad{
		id: numPad
		lastRowVisible: lastRowVisible
		currentCall: mainItem.currentCall
		onButtonPressed: (text) => {
			console.log("BUTTON PRESSED NUMPAD")
			mainItem.buttonPressed(text)
		}
		onLaunchCall: mainItem.launchCall()
		onWipe: mainItem.wipe()
	}
}
