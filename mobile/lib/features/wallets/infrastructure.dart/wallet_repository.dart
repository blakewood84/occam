import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:http/http.dart' as http;

import 'package:mobile/features/wallets/domain/wallet.dart';
import 'package:mobile/features/wallets/domain/i_wallet_facade.dart';

class WalletRepository extends IWalletFacade {
  @override
  Future<Either<List<Wallet>, Unit>> fetchWallets() async {
    try {
      print(userEmail);
      final data = await FirebaseFirestore.instance.collection('wallets').doc(userEmail).get();
      print(data.data());
      if (data.exists) {
        final List<Wallet> wallets =
            data.data()!['wallets'].map((wallet) => Wallet.fromSnapshot(wallet)).toList().cast<Wallet>();

        return left(wallets);
      } else {
        throw Exception('Collection Doesnt Exist!');
      }
    } catch (error) {
      print('ERROR: $error');
      return right(unit);
    }
  }

  @override
  Future<Either<Wallet, Unit>> createNewWallet({required String displayName}) async {
    try {
      final Uri uri = Uri.parse('http://localhost:3000/createWallet');
      final response = await http.post(uri, body: {
        'userId': userEmail,
        'name': displayName,
      });
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final wallet = Wallet.fromSnapshot(parsed);
        return left(wallet);
      } else {
        throw Exception('Error with request');
      }
    } catch (error) {
      return right(unit);
    }
  }
}
