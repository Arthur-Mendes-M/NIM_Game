import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController totalPalitosController = TextEditingController();
  TextEditingController limitePalitosController = TextEditingController();
  TextEditingController moveController = TextEditingController(); // Novo controller para a jogada do usuário
  int numberOfPieces = 0;
  int limit = 0;
  bool computerPlay = false;
  List<String> moveHistory = [];

  @override
  void initState() {
    super.initState();
  }

  void messageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void startGame() {
    numberOfPieces = int.tryParse(totalPalitosController.text) ?? 0;
    limit = int.tryParse(limitePalitosController.text) ?? 0;

    if (numberOfPieces < 2) {
      messageDialog('Quantidade de palitos inválida!', 'O valor deve ser maior ou igual a 2.');
      return;
    }

    if (limit <= 0 || limit >= numberOfPieces) {
      messageDialog('Limite de palitos inválido!', 'O valor deve ser maior que zero.');
      return;
    }

    setState(() {
      computerPlay = (numberOfPieces % (limit + 1)) == 0;
    });

    if (!computerPlay) {
      userPlay();
    } else {
      computerMove();
    }
  }

  void userPlay() {
    messageDialog('Sua vez.', 'Quantos palitos deseja tirar?');
  }

  void updateGame(int move) {
    setState(() {
      numberOfPieces -= move;
      moveHistory.add("Você tirou $move palito(s). Restam $numberOfPieces palitos.");
      if (numberOfPieces == 1) {
        endGame();
      } else {
        computerPlay = !computerPlay;
        if (computerPlay) {
          computerMove();
        } else {
          userPlay();
        }
      }
    });
  }

  void computerMove() {
    int computerMove = computerChoosesMove(numberOfPieces, limit);
    setState(() {
      numberOfPieces -= computerMove;
      moveHistory.add("O computador tirou $computerMove palito(s). Restam $numberOfPieces palitos.");

      // Voltar para dentro do else
      computerPlay = !computerPlay;

      if (numberOfPieces == 1) {
        endGame();
      } else {
        userPlay();
      }
    });
  }

  int computerChoosesMove(int numberOfPieces, int limit) {
    int remainder = numberOfPieces % (limit + 1);
    // int move = (remainder == 0) ? 1 : remainder;
    if (remainder == 0) {
      return limit;
    } else {
      return (remainder - 1) == 0 ? limit : (remainder - 1);
    }
    // return move;
  }

  void endGame() {
    // moveHistory.add("\n\nSobraram $numberOfPieces peças e a o computador joga? $computerPlay\n\n");
    String result = computerPlay ? "Você ganhou!" : "O computador ganhou!";
    messageDialog(result, 'Fim do jogo.');
  }

  void restartGame() {
    setState(() {
      numberOfPieces = 0;
      limit = 0;
      moveHistory.clear();
    });
  }

  void processUserMove() {
    int move = int.tryParse(moveController.text) ?? 0;
    if (move < 1 || move > limit) {
      messageDialog('Jogada inválida.', 'Tente novamente.');
    } else {
      updateGame(move);
      setState(() {
        moveController.text = ""; // Limpa o campo de entrada
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Arthur Mendes Martins', style: TextStyle(fontSize: 20)),
              accountEmail: Text('RA: 1431432312018', style: TextStyle(fontSize: 15)), // Adicione o email ou outra informação aqui
              currentAccountPicture: SizedBox(
                width: 60, // Largura da imagem definida como 50 pixels
                height: 60, // Altura da imagem definida como 50 pixels
                child: CircleAvatar(
                  backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/75858153?v=4'), // Substitua pela URL da imagem da web
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.purple[400], // Cor de fundo do Drawer Header
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Jogo NIM',
              style: TextStyle(color: Colors.white)
            ),
            Spacer(),
            Tooltip(
              message: 'Reiniciar Jogo',
              child: IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: restartGame,
              ),
            ),
          ],
        ), 
        backgroundColor: Colors.purple[500],
      ),
      body: SingleChildScrollView(
        child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(children: [
                    Expanded(
                      child:
                        TextField(
                          controller: totalPalitosController,
                          decoration: InputDecoration(labelText: 'Total de palitos'),
                          keyboardType: TextInputType.number,
                        ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child:
                        TextField(
                          controller: limitePalitosController,
                          decoration: InputDecoration(labelText: 'Limite de palitos'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple
                      ),
                      onPressed: startGame,
                      child: Text('Iniciar Jogo'),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: moveController,
                    decoration: InputDecoration(labelText: 'Sua jogada'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple
                      ),
                      onPressed: processUserMove,
                      child: Text('Jogar'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          itemCount: moveHistory.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                moveHistory[index],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}