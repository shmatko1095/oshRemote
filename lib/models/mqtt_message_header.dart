class MqttMessageHeader {
  /// QOS Level 0 - Message is not guaranteed delivery. No retries are made
  /// to ensure delivery is successful.
  ///
  /// QOS Level 1 - Message is guaranteed delivery. It will be delivered at
  /// least one time, but may be delivered more than once if network
  /// errors occur.
  ///
  /// QOS Level 2 - Message will be delivered once, and only once.
  /// Message will be retried until it is successfully sent.
  ///

  final int qos;
  final String topic;

  const MqttMessageHeader(this.topic, [this.qos = 0]);
}
