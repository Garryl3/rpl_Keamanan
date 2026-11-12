import 'package:flutter_test/flutter_test.dart';
import '../../lib/utils/validators.dart';

void main() {
  group('Validators - isValidEmail', () {
    test('Email valid mengembalikan true', () {
      expect(Validators.isValidEmail('abid@example.com'), isTrue);
      expect(Validators.isValidEmail('user.name+test@amikom.ac.id'), isTrue);
    });

    test('Email invalid mengembalikan false', () {
      expect(Validators.isValidEmail('invalid-email'), isFalse);
      expect(Validators.isValidEmail('@domain.com'), isFalse);
      expect(Validators.isValidEmail('user@.com'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('Validators - sanitize', () {
    test('Mencegah serangan XSS dengan konversi karakter khusus', () {
      const payload = '<script>alert("hack")</script>';
      final sanitized = Validators.sanitize(payload);
      expect(sanitized, '&lt;script&gt;alert(&quot;hack&quot;)&lt;/script&gt;');
    });

    test('Konversi petik tunggal', () {
      expect(Validators.sanitize("admin'--"), 'admin&#x27;--');
    });
  });

  group('Validators - validateText', () {
    test('Mengembalikan null jika teks valid', () {
      expect(Validators.validateText('Teks Valid', minLength: 3, maxLength: 20), isNull);
    });

    test('Mengembalikan error jika teks kosong', () {
      expect(Validators.validateText('   ', fieldName: 'Judul'), equals('Judul tidak boleh kosong'));
      expect(Validators.validateText(null, fieldName: 'Judul'), equals('Judul tidak boleh kosong'));
    });

    test('Mengembalikan error jika panjang teks tidak sesuai rentang', () {
      expect(
        Validators.validateText('AB', fieldName: 'Kode', minLength: 3, maxLength: 5),
        equals('Kode harus antara 3-5 karakter'),
      );
    });
  });

  group('Validators - validatePhone', () {
    test('Nomor HP 10-13 digit valid', () {
      expect(Validators.validatePhone('08123456789'), isNull);
      expect(Validators.validatePhone('0812345678901'), isNull);
    });

    test('Nomor HP dengan huruf atau panjang tak sesuai dianggap invalid', () {
      expect(Validators.validatePhone('0812345'), isNotNull);
      expect(Validators.validatePhone('0812345678901234'), isNotNull);
      expect(Validators.validatePhone('0812abc34567'), isNotNull);
    });
  });

  group('Validators - validateUrl', () {
    test('URL dengan skema http/https valid', () {
      expect(Validators.validateUrl('https://jsonplaceholder.typicode.com'), isNull);
      expect(Validators.validateUrl('http://amikom.ac.id'), isNull);
    });

    test('URL tanpa skema atau format keliru invalid', () {
      expect(Validators.validateUrl('ftp://example.com'), isNotNull);
      expect(Validators.validateUrl('example.com'), isNotNull);
    });
  });

  group('Validators - validatePassword', () {
    test('Password kuat (minimal 8 kar, kapital, angka, simbol) valid', () {
      expect(Validators.validatePassword('P@ssword1'), isNull);
      expect(Validators.validatePassword('Amikom#2026'), isNull);
    });

    test('Password yang melanggar kriteria keamanan return error', () {
      expect(Validators.validatePassword('pass1!'), isNotNull);
      expect(Validators.validatePassword('password1!'), isNotNull);
      expect(Validators.validatePassword('Password!!'), isNotNull);
      expect(Validators.validatePassword('Password123'), isNotNull);
    });
  });
}