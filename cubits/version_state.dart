part of 'version_cubit.dart';

@immutable
sealed class VersionState {}

final class VersionInitial extends VersionState {}

final class VersionLoading extends VersionState {}

final class VersionFailed extends VersionState {}

final class VersionSuccess extends VersionState {
  final String version;

  VersionSuccess(this.version);
}

final class FcmLoading extends VersionState {}

final class FcmFailed extends VersionState {}

final class FcmSuccess extends VersionState {}
