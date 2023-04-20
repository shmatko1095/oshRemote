part of 'mqtt_client_bloc.dart';

extension AwsIotPart on MqttClientBloc {
  Future<void> _onMqttAddDeviceRequestedEvent(MqttAddDeviceRequestedEvent event,
      Emitter<MqttClientState> emit) async {
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
          final newThing = ThingDescriptor(
              awsName: thing.thingName!,
              sn: event.sn,
              sc: thingSc!,
              name: _prefs.getString(event.sn));
          List<ThingDescriptor> userThings = List.from(state.userThingsList);
          if (!userThings.contains(newThing)) {
            userThings.add(newThing);
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
      MqttRemoveDeviceRequestedEvent event,
      Emitter<MqttClientState> emit) async {
    bool result = false;
    emit(state.copyWith(
        iotResp: IotResponse(inProgress: true, successful: result)));

    try {
      List<ThingDescriptor> userThings = List.from(state.userThingsList);
      if (userThings.isNotEmpty) {
        final targetThing =
        userThings.firstWhere((element) => element.sn == event.sn);
        await _iotRepository.removeThingFromGroup(
            thingName: targetThing.awsName, groupName: state.groupName);
        userThings.removeWhere((element) => element.sn == event.sn);
        emit(state.copyWith(userThingsList: userThings));
        result = true;
      }
    } on Exception catch (e) {
      _exceptionStreamController.add(e);
    }
    emit(state.copyWith(
        iotResp: IotResponse(successful: result, inProgress: false)));
  }

  Future<void> _onMqttRenameDeviceRequestedEvent(
      MqttRenameDeviceRequestedEvent event,
      Emitter<MqttClientState> emit) async {
    try {
      if (event.name != null) {
        _prefs.setString(event.sn, event.name!);
      } else {
        _prefs.remove(event.sn);
      }
      List<ThingDescriptor> userThings = List.from(state.userThingsList);
      final updatedUserThingsList =
      _updateThingDescriptorList(userThings, event);
      emit(state.copyWith(userThingsList: updatedUserThingsList));
    } on Exception catch (e) {
      _exceptionStreamController.add(e);
    }
  }

  List<ThingDescriptor> _updateThingDescriptorList(
      List<ThingDescriptor> userThingsList,
      MqttRenameDeviceRequestedEvent event) {
    final targetThing =
    userThingsList.firstWhere((element) => element.sn == event.sn);
    final updatedThing = ThingDescriptor(
        awsName: targetThing.awsName,
        sn: targetThing.sn,
        sc: targetThing.sc,
        name: event.name);
    final updatedList =
    _replaceThingDescriptor(userThingsList, targetThing, updatedThing);
    return updatedList;
  }

  List<ThingDescriptor> _replaceThingDescriptor(List<ThingDescriptor> list,
      ThingDescriptor targetThing, ThingDescriptor updatedThing) {
    final index = list.indexOf(targetThing);
    list.removeAt(index);
    list.insert(index, updatedThing);
    return list;
  }

  Future<void> _onMqttGetUserThingsEvent(MqttGetUserThingsRequested event,
      Emitter<MqttClientState> emit) async {
    final thingsInUserGroup =
    await _iotRepository.listThingsInGroup(event.userId);
    final devicesInUserGroup =
    thingsInUserGroup.where((s) => !s.startsWith(clientPrefix)).toList();
    List<ThingDescriptor> userThingsList = [];
    for (var element in devicesInUserGroup) {
      final data = await _iotRepository.describeThing(thingName: element);
      if (data.thingName != null &&
          data.attributes != null &&
          data.attributes!.containsKey(Constants.serialNumberKey) &&
          data.attributes!.containsKey(Constants.secureCodeKey)) {
        String awsName = data.thingName!;
        String sn = data.attributes![Constants.serialNumberKey]!;
        String sc = data.attributes![Constants.secureCodeKey]!;
        String? name = _prefs.getString(sn);
        userThingsList
            .add(ThingDescriptor(awsName: awsName, sn: sn, sc: sc, name: name));
      }
    }
    emit(state.copyWith(userThingsList: userThingsList));
  }

  Future<String?> _checkOrCreateGroup(String groupName) async {
    bool exist = await _iotRepository.isGroupExist(groupName);
    String? name =
    exist ? groupName : await _iotRepository.createGroup(groupName);
    return name;
  }

  Future<String?> _checkOrCreateThing(String thingName) async {
    bool exist = await _iotRepository.isThingExist(thingName);
    String? name;
    if (exist) {
      name = thingName;
    } else {
      final resp = await _iotRepository.createThing(thingName);

      name = resp.thingName;
    }
    return name;
  }

  Future<void> _checkOrAddThingToGroup(String group, String thing) async {
    final thingList = await _iotRepository.listThingsInGroup(group);
    if (!thingList.contains(thing)) {
      await _iotRepository.addThingToGroup(thingName: thing, groupName: group);
    }
  }

  Future<void> _checkOrCreateCertificateWithPolicyAndAttachToThing(
      String thingName) async {
    String? id = clientCert?.certificateId;
    bool isActive = await _iotRepository.isCertificateActive(id);
    if (!isActive) {
      clientCert = await _iotRepository.createCertificate();
      await _iotRepository.attachPolicy(
          thingPolicyName, clientCert!.certificateArn!);
      await _iotRepository.attachThingPrincipal(
          thingName, clientCert!.certificateArn!);
    }
  }
}