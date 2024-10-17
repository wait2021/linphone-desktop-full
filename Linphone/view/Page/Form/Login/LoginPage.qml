import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control

import Linphone
import UtilsCpp
import SettingsCpp

LoginLayout {
	id: mainItem
	property bool showBackButton: false
	signal goBack()
	signal useSIPButtonClicked()
	signal useRemoteConfigButtonClicked()
	signal goToRegister()
	signal connectionSucceed()

	titleContent: [
		Button {
			enabled: mainItem.showBackButton
			opacity: mainItem.showBackButton ? 1.0 : 0
			Layout.preferredHeight: 27 * mainWindow.dp
			Layout.preferredWidth: 27 * mainWindow.dp
			Layout.leftMargin: 79 * mainWindow.dp
			icon.source: AppIcons.leftArrow
			icon.width: width
			icon.height: height
			background: Rectangle {
				color: "transparent"
			}
			onClicked: {
				console.debug("[LoginLayout] User: return")
				mainItem.goBack()
			}
		},
		RowLayout {
			spacing: 15 * mainWindow.dp
			Layout.leftMargin: 21 * mainWindow.dp
			Image {
				fillMode: Image.PreserveAspectFit
				source: AppIcons.profile
				Layout.preferredHeight: 34 * mainWindow.dp
				Layout.preferredWidth: 34 * mainWindow.dp
			}
			Text {
				text: qsTr("Connexion")
				font {
					pixelSize: 36 * mainWindow.dp
					weight: 800 * mainWindow.dp
				}
			}
		},
		Item {
			Layout.fillWidth: true
		},
		RowLayout {
			visible: !SettingsCpp.assistantHideCreateAccount
			spacing: 20 * mainWindow.dp
			Layout.rightMargin: 51 * mainWindow.dp
			Text {
				Layout.rightMargin: 15 * mainWindow.dp
				text: qsTr("Pas encore de compte ?")
				font.pixelSize: 14 * mainWindow.dp
				font.weight: 400 * mainWindow.dp
			}
			Button {
				Layout.alignment: Qt.AlignRight
				leftPadding: 20 * mainWindow.dp
				rightPadding: 20 * mainWindow.dp
				topPadding: 11 * mainWindow.dp
				bottomPadding: 11 * mainWindow.dp
				text: qsTr("S'inscrire")
				onClicked: {
					console.debug("[LoginPage] User: go to register")
					mainItem.goToRegister()
				}
			}
		}
	]
	centerContent: [
		Flickable {
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.leftMargin: 127 * mainWindow.dp
			anchors.topMargin: 70 * mainWindow.dp
			anchors.bottom: parent.bottom
			width: contentWidth
			contentWidth: content.implicitWidth
			contentHeight: content.implicitHeight
			clip: true
			flickableDirection: Flickable.VerticalFlick
			ColumnLayout {
				id: content
				spacing: 0
				LoginForm {
					id: loginForm
					onConnectionSucceed: mainItem.connectionSucceed()
				}
				Button {
					inversedColors: true
					Layout.preferredWidth: loginForm.width
					Layout.preferredHeight: 47 * mainWindow.dp
					Layout.topMargin: 39 * mainWindow.dp
					visible: !SettingsCpp.assistantHideThirdPartyAccount
					text: qsTr("Compte SIP tiers")
					onClicked: {mainItem.useSIPButtonClicked()}
				}
				Button {
					inversedColors: true
					Layout.preferredWidth: loginForm.width
					Layout.preferredHeight: 47 * mainWindow.dp
					Layout.topMargin: 25 * mainWindow.dp
					text: qsTr("Configuration distante")
					onClicked: {fetchConfigDialog.open()}
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
	Dialog{
		id: fetchConfigDialog
		height: 315 * mainWindow.dp
		width: 637 * mainWindow.dp
		leftPadding: 33 * mainWindow.dp
		rightPadding: 33 * mainWindow.dp
		topPadding: 41 * mainWindow.dp
		bottomPadding: 29 * mainWindow.dp
		radius: 0
		title: qsTr('Télécharger une configuration distante')
		text: qsTr('Veuillez entrer le lien de configuration qui vous a été fourni :')

		firstButton.text: 'Annuler'
		firstButtonAccept: false
		firstButton.inversedColors: true

		secondButton.text: 'Valider'
		secondButtonAccept: true
		onAccepted:{
			UtilsCpp.useFetchConfig(configUrl.text)
		}
		content:[
			TextField{
				id: configUrl
				Layout.fillWidth: true
				Layout.preferredHeight: 49 * mainWindow.dp
				placeholderText: qsTr('Lien de configuration distante')
			}
		]
	}
}
 
