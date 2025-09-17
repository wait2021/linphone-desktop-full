/*
 * Copyright (c) 2010-2024 Belledonne Communications SARL.
 *
 * This file is part of linphone-desktop
 * (see https://www.linphone.org).
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "TranscriptionModel.hpp"

#include <QDebug>

#include "model/core/CoreModel.hpp"
#include "model/friend/FriendsManager.hpp"
#include "model/setting/SettingsModel.hpp"
#include "model/tool/ToolModel.hpp"
#include "tool/Utils.hpp"
#include <functional>
#include <iostream>

DEFINE_ABSTRACT_OBJECT(TranscriptionModel)

TranscriptionModel::TranscriptionModel(const std::shared_ptr<linphone::Transcription> &data, QObject *parent)
    : ::Listener<linphone::Transcription, linphone::TranscriptionListener>(data, parent) {
	mustBeInLinphoneThread(getClassName());
}

TranscriptionModel::~TranscriptionModel() {
	mustBeInLinphoneThread("~" + getClassName());
}

void TranscriptionModel::onTranscriptionDisplay(const std::shared_ptr<linphone::Transcription> &transcription) {
	uint32_t lastId = transcription->getLastSentenceId();
	// uint32_t id = 1;
	// if (system("clear")) std::cout << "DIDNT CLEAR!" << std::endl;
	// while (id <= lastId) {
	// 	auto name = transcription->getNameById(id);
	// 	auto sentence = transcription->getSentenceById(id);
	// 	// std::cout << "on_transcription_display ID : " << id << "  NAME : [" << name << "] " << sentence << std::endl;
	// 	id++;
	// }
	auto name = transcription->getNameById(lastId);
	auto sentence = transcription->getSentenceById(lastId);
	if (system("clear")) std::cout << "DIDNT CLEAR!" << std::endl;
	if (name.empty()) {
		lInfo() << log().arg("onTranscriptionDisplay: ID [%1]: %2").arg(lastId).arg(sentence);
		std::cout << "onTranscriptionDisplay ID [" << lastId << "]: " << sentence << std::endl;
	} else {
		lInfo() << log().arg("onTranscriptionDisplay: ID [%1] - NAME [%2]: %3").arg(lastId).arg(name).arg(sentence);
		std::cout << "onTranscriptionDisplay ID [" << lastId << "] - NAME [" << name << "]: " << sentence << std::endl;
	}
}