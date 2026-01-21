import QtCore
import QtQuick
import QtQuick.Controls.Basic as Control
import QtQuick.Dialogs
import QtQuick.Effects
import QtQuick.Layouts
import Linphone
import UtilsCpp
import SettingsCpp
import 'qrc:/qt/qml/Linphone/view/Style/buttonStyle.js' as ButtonStyle
import "qrc:/qt/qml/Linphone/view/Control/Tool/Helper/utils.js" as Utils

Rectangle {
	id: mainItem
	property ChatGui chatGui
	property var chatCore: chatGui.core
	property int selectedIndex: -1
	Layout.fillHeight: true
	Layout.fillWidth: true
	color: DefaultStyle.grey_0

	signal done()

	ColumnLayout {
		id: contentColumn
		anchors.fill: parent
		anchors.leftMargin: Utils.getSizeWithScreenRatio(17)
		anchors.rightMargin: Utils.getSizeWithScreenRatio(10)
		anchors.topMargin: Utils.getSizeWithScreenRatio(17)
		spacing: Utils.getSizeWithScreenRatio(5)

		RowLayout {
			spacing: Utils.getSizeWithScreenRatio(5)
			BigButton {
				id: backButton
				style: ButtonStyle.noBackground
				icon.source: AppIcons.leftArrow
				onClicked: mainItem.done()
			}
			Text {
				//: Leave the group
				text: qsTr("admin_leave_group_title")
				color: DefaultStyle.main2_600
				maximumLineCount: 1
				font: Typography.h4
				Layout.fillWidth: true
			}
		}

		Text {
			Layout.topMargin: Utils.getSizeWithScreenRatio(20)
			Layout.fillWidth: true
			Layout.leftMargin: Utils.getSizeWithScreenRatio(10)
			Layout.rightMargin: Utils.getSizeWithScreenRatio(10)
			//: You are the last remaining administrator. Please select a participant to transfer the administrator role to before leaving the group.
			text: qsTr("select_new_admin_description")
			color: DefaultStyle.main2_600
			font {
				pixelSize: Typography.p1.pixelSize
				weight: Font.Bold
			}
			wrapMode: Text.WordWrap
		}

		Text {
			Layout.fillWidth: true
			Layout.leftMargin: Utils.getSizeWithScreenRatio(10)
			Layout.rightMargin: Utils.getSizeWithScreenRatio(10)
			Layout.topMargin: Utils.getSizeWithScreenRatio(15)
			//: Select a participant from the list below.
			text: qsTr("select_new_admin_subtitle")
			color: DefaultStyle.main2_400
			font: Typography.p2
			wrapMode: Text.WordWrap
		}

		ListView {
			id: participantsList
			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.topMargin: Utils.getSizeWithScreenRatio(15)
			Layout.bottomMargin: Utils.getSizeWithScreenRatio(80)
			clip: true
			model: mainItem.chatCore.participants
			spacing: Utils.getSizeWithScreenRatio(8)

			Control.ScrollBar.vertical: ScrollBar {
				anchors.right: parent.right
				visible: participantsList.contentHeight > participantsList.height
			}

			delegate: Rectangle {
				width: participantsList.width - Utils.getSizeWithScreenRatio(10)
				height: Utils.getSizeWithScreenRatio(56)
				color: mainItem.selectedIndex === index ? DefaultStyle.main1_100 : "transparent"
				radius: Utils.getSizeWithScreenRatio(8)

				property var participantGui: modelData
				property var participantCore: participantGui.core
				property var contactObj: UtilsCpp.findFriendByAddress(participantCore.sipAddress)

				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: mainItem.selectedIndex = index
				}

				RowLayout {
					anchors.fill: parent
					anchors.leftMargin: Utils.getSizeWithScreenRatio(10)
					anchors.rightMargin: Utils.getSizeWithScreenRatio(10)
					spacing: Utils.getSizeWithScreenRatio(10)

					Avatar {
						contact: contactObj?.value || null
						displayNameVal: participantCore.displayName
						Layout.preferredWidth: Utils.getSizeWithScreenRatio(45)
						Layout.preferredHeight: Utils.getSizeWithScreenRatio(45)
					}

					Text {
						text: participantCore.displayName
						font: Typography.p1
						color: DefaultStyle.main2_700
						Layout.fillWidth: true
						elide: Text.ElideRight
					}
				}
			}
		}

		MediumButton {
			Layout.alignment: Qt.AlignHCenter
			Layout.bottomMargin: Utils.getSizeWithScreenRatio(20)
			Layout.preferredWidth: Utils.getSizeWithScreenRatio(200)
			//: Leave the group
			text: qsTr("select_new_admin_leave_button")
			style: ButtonStyle.main
			enabled: mainItem.selectedIndex >= 0
			onClicked: {
				if (mainItem.selectedIndex >= 0) {
					mainItem.chatCore.lAssignAdminAndLeave(mainItem.selectedIndex)
					mainItem.done()
				}
			}
		}
	}
}
