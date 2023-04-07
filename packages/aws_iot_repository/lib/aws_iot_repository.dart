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
    return await _service.attachPolicy(policyName: policyName, target: target);
  }

  Future<CreateThingResponse> createThingAndAttachPrincipal(
      String thingName, String principal) async {
    CreateThingResponse response =
        await _service.createThing(thingName: thingName);
    await _service.attachThingPrincipal(
        principal: principal, thingName: thingName);
    return response;
  }

  Future<String?> createThingGroup(String groupName) async {
    var response = await _service.createThingGroup(thingGroupName: groupName);
    return response.thingGroupName;
  }

  Future<void> addThingToThingGroup(String group, String thing) async {
    await _service.addThingToThingGroup(thingName: thing, thingGroupName: group);
  }
}
