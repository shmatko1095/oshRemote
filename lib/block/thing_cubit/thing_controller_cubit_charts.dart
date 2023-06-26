part of 'thing_controller_cubit.dart';

extension ThingControllerCubitCharts on ThingControllerCubit {
  void _handleChartsUpdate(String sn, String payload) {
    final data = jsonDecode(payload);
    final thingCharts =
        ThingCharts.fromNullableJson(data[ThingChartsKey.charts]);
    emit(state.copyWith(sn, charts: thingCharts));
  }
}
