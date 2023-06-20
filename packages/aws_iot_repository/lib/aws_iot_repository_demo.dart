import 'dart:async';

import 'package:aws_iot_api/iot-2015-05-28.dart';
import 'package:aws_iot_repository/i_aws_iot_repository.dart';

class AwsIotRepositoryDemo implements IAwsIotRepository {
  final Map<String, List<String>> _thingGroupMap = {};
  static const demoDeviceSN = "SN00000000";
  static const demoDeviceSC = "00000000";
  static const serialNumberKey = "SN";
  static const secureCodeKey = "SC";

  AwsIotRepository(String region, AwsClientCredentials credentials) {}

  @override
  Future<CreateKeysAndCertificateResponse> createCertificate() async {
    final resp = CreateKeysAndCertificateResponse(
        certificateArn: "certificateArn",
        certificatePem: "certificatePem",
        certificateId: "certificateId",
        keyPair: KeyPair(privateKey: "privateKey", publicKey: "publicKey"));

    return resp;
  }

  @override
  Future<void> attachPolicy(String policyName, String target) async {}

  @override
  Future<void> attachThingPrincipal(String thingName, String principal) async {}

  @override
  Future<CreateThingResponse> createThing(String thing) async {
    return CreateThingResponse(thingName: thing);
  }

  @override
  Future<String?> createGroup(String group) async {
    _thingGroupMap[group] = [];
    addThingToGroup(thingName: demoDeviceSN, groupName: group);
    return group;
  }

  @override
  Future<void> addThingToGroup(
      {required String thingName, required String groupName}) async {
    _thingGroupMap[groupName]!.add(thingName);
  }

  @override
  Future<void> removeThingFromGroup(
      {required String thingName, required String groupName}) async {
    _thingGroupMap[groupName]?.removeWhere((element) => element == thingName);
  }

  @override
  Future<void> updateThing(
      {required String thingName,
      required Map<String, String> attributes}) async {}

  @override
  Future<List<String>> listThingsInGroup(String group) async =>
      _thingGroupMap[group] ?? [];

  @override
  Future<List<String>> listThingGroups() async => _thingGroupMap.keys.toList();

  @override
  Future<bool> isGroupExist(String name) async {
    return _thingGroupMap.keys.toList().any((group) => group == name);
  }

  @override
  Future<bool> isThingExist(String name) async {
    return _thingGroupMap.values
        .toList()
        .any((list) => list.any((thing) => thing == name));
  }

  @override
  Future<bool> isCertificateActive(String id) async => true;

  @override
  Future<ListThingsResponse> listThingsByAttribute(
      {required String attributeName, required String attributeValue}) async {
    final Map<String, String> attributes = {};
    attributes[serialNumberKey] = demoDeviceSN;
    attributes[secureCodeKey] = demoDeviceSC;
    final List<ThingAttribute> things = [
      ThingAttribute(thingName: demoDeviceSN, attributes: attributes)
    ];
    return ListThingsResponse(things: things);
  }

  @override
  Future<DescribeThingResponse> describeThing(
      {required String thingName}) async {
    return DescribeThingResponse();
  }
}
