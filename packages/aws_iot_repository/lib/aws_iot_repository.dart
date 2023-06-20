import 'dart:async';

import 'package:aws_iot_api/iot-2015-05-28.dart';
import 'package:aws_iot_repository/i_aws_iot_repository.dart';

class AwsIotRepository implements IAwsIotRepository {
  late final IoT _service;

  AwsIotRepository(String region, AwsClientCredentials credentials) {
    _service = IoT(region: region, credentials: credentials);
  }

  @override
  Future<CreateKeysAndCertificateResponse> createCertificate() async {
    return await _service.createKeysAndCertificate(setAsActive: true);
  }

  @override
  Future<void> attachPolicy(String policyName, String target) async {
    await _service.attachPolicy(policyName: policyName, target: target);
  }

  @override
  Future<void> attachThingPrincipal(String thingName, String principal) async {
    await _service.attachThingPrincipal(
        principal: principal, thingName: thingName);
  }

  @override
  Future<CreateThingResponse> createThing(String thing) async {
    return await _service.createThing(thingName: thing);
  }

  @override
  Future<String?> createGroup(String group) async {
    var response = await _service.createThingGroup(thingGroupName: group);
    return response.thingGroupName;
  }

  @override
  Future<void> addThingToGroup(
      {required String thingName, required String groupName}) async {
    await _service.addThingToThingGroup(
        thingName: thingName, thingGroupName: groupName);
  }

  @override
  Future<void> removeThingFromGroup(
      {required String thingName, required String groupName}) async {
    return await _service.removeThingFromThingGroup(
        thingName: thingName, thingGroupName: groupName);
  }

  @override
  Future<void> updateThing(
      {required String thingName,
      required Map<String, String> attributes}) async {
    return await _service.updateThing(
      thingName: thingName,
      attributePayload: AttributePayload(attributes: attributes),
    );
  }

  @override
  Future<List<String>> listThingsInGroup(String group) async {
    final res = await _service.listThingsInThingGroup(thingGroupName: group);
    return res.things != null ? res.things! : [];
  }

  @override
  Future<List<String>> listThingGroups() async {
    List<String> result = [];
    ListThingGroupsResponse list = await _service.listThingGroups();
    list.thingGroups?.forEach((e) => e.groupName ?? result.add(e.groupName!));
    return result;
  }

  @override
  Future<bool> isGroupExist(String name) async {
    bool result;
    try {
      final response = await _service.describeThingGroup(thingGroupName: name);
      result = response.thingGroupArn != null;
    } on Exception {
      result = false;
    }
    return result;
  }

  @override
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

  @override
  Future<bool> isCertificateActive(String id) async {
    bool result = false;
    final resp = await _service.describeCertificate(certificateId: id);
    if (resp.certificateDescription != null) {
      result = resp.certificateDescription!.status == CertificateStatus.active;
    }
    return result;
  }

  @override
  Future<ListThingsResponse> listThingsByAttribute(
      {required String attributeName, required String attributeValue}) async {
    return await _service.listThings(
        attributeName: attributeName, attributeValue: attributeValue);
  }

  @override
  Future<DescribeThingResponse> describeThing(
      {required String thingName}) async {
    return await _service.describeThing(thingName: thingName);
  }
}
