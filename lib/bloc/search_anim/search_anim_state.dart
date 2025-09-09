part of 'search_anim_cubit.dart';

@immutable
sealed class SearchAnimState {}

final class SearchAnimClose extends SearchAnimState {}

final class SearchAnimOpen extends SearchAnimState {}
