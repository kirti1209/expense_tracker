class Validators {
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }
    
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    
    if (value.length < 2) {
      return 'Title must be at least 2 characters long';
    }
    
    return null;
  }
}