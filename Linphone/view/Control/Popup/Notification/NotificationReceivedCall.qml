import QtQuick 2.7
import QtQuick.Layouts 1.3
import Linphone
import UtilsCpp
// =============================================================================

Notification {
	id: mainWindow
	radius: 20 * mainWindow.dp
	//overriddenWidth: content.implicitWidth//101 * mainWindow.dp
	//overriddenHeight: content.implicitHeight//422 * mainWindow.dp
	width: content.implicitWidth
	height: content.implicitHeight
	readonly property var call: notificationData && notificationData.call
	property var state: call.core.state
	property var status: call.core.status
	onStateChanged:{
		if (state != LinphoneEnums.CallState.IncomingReceived){
			close()
		}
	}
	onStatusChanged:{
		console.log("status", status)
	}
	
	Popup {
		id: content
		visible: mainWindow.visible
		leftPadding: 19 * mainWindow.dp
		rightPadding: 19 * mainWindow.dp
		topPadding: 15 * mainWindow.dp
		bottomPadding: 15 * mainWindow.dp
		
		background: Item{}
		contentItem: RowLayout {
			id: notifContent
			spacing: 30 * mainWindow.dp
			RowLayout {
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.alignment: Qt.AlignLeft
				spacing: 13 * mainWindow.dp
				Avatar {
					Layout.preferredWidth: 45 * mainWindow.dp
					Layout.preferredHeight: 45 * mainWindow.dp
					call: mainWindow.call
				}
				ColumnLayout {
					Text {
						property var remoteAddress: UtilsCpp.getDisplayName(call.core.remoteAddress)
						text: remoteAddress ? remoteAddress.value : ""
						color: DefaultStyle.grey_600
						font {
							pixelSize: 20 * mainWindow.dp
							weight: 800 * mainWindow.dp
							capitalization: Font.Capitalize
						}
					}
					RowLayout {
						EffectImage {
							imageSource: AppIcons.arrowDownLeft
							colorizationColor: DefaultStyle.success_500main
							Layout.preferredWidth: 24 * mainWindow.dp
							Layout.preferredHeight: 24 * mainWindow.dp
						}
						Text {
							Layout.fillWidth: true
							property var localAddress: UtilsCpp.getDisplayName(call.core.localAddress)
							text: qsTr("Appel entrant")//.arg(localAddress ? qsTr(" pour %1").arg(localAddress.value) : "") //call.core.remoteAddress
							color: DefaultStyle.grey_600
							font {
								pixelSize: 13 * mainWindow.dp
								weight: 400 * mainWindow.dp
							}
						}
					}
				}
			}
		
			RowLayout {
				Layout.alignment: Qt.AlignHCenter
				Layout.fillWidth: true
				spacing: 26 * mainWindow.dp
				Button {
					color: DefaultStyle.success_500main
					Layout.preferredWidth: 75 * mainWindow.dp
					Layout.preferredHeight: 55 * mainWindow.dp
					asynchronous: false
					contentItem: EffectImage {
						colorizationColor: DefaultStyle.grey_0
						imageSource: AppIcons.phone
						imageWidth: 32 * mainWindow.dp
						imageHeight: 32 * mainWindow.dp
					}
					onClicked: {
						console.debug("[NotificationReceivedCall] Accept click")
						UtilsCpp.openCallsWindow(mainWindow.call)
						mainWindow.call.core.lAccept(false)
					}
				}
				Button {
					color: DefaultStyle.danger_500main
					Layout.preferredWidth: 75 * mainWindow.dp
					Layout.preferredHeight: 55 * mainWindow.dp
					asynchronous: false
					contentItem: EffectImage {
						colorizationColor: DefaultStyle.grey_0
						imageSource: AppIcons.endCall
						imageWidth: 32 * mainWindow.dp
						imageHeight: 32 * mainWindow.dp
					}
					onClicked: {
						console.debug("[NotificationReceivedCall] Decline click")
						mainWindow.call.core.lDecline()
					}
				}
			}
		}
	}

}
