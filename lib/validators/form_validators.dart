class FormValidators {
  static String? nome(String? value) {
    if (value == null || value.isEmpty) return "Nome obrigatório";
    if (value.length < 3) return "Mínimo 3 caracteres";
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return "Email obrigatório";
    if (!value.contains("@") || !value.contains(".")) {
      return "Email inválido";
    }
    return null;
  }

  static String? cpf(String? value) {
    if (value == null || value.isEmpty) return "CPF obrigatório";
    if (value.length != 14) return "Formato: XXX.XXX.XXX-XX";
    return null;
  }

  static String? telefone(String? value) {
    if (value == null || value.isEmpty) return "Telefone obrigatório";
    if (value.length != 15) return "Formato: (XX) XXXXX-XXXX";
    return null;
  }

  static String? data(String? value) {
    if (value == null || value.isEmpty) return "Data obrigatória";
    if (value.length != 10) return "Formato: DD/MM/AAAA";
    return null;
  }

  static String? senha(String? value) {
    if (value == null || value.isEmpty) return "Senha obrigatória";
    if (value.length < 6) return "Mínimo 6 caracteres";
    return null;
  }

  static String? confirmarSenha(String? value, String senha) {
    if (value != senha) return "Senhas não coincidem";
    return null;
  }
}