import 'dart:async';

import 'package:aws_iot_api/iot-2015-05-28.dart';

class AwsIotRepository {
  late final IoT _service;

  AwsIotRepository(String region, AwsClientCredentials credentials) {
    _service = IoT(region: region, credentials: credentials);
  }

  Future<CreateKeysAndCertificateResponse> createCertificate() async {
    return await _service.createKeysAndCertificate(setAsActive: true);
  }

  Future<void> attachPolicy(String policyName, String target) async {
    await _service.attachPolicy(policyName: policyName, target: target);
  }

  Future<void> attachThingPrincipal(String thingName, String principal) async {
    await _service.attachThingPrincipal(
        principal: principal, thingName: thingName);
  }

  Future<CreateThingResponse> createThing(String thing) async {
    return await _service.createThing(thingName: thing);
  }

  Future<String?> createGroup(String group) async {
    var response = await _service.createThingGroup(thingGroupName: group);
    return response.thingGroupName;
  }

  Future<void> addThingToGroup(String? group, String? thing) async {
    await _service.addThingToThingGroup(
        thingName: thing, thingGroupName: group);
  }

  Future<List<String>> listThingsInGroup(String group) async {
    final res = await _service.listThingsInThingGroup(thingGroupName: group);
    return res.things != null ? res.things! : [];
  }

  Future<List<String>> listThingGroups() async {
    List<String> result = [];
    ListThingGroupsResponse list = await _service.listThingGroups();
    list.thingGroups?.forEach((e) => e.groupName ?? result.add(e.groupName!));
    return result;
  }

  Future<bool> isGroupExist(String name) async {
    bool result;
    try {
      final response = await _service.describeThingGroup(thingGroupName: name);
      result = response.thingGroupArn != null;
    } on ResourceNotFoundException {
      result = false;
    }
    return result;
  }

  Future<bool> isThingExist(String name) async {
    bool result;
    try {
      final response = await _service.describeThing(thingName: name);
      result = response.thingName != null;
    } on ResourceNotFoundException {
      result = false;
    }
    return result;
  }

  Future<bool> isCertificateActive(String? certificateId) async {
    bool result = false;
    if (certificateId != null) {
      final response = await _service.describeCertificate(certificateId: certificateId);
      if (response.certificateDescription != null) {
        result = response.certificateDescription!.status == CertificateStatus.active;
      }
    }
    return result;
  }
}
