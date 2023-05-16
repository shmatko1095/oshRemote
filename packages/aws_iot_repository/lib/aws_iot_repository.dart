import 'dart:async';

import 'package:aws_iot_api/iot-2015-05-28.dart';

class AwsIotRepository {
  late final IoT _service;
  static AwsIotRepository? _instance;

  static AwsIotRepository createInstance(
      String region, AwsClientCredentials credentials) {
    if (_instance == null) {
      _instance = AwsIotRepository._(region, credentials);
    } else {
      // throw StateError("AwsIotRepository instance already exists");
    }
    return _instance!;
  }

  static AwsIotRepository getInstance() {
    if (_instance == null) {
      throw StateError("AwsIotRepository instance does not exists");
    }
    return _instance!;
  }

  AwsIotRepository._(String region, AwsClientCredentials credentials) {
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

  Future<void> addThingToGroup(
      {required String thingName, required String groupName}) async {
    await _service.addThingToThingGroup(
        thingName: thingName, thingGroupName: groupName);
  }

  Future<void> removeThingFromGroup(
      {required String thingName, required String groupName}) async {
    return await _service.removeThingFromThingGroup(
        thingName: thingName, thingGroupName: groupName);
  }

  Future<void> updateThing(
      {required String thingName,
      required Map<String, String> attributes}) async {
    return await _service.updateThing(
      thingName: thingName,
      attributePayload: AttributePayload(attributes: attributes),
    );
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

  Future<bool> isCertificateActive(String id) async {
    bool result = false;
    final resp = await _service.describeCertificate(certificateId: id);
    if (resp.certificateDescription != null) {
      result = resp.certificateDescription!.status == CertificateStatus.active;
    }
    return result;
  }

  Future<ListThingsResponse> listThingsByAttribute(
      {required String attributeName, required String attributeValue}) async {
    return await _service.listThings(
        attributeName: attributeName, attributeValue: attributeValue);
  }

  Future<DescribeThingResponse> describeThing(
      {required String thingName}) async {
    return await _service.describeThing(thingName: thingName);
  }
}
