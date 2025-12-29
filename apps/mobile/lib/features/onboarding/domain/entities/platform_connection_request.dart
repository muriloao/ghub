import 'package:equatable/equatable.dart';

class PlatformConnectionRequest extends Equatable {
  final String platformId;
  final Map<String, dynamic> credentials;

  const PlatformConnectionRequest({
    required this.platformId,
    required this.credentials,
  });

  @override
  List<Object?> get props => [platformId, credentials];
}
