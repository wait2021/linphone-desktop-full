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
	Layout.fillHeight: true
	Layout.fillWidth: true
	color: DefaultStyle.grey_0

	signal done()
	signal selectNewAdminRequested()

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
			//: You are the group admin. You can either leave the group or end it for all participants.
			text: qsTr("admin_leave_group_description")
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
			Layout.topMargin: Utils.getSizeWithScreenRatio(5)
			//: (The group will remain visible, but messaging will be disabled.)
			text: qsTr("admin_leave_group_subtitle")
			color: DefaultStyle.main2_400
			font: Typography.p2
			wrapMode: Text.WordWrap
		}

		ColumnLayout {
			Layout.topMargin: Utils.getSizeWithScreenRatio(30)
			Layout.alignment: Qt.AlignHCenter
			spacing: Utils.getSizeWithScreenRatio(15)

			MediumButton {
				Layout.alignment: Qt.AlignHCenter
				Layout.preferredWidth: Utils.getSizeWithScreenRatio(250)
				//: Leave group only for me
				text: qsTr("admin_leave_group_leave_only")
				style: ButtonStyle.main
				onClicked: {
					if (mainItem.chatCore.adminCount <= 1) {
						mainItem.selectNewAdminRequested()
					} else {
						mainItem.chatCore.lLeaveAsAdmin(false)
						mainItem.done()
					}
				}
			}

			MediumButton {
				Layout.alignment: Qt.AlignHCenter
				Layout.preferredWidth: Utils.getSizeWithScreenRatio(250)
				//: End group for everyone
				text: qsTr("admin_leave_group_end_for_all")
				style: ButtonStyle.main
				onClicked: {
					//: End Group?
					mainWindow.showConfirmationLambdaPopup(qsTr("admin_leave_group_confirm_title"),
						//: This will end the group for all participants. The group will become read-only. Do you want to continue?
						qsTr("admin_leave_group_confirm_message"),
						"",
						function(confirmed) {
							if (confirmed) {
								mainItem.chatCore.lLeaveAsAdmin(true)
								mainItem.done()
							}
						})
				}
			}
		}

		Item {
			Layout.fillHeight: true
		}
	}
}
