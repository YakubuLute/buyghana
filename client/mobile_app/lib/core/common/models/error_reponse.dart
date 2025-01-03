import 'package:ecomly/core/utils/typedefs.dart';
import 'package:equatable/equatable.dart';

class ErrorResponse extends Equatable {
  const ErrorResponse({this.type, this.message, this.errorMessages});

  factory ErrorResponse.fromMap(DataMap map) {
    var errorMessages = (map['errors'] as List?)
        ?.cast<DataMap>()
        .map((error) => error['message'] as String)
        .toList();
    if (errorMessages != null && errorMessages.isEmpty) errorMessages = null;
    return ErrorResponse(
      type: map['type'] as String?,
      message: map['message'] as String?,
      errorMessages: errorMessages,
    );
  }

  final String? type;
  final String? message;
  final List<String>? errorMessages;

  String get errorMessage {
    var payload = '';
    if (type != null) payload = '${type!}\n';
    if (message != null) {
      payload += message!;
    } else {
      if (errorMessages != null) {
        payload += '\nWhat went wrong?';
        for (final (index, message) in errorMessages!.indexed) {
          if (index == 0) {
            payload += '\n$message';
          } else {
            payload += '\n\n$message';
          }
        }
      }
    }
    return payload;
  }

  @override
  List<Object?> get props => [type, message];
}
