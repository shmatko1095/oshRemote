part of 'mqtt_client_bloc.dart';

extension AwsIotPart on MqttClientBloc {
  Future<void> _onMqttAddDeviceRequestedEvent(
      MqttAddDeviceEvent event, Emitter<MqttClientState> emit) async {
    bool result = false;
    emit(state.copyWith(
        iotResp: IotResponse(inProgress: true, successful: result)));

    try {
      final things = await _iotRepository.listThingsByAttribute(
          attributeName: Constants.serialNumberKey, attributeValue: event.sn);
      if (things.things == null || things.things!.isEmpty) {
        _exceptionStreamController.add(NoIotDeviceFound());
      } else {
        final thing = things.things![0];
        String? thingSc = thing.attributes![Constants.secureCodeKey];
        if (event.sc != thingSc) {
          _exceptionStreamController.add(SecureCodeIncorrect());
        } else {
          _iotRepository.addThingToGroup(
              thingName: thing.thingName!, groupName: state.groupName);
          List<String> userThings = List.from(state.userThingsList);
          if (!userThings.contains(thing.thingName)) {
            userThings.add(thing.thingName!);
            emit(state.copyWith(userThingsList: userThings));
          }
          result = true;
        }
      }
    } on Exception catch (e) {
      _exceptionStreamController.add(e);
    }
    emit(state.copyWith(
        iotResp: IotResponse(successful: result, inProgress: false)));
  }

  Future<void> _onMqttRemoveDeviceRequestedEvent(
      MqttRemoveDeviceEvent event, Emitter<MqttClientState> emit) async {
    bool result = false;
    emit(state.copyWith(
        iotResp: IotResponse(inProgress: true, successful: result)));

    try {
      List<String> userThings = List.from(state.userThingsList);
      if (userThings.isNotEmpty) {
        await _iotRepository.removeThingFromGroup(
            thingName: event.sn, groupName: state.groupName);
        userThings.removeWhere((element) => element == event.sn);
        emit(state.copyWith(userThingsList: userThings));
        result = true;
      }
    } on Exception catch (e) {
      _exceptionStreamController.add(e);
    }
    emit(state.copyWith(
        iotResp: IotResponse(successful: result, inProgress: false)));
  }

  Future<void> _onMqttGetUserThingsEvent(
      MqttGetUserThings event, Emitter<MqttClientState> emit) async {
    final fullList = await _iotRepository.listThingsInGroup(event.userId);
    final things = fullList.where((s) => !s.startsWith(clientPrefix)).toList();
    emit(state.copyWith(userThingsList: things));
  }

  Future<String?> _checkOrCreateGroup(String groupName) async {
    bool exist = await _iotRepository.isGroupExist(groupName);
    String? name =
        exist ? groupName : await _iotRepository.createGroup(groupName);
    return name;
  }

  Future<String?> _checkOrCreateThing(String thingName) async {
    bool exist = await _iotRepository.isThingExist(thingName);
    return exist
        ? thingName
        : (await _iotRepository.createThing(thingName)).thingName;
  }

  Future<void> _checkOrAddThingToGroup(String group, String thing) async {
    final thingList = await _iotRepository.listThingsInGroup(group);
    if (!thingList.contains(thing)) {
      await _iotRepository.addThingToGroup(thingName: thing, groupName: group);
    }
  }

  Future<void> _checkOrCreateCertificateWithPolicyAndAttachToThing(
      String thingName) async {
    bool isActive = await _isCertificateActive();
    if (!isActive) {
      _createCertificateAndAttachThing(thingName);
    }
  }

  Future<bool> _isCertificateActive() async {
    bool result = false;
    Certificate? cert = CertificateProvider.getCert();
    if (cert != null) {
      try {
        result = await _iotRepository.isCertificateActive(cert.id);
      } on Exception catch (event) {
        _exceptionStreamController.add(event);
        result = false;
      }
    }
    return result;
  }

  Future<void> _createCertificateAndAttachThing(String thingName) async {
    aws.CreateKeysAndCertificateResponse cert =
        await _iotRepository.createCertificate();
    await _iotRepository.attachPolicy(thingPolicyName, cert.certificateArn!);
    await _iotRepository.attachThingPrincipal(thingName, cert.certificateArn!);

    CertificateProvider.updateCert(Certificate(
        arn: cert.certificateArn!,
        id: cert.certificateId!,
        pem: cert.certificatePem!,
        pair: KeyPair(
            privateKey: cert.keyPair!.privateKey!,
            publicKey: cert.keyPair!.publicKey!)));
  }
}
