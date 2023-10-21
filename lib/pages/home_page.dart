import 'package:app_lista_contatos/models/contato_model.dart';
import 'package:app_lista_contatos/pages/grid_contato.dart';
import 'package:app_lista_contatos/repositories/contato_repository.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double width = MediaQuery.of(context).size.width;
  TextEditingController nomeController = TextEditingController();
  TextEditingController pathController = TextEditingController();
  ContatoRepository _contatoRepository = ContatoRepository();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      pathController.text = croppedFile.path;
      await GallerySaver.saveImage(croppedFile.path);
    }
  }

  _gravarContato(ContatoModel model) async {
    await _contatoRepository.salvar(model);
  }

  Future<void> _salvarContato() async {
    ContatoModel contato = ContatoModel();
    contato.setId(0);
    contato.setNome(nomeController.text);
    contato.setPathPhoto(pathController.text);
    setState(() async {
      await _gravarContato(contato);
    });
  }

  _showAlertContato(BuildContext context) {
    Widget salvarButton = SizedBox(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
        child: const Text("Salvar"),
        onPressed: () {
          _salvarContato();
          Navigator.of(context).pop();
        },
      ),
    );

    Widget cancelarButton = SizedBox(
      width: 100,
      //height: 100.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
        child: const Text("Cancelar"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Salvar Contato?",
        style: TextStyle(fontSize: 18.0),
      ),
      content: SizedBox(
        width: width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 120.0,
                  color: Colors.blueAccent,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    labelStyle: TextStyle(
                      color: Colors.blueAccent,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 130, 223, 133),
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 25.0,
                  ),
                  controller: nomeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Insira um Nome!";
                    } else {
                      return null;
                    }
                  },
                ),
                Row(
                  children: [
                    const Text("Foto: "),
                    ElevatedButton(
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? photo = await _picker.pickImage(
                              source: ImageSource.camera);

                          if (photo != null) {
                            Navigator.pop(context);
                            setState(() {
                              cropImage(photo);
                            });
                          }
                        },
                        child: const Text("Tirar Foto"))
                  ],
                )
                // TextButton(
                //   onPressed: () async {
                //     showModalBottomSheet(
                //         context: context,
                //         builder: (_) {
                //           return Wrap(
                //             children: [
                //               ListTile(
                //                 leading: const Icon(Icons.camera),
                //                 title: const Text("Camera"),
                //                 onTap: () async {
                //                   final ImagePicker _picker = ImagePicker();
                //                   final XFile? photo = await _picker.pickImage(
                //                       source: ImageSource.camera);

                //                   if (photo != null) {
                //                     Navigator.pop(context);
                //                     cropImage(photo);
                //                   }
                //                 },
                //               ),
                //             ],
                //           );
                //         });
                //   },
                //   child: const Text("Camera"),
                // ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        salvarButton,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Contato"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () {
                setState(() {
                  _showAlertContato(context);
                });
              },
              child: const Text("Cadastrar Contato"),
            ),
            SizedBox(
              width: width,
              child: SingleChildScrollView(child: GridContato()),
            )
          ],
        ),
      ),
    );
  }
}
