/// Exception métier unique pour les erreurs réseau / backend.
///
/// L'UI attrape uniquement `ApiException`, pas `DioException`.
sealed class ApiException implements Exception {
  const ApiException._();

  const factory ApiException.timeout() = TimeoutApiException;
  const factory ApiException.network() = NetworkApiException;
  const factory ApiException.cancelled() = CancelledApiException;
  const factory ApiException.unauthorized() = UnauthorizedApiException;
  const factory ApiException.forbidden() = ForbiddenApiException;
  const factory ApiException.notFound() = NotFoundApiException;
  const factory ApiException.server(int statusCode) = ServerApiException;
  const factory ApiException.badRequest(int statusCode, String? message) =
      BadRequestApiException;
  const factory ApiException.unknown(String message) = UnknownApiException;

  String get message;

  /// Message utilisateur-friendly (FR).
  String get userMessage => message;
}

class TimeoutApiException extends ApiException {
  const TimeoutApiException() : super._();
  @override
  String get message => 'timeout';
  @override
  String get userMessage =>
      'La connexion est lente. Vérifie ton réseau et réessaie.';
}

class NetworkApiException extends ApiException {
  const NetworkApiException() : super._();
  @override
  String get message => 'network';
  @override
  String get userMessage => 'Pas de connexion internet.';
}

class CancelledApiException extends ApiException {
  const CancelledApiException() : super._();
  @override
  String get message => 'cancelled';
}

class UnauthorizedApiException extends ApiException {
  const UnauthorizedApiException() : super._();
  @override
  String get message => 'unauthorized';
  @override
  String get userMessage => 'Session expirée. Reconnecte-toi.';
}

class ForbiddenApiException extends ApiException {
  const ForbiddenApiException() : super._();
  @override
  String get message => 'forbidden';
  @override
  String get userMessage => 'Tu n\'as pas accès à cette ressource.';
}

class NotFoundApiException extends ApiException {
  const NotFoundApiException() : super._();
  @override
  String get message => 'not_found';
  @override
  String get userMessage => 'Ressource introuvable.';
}

class ServerApiException extends ApiException {
  const ServerApiException(this.statusCode) : super._();
  final int statusCode;
  @override
  String get message => 'server_$statusCode';
  @override
  String get userMessage =>
      'Le serveur rencontre un problème. Réessaie dans quelques minutes.';
}

class BadRequestApiException extends ApiException {
  const BadRequestApiException(this.statusCode, this.detail) : super._();
  final int statusCode;
  final String? detail;
  @override
  String get message => 'bad_request_$statusCode';
  @override
  String get userMessage => detail ?? 'Requête invalide.';
}

class UnknownApiException extends ApiException {
  const UnknownApiException(this.detail) : super._();
  final String detail;
  @override
  String get message => 'unknown: $detail';
  @override
  String get userMessage => 'Une erreur inattendue est survenue.';
}
