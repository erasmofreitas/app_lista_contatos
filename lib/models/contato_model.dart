class ContatoModel {
  int _id = 0;
  String _nome = "";
  String _pathPhoto = "";

  void setId(int id) {
    _id = id;
  }

  int getId() {
    return _id;
  }

  void setNome(String nome) {
    _nome = nome;
  }

  String getNome() {
    return _nome;
  }

  void setPathPhoto(String pathPhoto) {
    _pathPhoto = pathPhoto;
  }

  String getPathPhoto() {
    return _pathPhoto;
  }
}
