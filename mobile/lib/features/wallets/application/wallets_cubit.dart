import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/foundation.dart';
import 'package:mobile/features/wallets/domain/wallet.dart';
import 'package:mobile/features/wallets/infrastructure.dart/wallet_repository.dart';

part 'wallets_state.dart';

class WalletsCubit extends Cubit<WalletsState> {
  WalletsCubit(this.walletRepository) : super(WalletsState(status: WalletsStatus.initial));
  final WalletRepository walletRepository;

  Future<void> fetchWallets() async {
    emit(WalletsState(status: WalletsStatus.loading));
    final wallets = await walletRepository.fetchWallets();
    wallets.fold(
      (l) {
        // Find the last selected wallet in Memory
        // If no selected wallet, load index 0
        emit(
          WalletsState(
            status: WalletsStatus.success,
            wallets: l,
            selectedWallet: l[0],
          ),
        );
      },
      (r) => emit(
        WalletsState(
          status: WalletsStatus.failure,
        ),
      ),
    );
  }
}
