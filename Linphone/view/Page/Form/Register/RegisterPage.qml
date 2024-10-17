import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import Linphone
import UtilsCpp 1.0
import ConstantsCpp 1.0

LoginLayout {
	id: mainItem
	signal returnToLogin()
	signal browserValidationRequested()
	readonly property string countryCode: phoneNumberInput.countryCode
	readonly property string phoneNumber: phoneNumberInput.phoneNumber
	readonly property string email: emailInput.text

	Connections {
		target: RegisterPageCpp
		function onErrorInField(field, errorMessage) {
			if (field == "username") usernameItem.errorMessage = errorMessage
			else if (field == "password") pwdItem.errorMessage = errorMessage
			else if (field == "phone") phoneNumberInput.errorMessage = errorMessage
			else if (field == "email") emailItem.errorMessage = errorMessage
			else otherErrorText.text = errorMessage
		}
		function onRegisterNewAccountFailed(errorMessage) {
			otherErrorText.text = errorMessage
		}
	}

	titleContent: [
		RowLayout {
			spacing: 21 * mainWindow.dp
			Layout.leftMargin: 119 * mainWindow.dp
			Image {
				fillMode: Image.PreserveAspectFit
				source: AppIcons.profile
			}
			Text {
				Layout.preferredWidth: width
				text: qsTr("Inscription")
				font {
					pixelSize: 36 * mainWindow.dp
					weight: 800 * mainWindow.dp
				}
				wrapMode: Text.NoWrap
				scaleLettersFactor: 1.1
			}
		},
		Item {
			Layout.fillWidth: true
		},
		RowLayout {
			spacing: 20 * mainWindow.dp
			Layout.rightMargin: 51 * mainWindow.dp
			Text {
				Layout.rightMargin: 15 * mainWindow.dp
				color: DefaultStyle.main2_700
				text: qsTr("Déjà un compte ?")
				font {
					pixelSize: 14 * mainWindow.dp
					weight: 400 * mainWindow.dp
				}
			}
			Button {
				leftPadding: 20 * mainWindow.dp
				rightPadding: 20 * mainWindow.dp
				topPadding: 11 * mainWindow.dp
				bottomPadding: 11 * mainWindow.dp
				text: qsTr("Connexion")
				onClicked: {
					console.debug("[RegisterPage] User: return")
					returnToLogin()
				}
			}
		}
	]

	centerContent: [
		ColumnLayout {
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.topMargin: 51 * mainWindow.dp
			anchors.leftMargin: 127 * mainWindow.dp
			anchors.rightMargin: 127 * mainWindow.dp
			spacing: 50 * mainWindow.dp
			TabBar {
				Layout.fillWidth: true
				id: bar
				model: [qsTr("Register with phone number"), qsTr("Register with email")]
			}
			ColumnLayout {
				spacing: 22 * mainWindow.dp
				ColumnLayout {
					spacing: 24 * mainWindow.dp
					RowLayout {
						spacing: 16 * mainWindow.dp
						FormItemLayout {
							id: usernameItem
							label: qsTr("Username")
							mandatory: true
							contentItem: TextField {
								id: usernameInput
								Layout.preferredWidth: 346 * mainWindow.dp
								backgroundBorderColor: usernameItem.errorMessage.length > 0 ? DefaultStyle.danger_500main : DefaultStyle.grey_200
							}
						}
						RowLayout {
							spacing: 10 * mainWindow.dp
							Layout.alignment: Qt.AlignBottom
							ComboBox {
								enabled: false
								model: [{text:"@sip.linphone.org"}]
								Layout.preferredWidth: 210 * mainWindow.dp
								Layout.preferredHeight: 49 * mainWindow.dp
							}
							EffectImage {
								imageSource: AppIcons.lock
								colorizationColor: DefaultStyle.main2_600
								Layout.preferredWidth: 16 * mainWindow.dp
								Layout.preferredHeight: 16 * mainWindow.dp
							}
						}
					}
					StackLayout {
						currentIndex: bar.currentIndex
						Layout.fillWidth: true
						PhoneNumberInput {
							id: phoneNumberInput
							property string completePhoneNumber: countryCode + phoneNumber
							label: qsTr("Numéro de téléphone")
							mandatory: true
							placeholderText: "Phone number"
							defaultCallingCode: "33"
							Layout.preferredWidth: 346 * mainWindow.dp
						}
						FormItemLayout {
							id: emailItem
							label: qsTr("Email")
							mandatory: true
							enableErrorText: true
							contentItem: TextField {
								id: emailInput
								Layout.preferredWidth: 346 * mainWindow.dp
								backgroundBorderColor: emailItem.errorMessage.length > 0 ? DefaultStyle.danger_500main : DefaultStyle.grey_200
							}
						}
					}
					ColumnLayout {
						spacing: 0
						Layout.preferredHeight: rowlayout.height
						clip: false
						RowLayout {
							id: rowlayout
							spacing: 16 * mainWindow.dp
							ColumnLayout {
								spacing: 5 * mainWindow.dp
								FormItemLayout {
									id: passwordItem
									label: qsTr("Mot de passe")
									mandatory: true
									enableErrorText: true
									contentItem: TextField {
										id: pwdInput
										hidden: true
										Layout.preferredWidth: 346 * mainWindow.dp
										backgroundBorderColor: passwordItem.errorMessage.length > 0 ? DefaultStyle.danger_500main : DefaultStyle.grey_200
									}
								}
							}
							ColumnLayout {
								spacing: 5 * mainWindow.dp
								FormItemLayout {
									label: qsTr("Confirmation mot de passe")
									mandatory: true
									enableErrorText: true
									contentItem: TextField {
										id: confirmPwdInput
										hidden: true
										Layout.preferredWidth: 346 * mainWindow.dp
										backgroundBorderColor: passwordItem.errorMessage.length > 0 ? DefaultStyle.danger_500main : DefaultStyle.grey_200
									}
								}
							}
						}
						TemporaryText {
							id: otherErrorText
							Layout.fillWidth: true
							Layout.topMargin: 5 * mainWindow.dp
						}
					}
				}
				// ColumnLayout {
				// 	spacing: 18 * mainWindow.dp
				// 	RowLayout {
				// 		spacing: 10 * mainWindow.dp
				// 		CheckBox {
				// 			id: subscribeToNewsletterCheckBox
				// 		}
				// 		Text {
				// 			text: qsTr("Je souhaite souscrire à la newletter Linphone.")
				// 			font {
				// 				pixelSize: 14 * mainWindow.dp
				// 				weight: 400 * mainWindow.dp
				// 			}
				// 			MouseArea {
				// 				anchors.fill: parent
				// 				onClicked: subscribeToNewsletterCheckBox.toggle()
				// 			}
				// 		}
				// 	}

					RowLayout {
						spacing: 10 * mainWindow.dp
						CheckBox {
							id: termsCheckBox
						}
						RowLayout {
							spacing: 0
							Layout.fillWidth: true
							Text {
								text: qsTr("J'accepte les ")
								font {
									pixelSize: 14 * mainWindow.dp
									weight: 400 * mainWindow.dp
								}
								MouseArea {
									anchors.fill: parent
									onClicked: termsCheckBox.toggle()
								}
							}
							Text {
								activeFocusOnTab: true
								font {
									underline: true
									pixelSize: 14 * mainWindow.dp
									weight: 400 * mainWindow.dp
									bold: activeFocus
								}
								text: qsTr("conditions d’utilisation")
								Keys.onPressed: (event)=> {
									if (event.key == Qt.Key_Space || event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
										cguMouseArea.clicked(undefined)
										event.accepted = true;
									}
								}
								MouseArea {
									id: cguMouseArea
									anchors.fill: parent
									hoverEnabled: true
									cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
									onClicked: Qt.openUrlExternally(ConstantsCpp.CguUrl)
								}
							}
							Text {
								text: qsTr(" et la ")
								font {
									pixelSize: 14 * mainWindow.dp
									weight: 400 * mainWindow.dp
								}
							}
							Text {
								activeFocusOnTab: true
								font {
									underline: true
									pixelSize: 14 * mainWindow.dp
									weight: 400 * mainWindow.dp
									bold: activeFocus
								}
								text: qsTr("politique de confidentialité.")
								Keys.onPressed: (event)=> {
									if (event.key == Qt.Key_Space || event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
										privateMouseArea.clicked(undefined)
										event.accepted = true;
									}
								}
								MouseArea {
									id: privateMouseArea
									anchors.fill: parent
									hoverEnabled: true
									cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
									onClicked: Qt.openUrlExternally(ConstantsCpp.PrivatePolicyUrl)
								}
							}
						}
					}
				// }
				Button {
					enabled: termsCheckBox.checked
					leftPadding: 20 * mainWindow.dp
					rightPadding: 20 * mainWindow.dp
					topPadding: 11 * mainWindow.dp
					bottomPadding: 11 * mainWindow.dp
					text: qsTr("Créer")
					onClicked:{
						if (usernameInput.text.length === 0) {
							console.log("ERROR username")
							usernameItem.errorMessage = qsTr("Veuillez entrer un nom d'utilisateur")
						} else if (pwdInput.text.length === 0) {
							console.log("ERROR password")
							passwordItem.errorMessage = qsTr("Veuillez entrer un mot de passe")
						} else if (pwdInput.text != confirmPwdInput.text) {
							console.log("ERROR confirm pwd")
							passwordItem.errorMessage = qsTr("Les mots de passe sont différents")
						} else if (bar.currentIndex === 0 && phoneNumberInput.phoneNumber.length === 0) {
							console.log("ERROR phone number")
							phoneNumberInput.errorMessage = qsTr("Veuillez entrer un numéro de téléphone")
						} else if (bar.currentIndex === 1 && emailInput.text.length === 0) {
							console.log("ERROR email")
							emailItem.errorMessage = qsTr("Veuillez entrer un email")
						} else {
							console.log("[RegisterPage] User: Call register")
							mainItem.browserValidationRequested()
							if (bar.currentIndex === 0)
								RegisterPageCpp.registerNewAccount(usernameInput.text, pwdInput.text, "", phoneNumberInput.completePhoneNumber)
							else
								RegisterPageCpp.registerNewAccount(usernameInput.text, pwdInput.text, emailInput.text, "")
						}
					}
				}
			}
		},
		Image {
			z: -1
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.topMargin: 129 * mainWindow.dp
			anchors.rightMargin: 127 * mainWindow.dp
			width: 395 * mainWindow.dp
			height: 350 * mainWindow.dp
			fillMode: Image.PreserveAspectFit
			source: AppIcons.loginImage
		}
	]
}
 
