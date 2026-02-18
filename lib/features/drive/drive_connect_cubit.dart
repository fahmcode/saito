import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

abstract class DriveConnectState extends Equatable {
  const DriveConnectState();
  @override
  List<Object?> get props => [];
}

class DriveConnecting extends DriveConnectState {
  const DriveConnecting();
}

class DriveDisconnected extends DriveConnectState {
  const DriveDisconnected();
}

class DriveConnected extends DriveConnectState {
  final String accountId;
  final String? email;
  final bool offlineOnly;

  const DriveConnected({
    required this.accountId,
    this.email,
    this.offlineOnly = false,
  });

  @override
  List<Object?> get props => [accountId, email, offlineOnly];
}

class DriveError extends DriveConnectState {
  final String message;
  final Object? details;
  const DriveError(this.message, {this.details});

  @override
  List<Object?> get props => [message, details];
}

class DriveConnectCubit extends Cubit<DriveConnectState> {
  final GoogleSignIn _googleSignIn;

  DriveConnectCubit({GoogleSignIn? signIn})
    : _googleSignIn =
          signIn ??
          GoogleSignIn(scopes: const [drive.DriveApi.driveAppdataScope]),
      super(const DriveConnecting()) {
    attemptSilentSignIn();
  }

  GoogleSignIn get signIn => _googleSignIn;

  Future<void> attemptSilentSignIn() async {
    try {
      debugPrint('DriveConnectCubit: attempting silent sign-in...');
      final account = await _googleSignIn.signInSilently();
      if (account == null) {
        debugPrint(
          'DriveConnectCubit: no previous account, staying signed out',
        );
        emit(const DriveDisconnected());
        return;
      }
      emit(DriveConnected(accountId: account.id, email: account.email));
      debugPrint(
        'DriveConnectCubit: silent sign-in restored ${account.email} (${account.id})',
      );
    } catch (e, st) {
      debugPrint('Drive silent sign-in failed: $e\n$st');
      emit(DriveError('Unable to restore session', details: e));
    }
  }

  Future<void> connect() async {
    emit(const DriveConnecting());
    try {
      debugPrint(
        'DriveConnectCubit: starting interactive sign-in with scopes: '
        '${_googleSignIn.scopes.join(', ')}',
      );
      final account = await _googleSignIn.signIn();
      if (account == null) {
        debugPrint('DriveConnectCubit: user canceled sign-in');
        emit(const DriveDisconnected());
        return;
      }
      emit(DriveConnected(accountId: account.id, email: account.email));
      debugPrint(
        'DriveConnectCubit: signed in ${account.email} (${account.id})',
      );
    } catch (e, st) {
      if (e is PlatformException) {
        debugPrint(
          'DriveConnectCubit: PlatformException(code=${e.code}, '
          'message=${e.message}, details=${e.details})',
        );
      }
      debugPrint('Drive connect error: $e\n$st');
      emit(
        DriveError(
          'Failed to connect to Google Drive',
          details: e is PlatformException
              ? {'code': e.code, 'message': e.message, 'details': e.details}
              : e.toString(),
        ),
      );
    }
  }

  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
    } catch (_) {}
    emit(const DriveDisconnected());
  }

  void useOfflineOnly() {
    emit(const DriveConnected(accountId: 'local', offlineOnly: true));
  }
}
