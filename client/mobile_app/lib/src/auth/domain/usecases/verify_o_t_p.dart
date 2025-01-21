import 'package:buyghana/core/usecase/usecase.dart';
import 'package:buyghana/core/utils/typedefs.dart';
import 'package:buyghana/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class VerifyOTP extends UsecaseWithParams<void, VerifyOTPParams> {
  const VerifyOTP(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(VerifyOTPParams params) => _repo.verifyOTP(
        email: params.email,
        otp: params.otp,
      );
}

class VerifyOTPParams extends Equatable {
  const VerifyOTPParams({
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  List<dynamic> get props => [email, otp];
}
