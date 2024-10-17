import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import QtQuick.Dialogs
import Linphone
import SettingsCpp 1.0
import UtilsCpp

AbstractSettingsLayout {
	id: mainItem
	contentComponent: content
	property alias account: mainItem.model
	Component {
		id: content
		ColumnLayout {
			width: parent.width
			spacing: 5 * mainWindow.dp
			RowLayout {
				Layout.topMargin: 16 * mainWindow.dp
				spacing: 5 * mainWindow.dp
				ColumnLayout {
					Layout.fillWidth: true
					spacing: 5 * mainWindow.dp
					ColumnLayout {
						Layout.preferredWidth: 341 * mainWindow.dp
						Layout.maximumWidth: 341 * mainWindow.dp
						Layout.minimumWidth: 341 * mainWindow.dp
						spacing: 5 * mainWindow.dp
						Text {
							Layout.fillWidth: true
							text: qsTr("Détails")
							font: Typography.h4
							wrapMode: Text.WordWrap
							color: DefaultStyle.main2_600
						}
						Text {
							text: qsTr("Editer les informations de votre compte.")
							font: Typography.p1s
							wrapMode: Text.WordWrap
							color: DefaultStyle.main2_600
							Layout.fillWidth: true
						}
					}
					Item {
						Layout.fillHeight: true
					}
				}
				ColumnLayout {
					Layout.fillWidth: true
					spacing: 20 * mainWindow.dp
					Layout.rightMargin: 44 * mainWindow.dp
					Layout.topMargin: 20 * mainWindow.dp
					Layout.leftMargin: 64 * mainWindow.dp
					Avatar {
						account: model
						displayPresence: false
						Layout.preferredWidth: 100 * mainWindow.dp
						Layout.preferredHeight: 100 * mainWindow.dp
						Layout.alignment: Qt.AlignHCenter
					}
					IconLabelButton {
						visible: model.core.pictureUri.length === 0
						Layout.preferredWidth: width
						Layout.preferredHeight: 17 * mainWindow.dp
						iconSource: AppIcons.camera
						iconSize: 17 * mainWindow.dp
						text: qsTr("Ajouter une image")
						onClicked: fileDialog.open()
						Layout.alignment: Qt.AlignHCenter
						color: DefaultStyle.main2_600
					}
					RowLayout {
						visible: model.core.pictureUri.length > 0
						Layout.alignment: Qt.AlignHCenter
						spacing: 5 * mainWindow.dp
						IconLabelButton {
							Layout.preferredWidth: width
							Layout.preferredHeight: 17 * mainWindow.dp
							iconSource: AppIcons.pencil
							iconSize: 17 * mainWindow.dp
							text: qsTr("Modifier l'image")
							color: DefaultStyle.main2_600
							onClicked: fileDialog.open()
						}
						IconLabelButton {
							Layout.preferredWidth: width
							Layout.preferredHeight: 17 * mainWindow.dp
							iconSource: AppIcons.trashCan
							iconSize: 17 * mainWindow.dp
							text: qsTr("Supprimer l'image")
							color: DefaultStyle.main2_600
							onClicked: model.core.pictureUri = ""
						}
					}
					FileDialog {
						id: fileDialog
						currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
						onAccepted: {
							var avatarPath = UtilsCpp.createAvatar( selectedFile )
							if(avatarPath){
								model.core.pictureUri = avatarPath
							}
						}
					}
					RowLayout {
						Layout.fillWidth: true
						spacing: 5 * mainWindow.dp
						Text {
							Layout.alignment: Qt.AlignLeft
							text: qsTr("Adresse SIP :")
							color: DefaultStyle.main2_600
							font: Typography.p2l
						}
						Text {
							Layout.alignment: Qt.AlignLeft
							text: model.core.identityAddress
							color: DefaultStyle.main2_600
							font: Typography.p1
						}
						Item {
							Layout.fillWidth: true
						}
						IconLabelButton {
							Layout.alignment: Qt.AlignRight
							Layout.preferredWidth: 20 * mainWindow.dp
							Layout.preferredHeight: 20 * mainWindow.dp
							iconSize: 24 * mainWindow.dp
							iconSource: AppIcons.copy
							color: DefaultStyle.main2_600
							onClicked: UtilsCpp.copyToClipboard(model.core.identityAddress)
						}
					}
					ColumnLayout {
						spacing: 5 * mainWindow.dp
						Layout.alignment: Qt.AlignLeft
						Text {
							text: qsTr("Nom d’affichage")
							color: DefaultStyle.main2_600
							font: Typography.p2l
						}
						Text {
							text: qsTr("Le nom qui sera affiché à vos correspondants lors de vos échanges.")
							color: DefaultStyle.main2_600
							font: Typography.p1
						}
					}
					TextField {
						Layout.alignment: Qt.AlignLeft
						Layout.fillWidth: true
						Layout.preferredHeight: 49 * mainWindow.dp
						initialText: model.core.displayName
						backgroundColor: DefaultStyle.grey_100
						onEditingFinished: {
							if (text.length != 0) model.core.displayName = text
						}
						toValidate: true
					}
					Text {
						text: qsTr("Indicatif international*")
						color: DefaultStyle.main2_600
						font: Typography.p2l
					}
					ComboSetting {
						Layout.fillWidth: true
						Layout.topMargin: -15 * mainWindow.dp
						entries: account.core.dialPlans
						propertyName: "dialPlan"
						propertyOwner: account.core
					}
					SwitchSetting {
						titleText: account?.core.humaneReadableRegistrationState
						subTitleText: account?.core.humaneReadableRegistrationStateExplained
						propertyName: "registerEnabled"
						propertyOwner: account?.core
					}
					RowLayout {
						id:mainItem
						spacing : 20 * mainWindow.dp
						ColumnLayout {
							spacing : 5 * mainWindow.dp
							Text {
								text: qsTr("Supprimer mon compte")
								font: Typography.p2l
								wrapMode: Text.WordWrap
								color: DefaultStyle.danger_500main
								Layout.fillWidth: true
							}
							Text {
								text: qsTr("Votre compte sera retiré de ce client linphone, mais vous restez connecté sur vos autres clients")
								font: Typography.p1
								wrapMode: Text.WordWrap
								color: DefaultStyle.main2_500main
								Layout.fillWidth: true
							}
						}
						Item {
							Layout.fillWidth: true
						}
						Button {
							background: Item{}
							Layout.alignment: Qt.AlignRight
							Layout.rightMargin: 5 * mainWindow.dp
							Layout.preferredWidth: 24 * mainWindow.dp
							Layout.preferredHeight: 24 * mainWindow.dp
							contentItem: RowLayout {
								Layout.alignment: Qt.AlignRight
								EffectImage {
									imageSource: AppIcons.trashCan
									width: 24 * mainWindow.dp
									height: 24 * mainWindow.dp
									Layout.preferredWidth: 24 * mainWindow.dp
									Layout.preferredHeight: 24 * mainWindow.dp
									fillMode: Image.PreserveAspectFit
									colorizationColor: DefaultStyle.danger_500main
								}
							}
							onClicked: {
								var mainWin = UtilsCpp.getMainWindow()
								mainWin.showConfirmationLambdaPopup(
									qsTr("Supprimer ") + (model.core.displayName.length > 0 ? model.core.displayName : qsTr("le compte")) + " ?",
									qsTr("Vous pouvez vous reconnecter à tout moment en cliquant sur \"Ajouter un compte\".\nCependant toutes les informations stockées sur ce périphérique seront supprimées."),
									function (confirmed) {
										if (confirmed) {
											account.core.removeAccount()
										}
									}
								)
							}
						}
					}
				}
			}
			Rectangle {
				Layout.fillWidth: true
				Layout.topMargin: 16 * mainWindow.dp
				height: 1 * mainWindow.dp
				color: DefaultStyle.main2_500main
			}
			RowLayout {
				Layout.fillWidth: true
				Layout.topMargin: 16 * mainWindow.dp
				spacing: 5 * mainWindow.dp
				ColumnLayout {
					Layout.fillWidth: true
					spacing: 5 * mainWindow.dp
					ColumnLayout {
						Layout.preferredWidth: 341 * mainWindow.dp
						Layout.maximumWidth: 341 * mainWindow.dp
						Layout.minimumWidth: 341 * mainWindow.dp
						spacing: 5 * mainWindow.dp
						Text {
							Layout.fillWidth: true
							text: qsTr("Vos appareils")
							font: Typography.h4
							wrapMode: Text.WordWrap
							color: DefaultStyle.main2_600
						}
						Text {
							text: qsTr("La liste des appareils connectés à votre compte. Vous pouvez retirer les appareils que vous n’utilisez plus.")
							font: Typography.p1s
							wrapMode: Text.WordWrap
							color: DefaultStyle.main2_600
							Layout.fillWidth: true
						}
					}
					Item {
						Layout.fillHeight: true
					}
				}
				RoundedPane {
					Layout.fillWidth: true
					Layout.fillHeight: true
					// Layout.minimumHeight: account.core.devices.length * 133 * mainWindow.dp + (account.core.devices.length - 1) * 15 * mainWindow.dp +  2 * 21 * mainWindow.dp
					Layout.rightMargin: 30 * mainWindow.dp
					Layout.topMargin: 20 * mainWindow.dp
					Layout.bottomMargin: 4 * mainWindow.dp
					Layout.leftMargin: 44 * mainWindow.dp
					topPadding: 21 * mainWindow.dp
					bottomPadding: 21 * mainWindow.dp
					leftPadding: 17 * mainWindow.dp
					rightPadding: 17 * mainWindow.dp
					background: Rectangle {
						anchors.fill: parent
						color: DefaultStyle.grey_100
						radius: 15 * mainWindow.dp
					}
					contentItem: ColumnLayout {
						spacing: 15 * mainWindow.dp
						Repeater {
							id: devices
							model: AccountDeviceProxy {
								id: accountDeviceProxy
								account: model
							}
							Control.Control{
								Layout.fillWidth: true
								height: 133 * mainWindow.dp
								topPadding: 26 * mainWindow.dp
								bottomPadding: 26 * mainWindow.dp
								rightPadding: 36 * mainWindow.dp
								leftPadding: 33 * mainWindow.dp
								
								background: Rectangle {
									anchors.fill: parent
									color: DefaultStyle.grey_0
									radius: 10 * mainWindow.dp
								}
								contentItem: ColumnLayout {
									width: parent.width
									spacing: 20 * mainWindow.dp
									RowLayout {
										spacing: 5 * mainWindow.dp
										EffectImage {
											Layout.preferredWidth: 24 * mainWindow.dp
											Layout.preferredHeight: 24 * mainWindow.dp
											fillMode: Image.PreserveAspectFit
											colorizationColor: DefaultStyle.main2_600
											imageSource: modelData.core.userAgent.toLowerCase().includes('ios') | modelData.core.userAgent.toLowerCase().includes('android') ? AppIcons.mobile : AppIcons.desktop
										}
										Text {
											text: modelData.core.deviceName
											color: DefaultStyle.main2_600
											font: Typography.p2
										}
										Item {
											Layout.fillWidth: true
										}
										MediumButton {
											Layout.alignment: Qt.AlignRight
											text: qsTr("Supprimer")
											icon.source: AppIcons.trashCan
											icon.width: 16 * mainWindow.dp
											icon.height: 16 * mainWindow.dp
											contentImageColor: DefaultStyle.main1_500_main
											onClicked: {
												var mainWin = UtilsCpp.getMainWindow()
												mainWin.showConfirmationLambdaPopup(
													qsTr("Supprimer ") + modelData.core.deviceName + " ?", "",
													function (confirmed) {
														if (confirmed) {
															accountDeviceProxy.deleteDevice(modelData)
														}
													}
												)
											}
										}
									}
									RowLayout {
										spacing: 5 * mainWindow.dp
										Text {
											text: qsTr("Dernière connexion:")
											color: DefaultStyle.main2_600
											font: Typography.p2
										}
										EffectImage {
											Layout.preferredWidth: 20 * mainWindow.dp
											Layout.preferredHeight: 20 * mainWindow.dp
											imageSource: AppIcons.calendar
											colorizationColor: DefaultStyle.main2_600
											fillMode: Image.PreserveAspectFit
										}
										Text {
											text: UtilsCpp.formatDate(modelData.core.lastUpdateTimestamp,false)
											color: DefaultStyle.main2_600
											font: Typography.p1
										}
										EffectImage {
											Layout.preferredWidth: 20 * mainWindow.dp
											Layout.preferredHeight: 20 * mainWindow.dp
											imageSource: AppIcons.clock
											colorizationColor: DefaultStyle.main2_600
											fillMode: Image.PreserveAspectFit
										}
										Text {
											text: UtilsCpp.formatTime(modelData.core.lastUpdateTimestamp)
											color: DefaultStyle.main2_600
											font: Typography.p1
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
