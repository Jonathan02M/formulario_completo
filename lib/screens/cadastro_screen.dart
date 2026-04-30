import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../validators/form_validators.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();
  final telCtrl = TextEditingController();
  final dataCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  final nomeFocus = FocusNode();
  final emailFocus = FocusNode();
  final cpfFocus = FocusNode();
  final telFocus = FocusNode();
  final dataFocus = FocusNode();
  final senhaFocus = FocusNode();
  final confirmFocus = FocusNode();

  bool aceitou = false;
  bool enviando = false;
  bool verificandoEmail = false;
  String? erroEmailAsync;
  String? erroTermos;

  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final dataMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final emailsExistentes = ["teste@gmail.com", "admin@gmail.com"];

  Future<void> verificarEmail(String email) async {
    setState(() => verificandoEmail = true);

    await Future.delayed(Duration(seconds: 2));

    erroEmailAsync =
        emailsExistentes.contains(email) ? "Email já cadastrado" : null;

    setState(() => verificandoEmail = false);
  }

  void enviar() async {
    setState(() {
      erroTermos = aceitou ? null : "Obrigatório aceitar os termos";
    });

    if (!_formKey.currentState!.validate() || !aceitou) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro no formulário"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => enviando = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() => enviando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Cadastro realizado!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    emailCtrl.dispose();
    cpfCtrl.dispose();
    telCtrl.dispose();
    dataCtrl.dispose();
    senhaCtrl.dispose();
    confirmCtrl.dispose();

    nomeFocus.dispose();
    emailFocus.dispose();
    cpfFocus.dispose();
    telFocus.dispose();
    dataFocus.dispose();
    senhaFocus.dispose();
    confirmFocus.dispose();

    super.dispose();
  }

  Widget campo({
    required String label,
    required TextEditingController controller,
    required FocusNode focus,
    FocusNode? nextFocus,
    TextInputType? type,
    bool obscure = false,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    IconData? icon,
    String? hint,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        focusNode: focus,
        keyboardType: type,
        obscureText: obscure,
        validator: validator,
        inputFormatters: inputFormatters,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Color(0xFF6C63FF)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8E85FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Criar Conta",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),

                    campo(
                      label: "Nome",
                      controller: nomeCtrl,
                      focus: nomeFocus,
                      nextFocus: emailFocus,
                      validator: FormValidators.nome,
                      icon: Icons.person,
                    ),

                    campo(
                      label: "Email",
                      controller: emailCtrl,
                      focus: emailFocus,
                      nextFocus: cpfFocus,
                      validator: (v) =>
                          FormValidators.email(v) ?? erroEmailAsync,
                      icon: Icons.email,
                    ),

                    campo(
                      label: "CPF",
                      controller: cpfCtrl,
                      focus: cpfFocus,
                      nextFocus: telFocus,
                      validator: FormValidators.cpf,
                      inputFormatters: [cpfMask],
                      icon: Icons.badge,
                    ),

                    campo(
                      label: "Telefone",
                      controller: telCtrl,
                      focus: telFocus,
                      nextFocus: dataFocus,
                      validator: FormValidators.telefone,
                      inputFormatters: [telefoneMask],
                      icon: Icons.phone,
                    ),

                    campo(
                      label: "Data de nascimento",
                      controller: dataCtrl,
                      focus: dataFocus,
                      nextFocus: senhaFocus,
                      validator: FormValidators.data,
                      inputFormatters: [dataMask],
                      icon: Icons.calendar_today,
                    ),

                    campo(
                      label: "Senha",
                      controller: senhaCtrl,
                      focus: senhaFocus,
                      nextFocus: confirmFocus,
                      obscure: true,
                      validator: FormValidators.senha,
                      icon: Icons.lock,
                    ),

                    campo(
                      label: "Confirmar senha",
                      controller: confirmCtrl,
                      focus: confirmFocus,
                      obscure: true,
                      validator: (v) =>
                          FormValidators.confirmarSenha(
                              v, senhaCtrl.text),
                      icon: Icons.lock_outline,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: aceitou,
                              onChanged: (v) {
                                setState(() {
                                  aceitou = v!;
                                  erroTermos = null;
                                });
                              },
                            ),
                            Text("Aceitar termos"),
                          ],
                        ),
                        if (erroTermos != null)
                          Text(
                            erroTermos!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                      ],
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: enviando ? null : enviar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C63FF),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: enviando
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Cadastrar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}