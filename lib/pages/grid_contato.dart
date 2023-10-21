import 'package:app_lista_contatos/models/contato_model.dart';
import 'package:app_lista_contatos/repositories/contato_repository.dart';
import 'package:flutter/material.dart';

class GridContato extends StatefulWidget {
  const GridContato({super.key});

  @override
  State<GridContato> createState() => _GridContatoState();
}

class _GridContatoState extends State<GridContato> {
  late double width = MediaQuery.of(context).size.width;
  ContatoRepository contatoRepository = ContatoRepository();

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void updateSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;

      _sortAscending = ascending;
    });
  }

  List<DataColumn> _createColumns(List<ContatoModel> items) {
    return [
      const DataColumn(
        label: Text("Ação"),
        numeric: false,
        tooltip: 'Ação',
      ),
      DataColumn(
        label: const SizedBox(
            width: 100, child: Text('Id', textAlign: TextAlign.center)),
        numeric: false, // Deliberately set to false to avoid right alignment.
        tooltip: 'Id',
        onSort: (int columnIndex, bool ascending) {
          if (ascending) {
            items
                .sort((item1, item2) => item1.getId().compareTo(item2.getId()));
          } else {
            items
                .sort((item1, item2) => item2.getId().compareTo(item1.getId()));
          }
          updateSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: const SizedBox(
            width: 100, child: Text('Nome', textAlign: TextAlign.center)),
        numeric: false, // Deliberately set to false to avoid right alignment.
        tooltip: 'Nome',
        onSort: (int columnIndex, bool ascending) {
          if (ascending) {
            items.sort(
                (item1, item2) => item1.getNome().compareTo(item2.getNome()));
          } else {
            items.sort(
                (item1, item2) => item2.getNome().compareTo(item1.getNome()));
          }
          updateSort(columnIndex, ascending);
        },
      ),
    ];
  }

  DataRow _createRow(ContatoModel item) {
    return DataRow(
      key: ValueKey(item.getId()),
      cells: [
        DataCell(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  _showAlertDelete(context, item.getId());
                },
                tooltip: "Deletar",
              )
            ],
          ),
        ),
        DataCell(
          SizedBox(
            width: 100, //SET width
            child: Text(item.getId().toString(), textAlign: TextAlign.center),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100, //SET width
            child: Text(item.getNome(), textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteIMC(int data) async {
    contatoRepository.deletar(data);
    setState(() {});
  }

  _showAlertDelete(BuildContext context, int data) {
    Widget excluirButton = SizedBox(
      width: 100.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text("Excluir"),
        onPressed: () {
          _deleteIMC(data);
          Navigator.of(context).pop();
        },
      ),
    );

    Widget cancelarButton = SizedBox(
      width: 100.0,
      //height: 100.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text("Cancelar"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Deseja excluir o Contato?",
        style: TextStyle(fontSize: 18.0),
      ),
      content: const Text("Excluindo o contato não será possível recuperá-lo."),
      actions: [
        excluirButton,
        cancelarButton,
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<List<ContatoModel>> _getListContato() async {
    return await contatoRepository.obterDados();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContatoModel>>(
      future: _getListContato(),
      builder: ((context, AsyncSnapshot<List<ContatoModel>> snapshot) {
        final data = snapshot.data;
        if (snapshot.hasData ||
            data != null ||
            snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            width: width,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: width),
                      child: DataTable(
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        columnSpacing: 0,
                        dividerThickness: 5,
                        dataRowMaxHeight: 80,
                        dataTextStyle: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                        ),
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blueAccent),
                        headingRowHeight: 50,
                        headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        horizontalMargin: 10,
                        showBottomBorder: true,
                        showCheckboxColumn: false,
                        columns: _createColumns(data!),
                        rows: data.map((item) => _createRow(item)).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
