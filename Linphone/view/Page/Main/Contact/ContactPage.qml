import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import Linphone
import UtilsCpp
import EnumsToStringCpp
import SettingsCpp

AbstractMainPage {
	id: mainItem
	noItemButtonText: qsTr("Ajouter un contact")
	emptyListText: qsTr("Aucun contact pour le moment")
	newItemIconSource: AppIcons.plusCircle

	// disable left panel contact list interaction while a contact is being edited
	property bool leftPanelEnabled: true
	property FriendGui selectedContact
	property string initialFriendToDisplay

	onVisibleChanged: if (!visible) {
		rightPanelStackView.clear()
		contactList.currentIndex = -1
		favoriteList.currentIndex = -1
	}

	onSelectedContactChanged: {
		if (selectedContact) {
			if (!rightPanelStackView.currentItem || rightPanelStackView.currentItem.objectName != "contactDetail") rightPanelStackView.push(contactDetail)
		} else {
			if (rightPanelStackView.currentItem && rightPanelStackView.currentItem.objectName === "contactDetail") rightPanelStackView.clear()
		}
	}
	signal forceListsUpdate()

	onNoItemButtonPressed: createContact("", "")

	function createContact(name, address) {
		var friendGui = Qt.createQmlObject('import Linphone
											FriendGui{
											}', mainItem)
		friendGui.core.givenName = UtilsCpp.getGivenNameFromFullName(name)
		friendGui.core.familyName = UtilsCpp.getFamilyNameFromFullName(name)
		friendGui.core.defaultAddress = address
		if (!rightPanelStackView.currentItem || rightPanelStackView.currentItem.objectName != "contactEdition")
			rightPanelStackView.push(contactEdition, {"contact": friendGui, "title": qsTr("Nouveau contact"), "saveButtonText": qsTr("Créer")})
	}

	function editContact(friendGui) {
		rightPanelStackView.push(contactEdition, {"contact": friendGui, "title": qsTr("Modifier contact"), "saveButtonText": qsTr("Enregistrer")})
	}

	// rightPanelStackView.initialItem: contactDetail
	Binding {
		mainItem.showDefaultItem: false
		when: rightPanelStackView.currentItem
		restoreMode: Binding.RestoreBinding
	}

	showDefaultItem: contactList.model.sourceModel.count === 0

	MagicSearchProxy {
		id: allFriends
	}

	function deleteContact(contact) {
		if (!contact) return
		var mainWin = UtilsCpp.getMainWindow()
		mainWin.showConfirmationLambdaPopup(
			contact.core.displayName + qsTr("sera supprimé des contacts. Voulez-vous continuer ?"),
			"",
			function (confirmed) {
				if (confirmed) {
					var name = contact.core.displayName
					contact.core.remove()
					UtilsCpp.showInformationPopup(qsTr("Supprimé"), qsTr("%1 a été supprimé").arg(name))				}
			}
		)
	}

	Popup {
		id: verifyDevicePopup
		property string deviceName
		property string deviceAddress
		padding: 30 * mainWindow.dp
		anchors.centerIn: parent
		closePolicy: Control.Popup.CloseOnEscape
		modal: true
		onAboutToHide: neverDisplayAgainCheckbox.checked = false
		contentItem: ColumnLayout {
			spacing: 45 * mainWindow.dp
			ColumnLayout {
				spacing: 10 * mainWindow.dp
				Text {
					text: qsTr("Augmenter la confiance")
					font {
						pixelSize: 22 * mainWindow.dp
						weight: 800 * mainWindow.dp
					}
				}
				ColumnLayout {
					spacing: 24 * mainWindow.dp
					Text {
						Layout.preferredWidth: 529 * mainWindow.dp
						text: qsTr("Pour augmenter le niveau de confiance vous devez appeler les différents appareils de votre contact et valider un code.")
						font.pixelSize: 14 * mainWindow.dp
					}
					Text {
						Layout.preferredWidth: 529 * mainWindow.dp
						text: qsTr("Vous êtes sur le point d’appeler “%1” voulez vous continuer ?").arg(verifyDevicePopup.deviceName)
						font.pixelSize: 14 * mainWindow.dp
					}
				}
			}
			RowLayout {
				RowLayout {
					spacing: 7 * mainWindow.dp
					CheckBox{
						id: neverDisplayAgainCheckbox
					}
					Text {
						text: qsTr("Ne plus afficher")
						font.pixelSize: 14 * mainWindow.dp
						MouseArea {
							anchors.fill: parent
							onClicked: neverDisplayAgainCheckbox.toggle()
						}
					}
				}
				Item{Layout.fillWidth: true}
				RowLayout {
					spacing: 15 * mainWindow.dp
					Button {
						inversedColors: true
						text: qsTr("Annuler")
						leftPadding: 20 * mainWindow.dp
						rightPadding: 20 * mainWindow.dp
						topPadding: 11 * mainWindow.dp
						bottomPadding: 11 * mainWindow.dp
						onClicked: verifyDevicePopup.close()
					}
					Button {
						text: qsTr("Appeler")
						leftPadding: 20 * mainWindow.dp
						rightPadding: 20 * mainWindow.dp
						topPadding: 11 * mainWindow.dp
						bottomPadding: 11 * mainWindow.dp
						onClicked: {
							SettingsCpp.setDisplayDeviceCheckConfirmation(!neverDisplayAgainCheckbox.checked)
							UtilsCpp.createCall(verifyDevicePopup.deviceAddress, {}, LinphoneEnums.MediaEncryption.Zrtp)
							onClicked: verifyDevicePopup.close()
						}
					}
				}
			}
		}
	}

	leftPanelContent: FocusScope {
		id: leftPanel
		property int leftMargin: 45 * mainWindow.dp
		property int rightMargin: 39 * mainWindow.dp
		Layout.fillHeight: true
		Layout.fillWidth: true

		RowLayout {
			id: title
			spacing: 0
			anchors.top: leftPanel.top
			anchors.right: leftPanel.right
			anchors.left: leftPanel.left
			anchors.leftMargin: leftPanel.leftMargin
			anchors.rightMargin: leftPanel.rightMargin

			Text {
				text: qsTr("Contacts")
				color: DefaultStyle.main2_700
				font.pixelSize: 29 * mainWindow.dp
				font.weight: 800 * mainWindow.dp
			}
			Item {
				Layout.fillWidth: true
			}
			Button {
				id: createContactButton
				background: Item {
				}
				icon.source: AppIcons.plusCircle
				Layout.preferredWidth: 30 * mainWindow.dp
				Layout.preferredHeight: 30 * mainWindow.dp
				icon.width: 30 * mainWindow.dp
				icon.height: 30 * mainWindow.dp
				onClicked: {
					mainItem.createContact("", "")
				}
				KeyNavigation.down: searchBar
			}
		}

		ColumnLayout {
			anchors.top: title.bottom
			anchors.right: leftPanel.right
			anchors.left: leftPanel.left
			anchors.bottom: leftPanel.bottom
			enabled: mainItem.leftPanelEnabled
			spacing: 38 * mainWindow.dp
			SearchBar {
				id: searchBar
				visible: contactList.model.sourceModel.count != 0
				Layout.leftMargin: leftPanel.leftMargin
				Layout.rightMargin: leftPanel.rightMargin
				Layout.topMargin: 18 * mainWindow.dp
				Layout.fillWidth: true
				placeholderText: qsTr("Rechercher un contact")
				KeyNavigation.up: createContactButton
				KeyNavigation.down: favoriteList.contentHeight > 0 ? favoriteExpandButton : contactExpandButton
			}
			
			RowLayout {
				Flickable {
					id: listLayout
					contentWidth: width
					contentHeight: content.height
					clip: true
					Control.ScrollBar.vertical: contactsScrollbar
					Layout.fillWidth: true
					Layout.fillHeight: true

					ColumnLayout {
						id: content
						width: parent.width
						spacing: 15 * mainWindow.dp
						Text {
							visible: contactList.count === 0 && favoriteList.count === 0
							Layout.alignment: Qt.AlignHCenter
							Layout.topMargin: 137 * mainWindow.dp
							text: qsTr("Aucun contact")
							font {
								pixelSize: 16 * mainWindow.dp
								weight: 800 * mainWindow.dp
							}
						}
						ColumnLayout {
							visible: favoriteList.contentHeight > 0
							onVisibleChanged: if (visible && !favoriteList.visible) favoriteList.visible = true
							Layout.leftMargin: leftPanel.leftMargin
							Layout.rightMargin: leftPanel.rightMargin
							spacing: 18 * mainWindow.dp
							RowLayout {
								spacing: 0
								Text {
									text: qsTr("Favoris")
									font {
										pixelSize: 16 * mainWindow.dp
										weight: 800 * mainWindow.dp
									}
								}
								Item {
									Layout.fillWidth: true
								}
								Button {
									id: favoriteExpandButton
									background: Item{}
									icon.source: favoriteList.visible ? AppIcons.upArrow :						  AppIcons.downArrow
									Layout.preferredWidth: 24 * mainWindow.dp
									Layout.preferredHeight: 24 * mainWindow.dp
									icon.width: 24 * mainWindow.dp
									icon.height: 24 * mainWindow.dp
									onClicked: favoriteList.visible = !favoriteList.visible
									KeyNavigation.up: searchBar
									KeyNavigation.down: favoriteList
								}
							}
							ContactListView{
								id: favoriteList
								hoverEnabled: mainItem.leftPanelEnabled
								highlightFollowsCurrentItem: true
								Layout.fillWidth: true
								Layout.preferredHeight: contentHeight
								Control.ScrollBar.vertical.visible: false
								showFavoritesOnly: true
								contactMenuVisible: true
								searchBarText: searchBar.text
								listProxy: allFriends
								onSelectedContactChanged: {
									if (selectedContact) {
										contactList.currentIndex = -1
									}
									mainItem.selectedContact = selectedContact
								}
								onContactDeletionRequested: (contact) => {
									mainItem.deleteContact(contact)
								}
							}
						}
						ColumnLayout {
							visible: contactList.contentHeight > 0
							onVisibleChanged: if (visible && !contactList.visible) contactList.visible = true
							Layout.leftMargin: leftPanel.leftMargin
							Layout.rightMargin: leftPanel.rightMargin
							spacing: 16 * mainWindow.dp
							RowLayout {
								spacing: 0
								Text {
									text: qsTr("Contacts")
									font {
										pixelSize: 16 * mainWindow.dp
										weight: 800 * mainWindow.dp
									}
								}
								Item {
									Layout.fillWidth: true
								}
								Button {
									id: contactExpandButton
									background: Item{}
									icon.source: contactList.visible ? AppIcons.upArrow : AppIcons.downArrow
									Layout.preferredWidth: 24 * mainWindow.dp
									Layout.preferredHeight: 24 * mainWindow.dp
									icon.width: 24 * mainWindow.dp
									icon.height: 24 * mainWindow.dp
									onClicked: contactList.visible = !contactList.visible
									KeyNavigation.up: favoriteList.visible ? favoriteList : searchBar
									KeyNavigation.down: contactList
								}
							}
							ContactListView{
								id: contactList
								onCountChanged: {
									if (initialFriendToDisplay.length !== 0) {
										if (selectContact(initialFriendToDisplay) != -1) initialFriendToDisplay = ""
									}
								}
								Layout.fillWidth: true
								Layout.preferredHeight: contentHeight
								Control.ScrollBar.vertical.visible: false
								hoverEnabled: mainItem.leftPanelEnabled
								contactMenuVisible: true
								highlightFollowsCurrentItem: true
								searchBarText: searchBar.text
								listProxy: allFriends
								Connections {
									target: contactList.model
									function onFriendCreated(index) {
										contactList.currentIndex = index
									}
								}
								onSelectedContactChanged: {
									if (selectedContact) {
										favoriteList.currentIndex = -1
									}
									mainItem.selectedContact = selectedContact
								}
								onContactDeletionRequested: (contact) => {
									mainItem.deleteContact(contact)
								}
							}
						}
					}
				}
				ScrollBar {
					id: contactsScrollbar
					Layout.fillHeight: true
					Layout.rightMargin: 8 * mainWindow.dp
					height: listLayout.height
					active: true
					interactive: true
					policy: Control.ScrollBar.AsNeeded
				}
			}
		}
	}

	Component {
		id: contactDetail
		Item {
			width: parent?.width
			height: parent?.height
			property string objectName: "contactDetail"
			Control.StackView.onActivated: mainItem.leftPanelEnabled = true
			Control.StackView.onDeactivated: mainItem.leftPanelEnabled = false
			RowLayout {
				visible: mainItem.selectedContact != undefined
				anchors.fill: parent
				anchors.topMargin: 45 * mainWindow.dp
				anchors.bottomMargin: 23 * mainWindow.dp
				ContactLayout {
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.alignment: Qt.AlignLeft | Qt.AlignTop
					contact: mainItem.selectedContact
					Layout.preferredWidth: 360 * mainWindow.dp
					buttonContent: Button {
						width: 24 * mainWindow.dp
						height: 24 * mainWindow.dp
						icon.width: 24 * mainWindow.dp
						icon.height: 24 * mainWindow.dp
						background: Item{}
						onClicked: mainItem.editContact(mainItem.selectedContact)
						icon.source: AppIcons.pencil
						visible: !mainItem.selectedContact?.core.readOnly
					}
					detailContent: ColumnLayout {
						Layout.fillWidth: false
						Layout.preferredWidth: 360 * mainWindow.dp
						spacing: 32 * mainWindow.dp
						ColumnLayout {
							spacing: 9 * mainWindow.dp
							Text {
								Layout.leftMargin: 10 * mainWindow.dp
								text: qsTr("Informations")
								font {
									pixelSize: 16 * mainWindow.dp
									weight: 800 * mainWindow.dp
								}
							}
							
							RoundedPane {
								Layout.preferredHeight: Math.min(226 * mainWindow.dp, addrList.contentHeight + topPadding + bottomPadding)
								height: Math.min(226 * mainWindow.dp, addrList.contentHeight)
								Layout.fillWidth: true
								topPadding: 12 * mainWindow.dp
								bottomPadding: 12 * mainWindow.dp
								leftPadding: 20 * mainWindow.dp
								rightPadding: 20 * mainWindow.dp
								contentItem: ListView {
									id: addrList
									width: 360 * mainWindow.dp
									height: contentHeight
									clip: true
									spacing: 9 * mainWindow.dp
									model: VariantList {
										model:  mainItem.selectedContact ? mainItem.selectedContact.core.allAddresses : []
									}
									delegate: Item {
										width: addrList.width
										height: 46 * mainWindow.dp

										ColumnLayout {
											anchors.fill: parent
											// anchors.topMargin: 5 * mainWindow.dp
											RowLayout {
												Layout.fillWidth: true
												// Layout.fillHeight: true
												// Layout.alignment: Qt.AlignVCenter
												// Layout.topMargin: 10 * mainWindow.dp
												// Layout.bottomMargin: 10 * mainWindow.dp
												ColumnLayout {
													Layout.fillWidth: true
													Text {
														Layout.fillWidth: true
														text: modelData.label
														font {
															pixelSize: 13 * mainWindow.dp
															weight: 700 * mainWindow.dp
														}
													}
													Text {
														Layout.fillWidth: true
														property string _text: modelData.address
														text: SettingsCpp.onlyDisplaySipUriUsername ? UtilsCpp.getUsername(_text) : _text
														font {
															pixelSize: 14 * mainWindow.dp
															weight: 400 * mainWindow.dp
														}
													}
												}
												Item {
													Layout.fillWidth: true
												}
												Button {
													background: Item{}
													Layout.preferredWidth: 24 * mainWindow.dp
													Layout.preferredHeight: 24 * mainWindow.dp
													icon.source: AppIcons.phone
													width: 24 * mainWindow.dp
													height: 24 * mainWindow.dp
													icon.width: 24 * mainWindow.dp
													icon.height: 24 * mainWindow.dp
													onClicked: {
														UtilsCpp.createCall(modelData.address)
													}
												}
											}

											Rectangle {
												visible: index != addrList.model.count - 1
												Layout.fillWidth: true
												Layout.preferredHeight: 1 * mainWindow.dp
												Layout.rightMargin: 3 * mainWindow.dp
												Layout.leftMargin: 3 * mainWindow.dp
												color: DefaultStyle.main2_200
												clip: true
											}
										}
									}
								}
							}
						}
						RoundedPane {
							visible: companyText.text.length != 0 || jobText.text.length != 0
							Layout.fillWidth: true
							topPadding: 17 * mainWindow.dp
							bottomPadding: 17 * mainWindow.dp
							leftPadding: 20 * mainWindow.dp
							rightPadding: 20 * mainWindow.dp
							// Layout.fillHeight: true

							contentItem: ColumnLayout {
								// height: 100 * mainWindow.dp
								RowLayout {
									height: 50 * mainWindow.dp
									Text {
										text: qsTr("Company :")
										font {
											pixelSize: 13 * mainWindow.dp
											weight: 700 * mainWindow.dp
										}
									}
									Text {
										id: companyText
										text: mainItem.selectedContact && mainItem.selectedContact.core.organization
										font {
											pixelSize: 14 * mainWindow.dp
											weight: 400 * mainWindow.dp
										}
									}
								}
								RowLayout {
									height: 50 * mainWindow.dp
									Text {
										text: qsTr("Job :")
										font {
											pixelSize: 13 * mainWindow.dp
											weight: 700 * mainWindow.dp
										}
									}
									Text {
										id: jobText
										text: mainItem.selectedContact && mainItem.selectedContact.core.job
										font {
											pixelSize: 14 * mainWindow.dp
											weight: 400 * mainWindow.dp
										}
									}
								}
							}
							ColumnLayout {
								visible: false
								Text {
									text: qsTr("Medias")
									font {
										pixelSize: 16 * mainWindow.dp
										weight: 800 * mainWindow.dp
									}
								}
								Button {
									Rectangle {
										anchors.fill: parent
										color: DefaultStyle.grey_0
										radius: 15 * mainWindow.dp
									}
									contentItem: RowLayout {
										Image {
											Layout.preferredWidth: 24 * mainWindow.dp
											Layout.preferredHeight: 24 * mainWindow.dp
											source: AppIcons.shareNetwork
										}
										Text {
											text: qsTr("Show media shared")
											font {
												pixelSize: 14 * mainWindow.dp
												weight: 400 * mainWindow.dp
											}
										}
									}
									onClicked: console.debug("TODO : go to shared media")
								}
							}
						}
					}
				}
				ColumnLayout {
					spacing: 10 * mainWindow.dp
					Layout.rightMargin: 90 * mainWindow.dp
					ColumnLayout {
						RowLayout {
							Text {
								text: qsTr("Confiance")
								Layout.leftMargin: 10 * mainWindow.dp
								font {
									pixelSize: 16 * mainWindow.dp
									weight: 800 * mainWindow.dp
								}
							}
						}
						RoundedPane {
							Layout.preferredWidth: 360 * mainWindow.dp
							contentItem: ColumnLayout {
								spacing: 13 * mainWindow.dp
								Text {
									text: qsTr("Niveau de confiance - Appareils vérifiés")
									font {
										pixelSize: 13 * mainWindow.dp
										weight: 700 * mainWindow.dp
									}
								}
								Text {
									visible: deviceList.count === 0
									text: qsTr("Aucun appareil")
								}
								ProgressBar {
									visible: deviceList.count > 0
									Layout.preferredWidth: 320 * mainWindow.dp
									Layout.preferredHeight: 28 * mainWindow.dp
									value: mainItem.selectedContact ? mainItem.selectedContact.core.verifiedDeviceCount / deviceList.count : 0
								}
								ListView {
									id: deviceList
									Layout.fillWidth: true
									Layout.preferredHeight: Math.min(200 * mainWindow.dp, contentHeight)
									clip: true
									model: mainItem.selectedContact ? mainItem.selectedContact.core.devices : []
									spacing: 16 * mainWindow.dp
									delegate: RowLayout {
										id: deviceDelegate
										width: deviceList.width
										height: 30 * mainWindow.dp
										property var callObj
										property CallGui deviceCall: callObj ? callObj.value : null
										property string deviceName: modelData.name.length != 0 ? modelData.name : qsTr("Appareil sans nom")
										Text {
											text: deviceDelegate.deviceName
											font.pixelSize: 14 * mainWindow.dp
										}
										Item{Layout.fillWidth: true}
										Image{
											visible: modelData.securityLevel === LinphoneEnums.SecurityLevel.EndToEndEncryptedAndVerified
											source: AppIcons.trusted
											width: 22 * mainWindow.dp
											height: 22 * mainWindow.dp
										}
										
										Button {
											visible: modelData.securityLevel != LinphoneEnums.SecurityLevel.EndToEndEncryptedAndVerified
											color: DefaultStyle.main1_100
											icon.source: AppIcons.warningCircle
											contentImageColor: DefaultStyle.main1_500_main
											textColor: DefaultStyle.main1_500_main
											textSize: 13 * mainWindow.dp
											text: qsTr("Vérifier")
											leftPadding: 12 * mainWindow.dp
											rightPadding: 12 * mainWindow.dp
											topPadding: 6 * mainWindow.dp
											bottomPadding: 6 * mainWindow.dp
											onClicked: {
												if (SettingsCpp.getDisplayDeviceCheckConfirmation()) {
													verifyDevicePopup.deviceName = deviceDelegate.deviceName
													verifyDevicePopup.deviceAddress = modelData.address
													verifyDevicePopup.open()
												}
												else {
													UtilsCpp.createCall(modelData.address, {}, LinphoneEnums.MediaEncryption.Zrtp)
													parent.callObj = UtilsCpp.getCallByAddress(modelData.address)
												}
											}
										}
									}
								}
							}
						}
					}
					ColumnLayout {
						spacing: 9 * mainWindow.dp
						Text {
							Layout.preferredHeight: 22 * mainWindow.dp
							Layout.leftMargin: 10 * mainWindow.dp
							text: qsTr("Other actions")
							font {
								pixelSize: 16 * mainWindow.dp
								weight: 800 * mainWindow.dp
							}
						}
						RoundedPane {
							Layout.preferredWidth: 360 * mainWindow.dp
							contentItem: ColumnLayout {
								width: parent.width
								
								IconLabelButton {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 50 * mainWindow.dp
									iconSize: 24 * mainWindow.dp
									iconSource: AppIcons.pencil
									text: qsTr("Edit")
									onClicked: mainItem.editContact(mainItem.selectedContact)
									visible: !mainItem.selectedContact?.core.readOnly
								}
								Rectangle {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 1 * mainWindow.dp
									color: DefaultStyle.main2_200
								}
								IconLabelButton {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 50 * mainWindow.dp
									iconSize: 24 * mainWindow.dp
									iconSource: mainItem.selectedContact && mainItem.selectedContact.core.starred ? AppIcons.heartFill : AppIcons.heart
									text: mainItem.selectedContact && mainItem.selectedContact.core.starred ? qsTr("Remove from favorites") : qsTr("Add to favorites")
									onClicked: if (mainItem.selectedContact) mainItem.selectedContact.core.lSetStarred(!mainItem.selectedContact.core.starred)
								}
								Rectangle {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 1 * mainWindow.dp
									color: DefaultStyle.main2_200
								}
								IconLabelButton {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 50 * mainWindow.dp
									iconSize: 24 * mainWindow.dp
									iconSource: AppIcons.shareNetwork
									text: qsTr("Partager")
									onClicked: {
										if (mainItem.selectedContact) {
											var vcard = mainItem.selectedContact.core.getVCard()
											var username = mainItem.selectedContact.core.givenName + mainItem.selectedContact.core.familyName
											var filepath = UtilsCpp.createVCardFile(username, vcard)
											if (filepath == "") UtilsCpp.showInformationPopup(qsTr("Erreur"), qsTr("La création du fichier vcard a échoué"), false)
											else mainWindow.showInformationPopup(qsTr("VCard créée"), qsTr("VCard du contact enregistrée dans %1").arg(filepath))
											UtilsCpp.shareByEmail(qsTr("Partage de contact"), vcard, filepath)
										}
									}
								}
								Rectangle {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 1 * mainWindow.dp
									color: DefaultStyle.main2_200
								}
								IconLabelButton {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 50 * mainWindow.dp
									iconSize: 24 * mainWindow.dp
									iconSource: AppIcons.bellSlash
									text: qsTr("Mute")
									onClicked: console.log("TODO : mute contact")
								}
								Rectangle {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 1 * mainWindow.dp
									color: DefaultStyle.main2_200
								}
								IconLabelButton {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 50 * mainWindow.dp
									iconSize: 24 * mainWindow.dp
									iconSource: AppIcons.empty
									text: qsTr("Block")
									onClicked: console.log("TODO : block contact")
								}
								Rectangle {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 1 * mainWindow.dp
									color: DefaultStyle.main2_200
								}
								IconLabelButton {
									Layout.fillWidth: true
									Layout.leftMargin: 15 * mainWindow.dp
									Layout.rightMargin: 15 * mainWindow.dp
									Layout.preferredHeight: 50 * mainWindow.dp
									iconSize: 24 * mainWindow.dp
									iconSource: AppIcons.trashCan
									color: DefaultStyle.danger_500main
									text: qsTr("Delete this contact")
									visible: !mainItem.selectedContact?.core.readOnly
									onClicked: {
										mainItem.deleteContact(contact)
									}
								}
							}
						}
					}
				}
			}
		}
	}

	Component {
		id: contactEdition
		ContactEdition {
			width: rightPanelStackView.width
			height: rightPanelStackView.height
			property string objectName: "contactEdition"
			onCloseEdition: {
				if (rightPanelStackView.depth <= 1) rightPanelStackView.clear()
				else rightPanelStackView.pop(Control.StackView.Immediate)
			}
		}
	}
}
