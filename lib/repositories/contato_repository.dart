import 'package:app_lista_contatos/models/contato_model.dart';
import 'package:app_lista_contatos/repositories/sqlite/sqlite_database.dart';

class ContatoRepository {
  Future<List<ContatoModel>> obterDados() async {
    List<ContatoModel> listContato = [];
    var db = await SqliteDataBase().getDatabase();
    var result = await db.rawQuery('SELECT id, nome, path from contato');
    for (var element in result) {
      var contato = ContatoModel();
      contato.setId(int.parse(element["id"].toString()));
      contato.setNome(element["nome"].toString());
      contato.setPathPhoto(element["path"].toString());

      listContato.add(contato);
    }
    return listContato;
  }

  Future<void> salvar(ContatoModel model) async {
    var db = await SqliteDataBase().getDatabase();
    await db.rawInsert(
      'INSERT INTO contato (nome, path) values(?,?)',
      [
        model.getNome(),
        model.getPathPhoto(),
      ],
    );
  }

  Future<void> alterar(ContatoModel model) async {
    var db = await SqliteDataBase().getDatabase();
    await db.rawInsert(
      'UPDATE contato SET nome = ?, path = ? WHERE id = ?',
      [model.getNome(), model.getPathPhoto(), model.getId()],
    );
  }

  Future<void> deletar(int id) async {
    var db = await SqliteDataBase().getDatabase();
    await db.rawInsert(
      'DELETE from contato WHERE id = ?',
      [id],
    );
  }
}
