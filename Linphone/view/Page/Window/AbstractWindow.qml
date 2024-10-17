import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Linphone
import UtilsCpp 1.0
import SettingsCpp 1.0

ApplicationWindow {
	id: mainWindow
	x: 0
	y: 0
    width: Math.min(1512, Screen.desktopAvailableWidth)* mainWindow.dp
    height: Math.min(982, Screen.desktopAvailableHeight)* mainWindow.dp

	property real dp: 1/UtilsCpp.getPixelDensity(x,y)
	onDpChanged: console.log("[ApplicationWindow] new DP: "+dp)
	
	MouseArea {
		anchors.fill: parent
		onClicked: forceActiveFocus()
	}

	Component {
		id: popupComp
		InformationPopup{}
	}

	Component{
		id: confirmPopupComp
		Dialog {
			property var requestDialog
			property int index
			property var callback: requestDialog?.result
			signal closePopup(int index)
			onClosed: closePopup(index)
			text: requestDialog?.message
			details: requestDialog?.details
			// For C++, requestDialog need to be call directly
			onAccepted: requestDialog ? requestDialog.result(1) : callback(1)
			onRejected: requestDialog ? requestDialog.result(0) : callback(0)
			width: 278 * mainWindow.dp
		}
	}

	Popup {
		id: startCallPopup
		property FriendGui contact
		property bool videoEnabled
		// if currentCall, transfer call to contact
		property CallGui currentCall
		onContactChanged: {
			console.log("contact changed", contact)
		}
		underlineColor: DefaultStyle.main1_500_main
		anchors.centerIn: parent
		width: 370 * mainWindow.dp
		modal: true
		leftPadding: 15 * mainWindow.dp
		rightPadding: 15 * mainWindow.dp
		topPadding: 20 * mainWindow.dp
		bottomPadding: 25 * mainWindow.dp
		contentItem: ColumnLayout {
			spacing: 16 * mainWindow.dp
			RowLayout {
				spacing: 0
				Text {
					text: qsTr("Which channel do you choose?")
					font {
						pixelSize: 16 * mainWindow.dp
						weight: 800 * mainWindow.dp
					}
				}
				Item{Layout.fillWidth: true}
				Button {
					Layout.preferredWidth: 24 * mainWindow.dp
					Layout.preferredHeight: 24 * mainWindow.dp
					Layout.alignment: Qt.AlignVCenter
					background: Item{}
					icon.source:AppIcons.closeX
					width: 24 * mainWindow.dp
					height: 24 * mainWindow.dp
					icon.width: 24 * mainWindow.dp
					icon.height: 24 * mainWindow.dp
					contentItem: Image {
						anchors.fill: parent
						source: AppIcons.closeX
					}
					onClicked: startCallPopup.close()
				}
			}
			ListView {
				id: popuplist
				model: VariantList {
					model: startCallPopup.contact && startCallPopup.contact.core.allAddresses || []
				}
				Layout.fillWidth: true
				Layout.preferredHeight: contentHeight
				spacing: 10 * mainWindow.dp
				delegate: Item {
					width: popuplist.width
					height: 56 * mainWindow.dp
					ColumnLayout {
						width: popuplist.width
						anchors.verticalCenter: parent.verticalCenter
						spacing: 10 * mainWindow.dp
						ColumnLayout {
							spacing: 7 * mainWindow.dp
							Text {
								Layout.leftMargin: 5 * mainWindow.dp
								text: modelData.label + " :"
								font {
									pixelSize: 13 * mainWindow.dp
									weight: 700 * mainWindow.dp
								}
							}
							Text {
								Layout.leftMargin: 5 * mainWindow.dp
								text: modelData.address
								font {
									pixelSize: 14 * mainWindow.dp
									weight: 400 * mainWindow.dp
								}
							}
						}
						Rectangle {
							visible: index != popuplist.model.count - 1
							Layout.fillWidth: true
							Layout.preferredHeight: 1 * mainWindow.dp
							color: DefaultStyle.main2_200
						}
					}
					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
						onClicked: {
							if (startCallPopup.currentCall) startCallPopup.currentCall.core.lTransferCall(modelData.address)
							else UtilsCpp.createCall(modelData.address, {'localVideoEnabled': startCallPopup.videoEnabled})
						}
					}
				}
			}
		}
	}

	function startCallWithContact(contact, videoEnabled, parentItem) {
		if (parentItem == undefined) parentItem = mainWindow.contentItem
		startCallPopup.parent = parentItem
		if (contact) {
			console.log("START CALL WITH", contact.core.displayName, "addresses count", contact.core.allAddresses.length)
			if (contact.core.allAddresses.length > 1) {
				startCallPopup.contact = contact
				startCallPopup.videoEnabled = videoEnabled
				startCallPopup.open()

			} else {
				var addressToCall = contact.core.defaultAddress.length === 0 
					? contact.core.phoneNumbers.length === 0
						? ""
						: contact.core.phoneNumbers[0].address
					: contact.core.defaultAddress
				if (addressToCall.length != 0) UtilsCpp.createCall(addressToCall, {'localVideoEnabled':videoEnabled})
			}
		}
	}

	function transferCallToContact(call, contact, parentItem) {
		if (!call || !contact) return
		if (parentItem == undefined) parentItem = mainWindow.contentItem
		startCallPopup.parent = parentItem
		if (contact) {
			console.log("TRANSFER CALL TO", contact.core.displayName, "addresses count", contact.core.allAddresses.length, call)
			if (contact.core.allAddresses.length > 1) {
				startCallPopup.contact = contact
				startCallPopup.currentCall = call
				startCallPopup.open()

			} else {
				var addressToCall = contact.core.defaultAddress.length === 0 
					? contact.core.phoneNumbers.length === 0
						? ""
						: contact.core.phoneNumbers[0].address
					: contact.core.defaultAddress
				if (addressToCall.length != 0) call.core.lTransferCall(contact.core.defaultAddress)
			}
		}
	}

	function removeFromPopupLayout(index) {
		popupLayout.popupList.splice(index, 1)
	}
	function showInformationPopup(title, description, isSuccess) {
		if (isSuccess == undefined) isSuccess = true
		var infoPopup = popupComp.createObject(popupLayout, {"title": title, "description": description, "isSuccess": isSuccess})
		infoPopup.index = popupLayout.popupList.length
		popupLayout.popupList.push(infoPopup)
		infoPopup.open()
		infoPopup.closePopup.connect(removeFromPopupLayout)
	}
	function showLoadingPopup(text, cancelButtonVisible) {
		if (cancelButtonVisible == undefined) cancelButtonVisible = false
		loadingPopup.text = text
		loadingPopup.cancelButtonVisible = cancelButtonVisible
		loadingPopup.open()
	}
	function closeLoadingPopup() {
		loadingPopup.close()
	}

	function showConfirmationPopup(requestDialog){
		console.log("Showing confirmation popup")
		var popup = confirmPopupComp.createObject(popupLayout, {"requestDialog": requestDialog})
		popup.index = popupLayout.popupList.length
		popupLayout.popupList.push(popup)
		popup.open()
		popup.closePopup.connect(removeFromPopupLayout)
	}
	
	function showConfirmationLambdaPopup(title,details,callback){
		console.log("Showing confirmation lambda popup")
		var popup = confirmPopupComp.createObject(popupLayout, {"text": title, "details":details,"callback":callback})
		popup.index = popupLayout.popupList.length
		popupLayout.popupList.push(popup)
		popup.open()
		popup.closePopup.connect(removeFromPopupLayout)
	}
	
	ColumnLayout {
		id: popupLayout
		anchors.fill: parent
		Layout.alignment: Qt.AlignBottom
		property int nextY: mainWindow.height
		property list<InformationPopup> popupList
		property int popupCount: popupList.length
		spacing: 15 * mainWindow.dp
		onPopupCountChanged: {
			nextY = mainWindow.height
			for(var i = 0; i < popupCount; ++i) {
				popupList[i].y = nextY - popupList[i].height
				popupList[i].index = i
				nextY = nextY - popupList[i].height - 15
			}
		}
	}

	LoadingPopup {
		id: loadingPopup
		modal: true
		closePolicy: Popup.NoAutoClose
		anchors.centerIn: parent
		padding: 20 * mainWindow.dp
		underlineColor: DefaultStyle.main1_500_main
		radius: 15 * mainWindow.dp
	}
	FPSCounter{
		anchors.top: parent.top
		anchors.left: parent.left
		height: 50
		width: fpsText.implicitWidth
		z: 100
		visible: !SettingsCpp.hideFps
		Text{
			id: fpsText
			font.bold: true
			font.italic: true
			font.pixelSize: 14 * mainWindow.dp
			text: parent.fps + " FPS"
			color: parent.fps < 30 ? DefaultStyle.danger_500main : DefaultStyle.main2_900
		}
	}
}
