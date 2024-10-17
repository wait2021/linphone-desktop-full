import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import QtQuick.Dialogs

import Linphone
import UtilsCpp
import SettingsCpp
import LinphoneAccountsCpp

Item {
	id: mainItem
	width: 517 * mainWindow.dp
	readonly property int topPadding: 23 * mainWindow.dp
	readonly property int bottomPadding: 23 * mainWindow.dp
	readonly property int leftPadding: 32 * mainWindow.dp
	readonly property int rightPadding: 32 * mainWindow.dp
	readonly property int spacing: 16 * mainWindow.dp
	property AccountProxy  accountProxy
	
	signal addAccountRequest()
	signal editAccount(AccountGui account)

	implicitHeight: list.contentHeight + topPadding + bottomPadding + 32 * mainWindow.dp + 1 + newAccountArea.height
	ColumnLayout{
		id: childLayout
		anchors.top: parent.top
		anchors.topMargin: mainItem.topPadding
		anchors.left: parent.left
		anchors.leftMargin: mainItem.leftPadding
		anchors.right: parent.right
		anchors.rightMargin: mainItem.rightPadding
		anchors.bottom: parent.bottom
		anchors.bottomMargin: mainItem.bottomPadding
		ListView{
			id: list
			Layout.preferredHeight: contentHeight
			Layout.fillWidth: true
			spacing: mainItem.spacing
			model: LinphoneAccountsCpp
			delegate: Contact{
				id: contactItem
				width: list.width
				account: modelData
				onAvatarClicked: fileDialog.open()
				onBackgroundClicked: modelData.core.lSetDefaultAccount()
				onEdit: editAccount(modelData)
				FileDialog {
					id: fileDialog
					currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
					onAccepted: {
						var avatarPath = UtilsCpp.createAvatar( selectedFile )
						if(avatarPath){
							modelData.core.pictureUri = avatarPath
						}
					}
				}
			}
		}
		Rectangle{
			id: separator
			Layout.fillWidth: true
			Layout.topMargin: mainItem.spacing
			Layout.bottomMargin: mainItem.spacing
			visible: addAccountButton.visible
			height: 1 * mainWindow.dp
			color: DefaultStyle.main2_300
		}
		MouseArea{
			id: addAccountButton
			Layout.fillWidth: true
			Layout.preferredHeight: 32 * mainWindow.dp
			visible: SettingsCpp.maxAccount == 0 || SettingsCpp.maxAccount > accountProxy.count
			onClicked: mainItem.addAccountRequest()
			RowLayout{
				id: newAccountArea
				anchors.fill: parent
				spacing: 5 * mainWindow.dp
				EffectImage {
					id: newAccount
					imageSource: AppIcons.plusCircle
					width: 32 * mainWindow.dp
					height: 32 * mainWindow.dp
					Layout.preferredWidth: 32 * mainWindow.dp
					Layout.preferredHeight: 32 * mainWindow.dp
					Layout.alignment: Qt.AlignHCenter
					fillMode: Image.PreserveAspectFit
					colorizationColor: DefaultStyle.main2_500main
				}
				Text{
					Layout.fillHeight: true
					Layout.fillWidth: true
					verticalAlignment: Text.AlignVCenter
					font.weight: 400 * mainWindow.dp
					font.pixelSize: 14 * mainWindow.dp
					color: DefaultStyle.main2_500main
					text: 'Ajouter un compte'
				}
			}
		}
	}
}
 
