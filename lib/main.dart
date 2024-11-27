import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:degree_verifier/secrets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Client httpClient;
  late Web3Client ethClient;
  var myData;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(secrets["web3Client"]!, httpClient);
    getBalance();
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    final contract = DeployedContract(ContractAbi.fromJson(abi, "mycoin"), EthereumAddress.fromHex(secrets["contractAddress"]!));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    List<dynamic> result = await ethClient.call(contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(secrets["privateKey"]!);
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(credentials, Transaction.callContract(contract: contract, function: ethFunction, parameters: args), chainId: 11155111);

    return result;
  }

  Future<void> getBalance() async {
    List<dynamic> result = await query("getBalance", []);
    myData = result[0];
    print("my Data: ");
    print(myData);
  }

  Future<String> sendCoin() async {
    var bigAmount = BigInt.from(100);
    var response = await submit("depositBalance", [bigAmount]);
    print("Deposited" + bigAmount.toString());
    return response;
  }

  Future<String> withdrawCoin() async {
    var bigAmount = BigInt.from(100);
    var response = await submit("withdrawBalance", [bigAmount]);
    print("Withdrawn" + bigAmount.toString());
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // button to get balance
            ElevatedButton(
              onPressed: () {
                getBalance();
              },
              child: const Text("Get Balance"),
            ),

            // button to deposit balance
            ElevatedButton(
              onPressed: () {
                sendCoin();
              },
              child: const Text("Deposit Balance"),
            ),

            // button to withdraw balance
            ElevatedButton(
              onPressed: () {
                withdrawCoin();
              },
              child: const Text("Withdraw Balance"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
