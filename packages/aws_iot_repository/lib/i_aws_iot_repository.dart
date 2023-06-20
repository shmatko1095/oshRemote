import 'dart:async';

import 'package:aws_iot_api/iot-2015-05-28.dart';

abstract class IAwsIotRepository {
  Future<CreateKeysAndCertificateResponse> createCertificate();

  Future<void> attachPolicy(String policyName, String target);

  Future<void> attachThingPrincipal(String thingName, String principal);

  Future<CreateThingResponse> createThing(String thing);

  Future<String?> createGroup(String group);

  Future<void> addThingToGroup(
      {required String thingName, required String groupName});

  Future<void> removeThingFromGroup(
      {required String thingName, required String groupName});

  Future<void> updateThing(
      {required String thingName, required Map<String, String> attributes});

  Future<List<String>> listThingsInGroup(String group);

  Future<List<String>> listThingGroups();

  Future<bool> isGroupExist(String name);

  Future<bool> isThingExist(String name);

  Future<bool> isCertificateActive(String id);

  Future<ListThingsResponse> listThingsByAttribute(
      {required String attributeName, required String attributeValue});

  Future<DescribeThingResponse> describeThing({required String thingName});
}
