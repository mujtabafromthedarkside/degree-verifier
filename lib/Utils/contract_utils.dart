import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:degree_verifier/Config/secrets.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString("lib/Config/abi2.json");
  final contract = DeployedContract(ContractAbi.fromJson(abi, "degreeVerifier"), EthereumAddress.fromHex(secrets["contractAddress"]!));
  return contract;
}

Future<List<dynamic>> query(Web3Client ethClient, String functionName, List<dynamic> args) async {
  final contract = await loadContract();
  final ethFunction = contract.function(functionName);
  List<dynamic> result = await ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> submit(Web3Client ethClient, String functionName, List<dynamic> args) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(secrets["privateKey"]!);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.sendTransaction(credentials, Transaction.callContract(contract: contract, function: ethFunction, parameters: args), chainId: 11155111);

  return result;
}
