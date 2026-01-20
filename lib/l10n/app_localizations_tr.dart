// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Bütçe Takipçisi';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get categories => 'Kategoriler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get reports => 'Raporlar';

  @override
  String get income => 'Gelir';

  @override
  String get expense => 'Gider';

  @override
  String get balance => 'Bakiye';

  @override
  String get selectDate => 'İşlemleri görüntülemek için bir tarih seçin';

  @override
  String get noTransactions => 'Bu tarih için işlem yok';

  @override
  String get addCategory => 'Kategori Ekle';

  @override
  String get categoryName => 'Kategori Adı';

  @override
  String get color => 'Renk';

  @override
  String get type => 'Tür';

  @override
  String get cancel => 'İptal';

  @override
  String get add => 'Ekle';

  @override
  String get delete => 'Sil';

  @override
  String get confirmDelete => 'Silmeyi Onayla';

  @override
  String confirmDeleteCategory(Object name) {
    return '$name kategorisini silmek istediğinizden emin misiniz?';
  }

  @override
  String get confirmDeleteTransaction => 'Bu işlemi silmek istediğinizden emin misiniz?';

  @override
  String get deleted => 'silindi';

  @override
  String get transactionDeleted => 'İşlem silindi';

  @override
  String get amount => 'Tutar';

  @override
  String get category => 'Kategori';

  @override
  String get date => 'Tarih';

  @override
  String get explanation => 'Açıklama';

  @override
  String get addTransaction => 'İşlem Ekle';

  @override
  String get editTransaction => 'İşlemi Düzenle';

  @override
  String get saveTransaction => 'İşlemi Kaydet';

  @override
  String get updateTransaction => 'İşlemi Güncelle';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Dil';

  @override
  String get english => 'İngilizce';

  @override
  String get spanish => 'İspanyolca';

  @override
  String get turkish => 'Türkçe';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get light => 'Açık';

  @override
  String get dark => 'Koyu';

  @override
  String get system => 'Sistem';

  @override
  String get pickColor => 'Bir renk seç';

  @override
  String get select => 'Seç';

  @override
  String get monthFormat => 'Ay';

  @override
  String get twoWeekFormat => '2 Hafta';

  @override
  String get weekFormat => 'Hafta';

  @override
  String get currency => 'Para Birimi';

  @override
  String get usd => 'Amerikan Doları (USD)';

  @override
  String get eur => 'Euro (EUR)';

  @override
  String get gbp => 'İngiliz Sterlini (GBP)';

  @override
  String get tl => 'Türk Lirası (TRY)';

  @override
  String get jpy => 'Japon Yeni (JPY)';

  @override
  String get inr => 'Hint Rupisi (INR)';

  @override
  String get noCategories => 'Kategori bulunamadı';

  @override
  String get update => 'Güncelle';

  @override
  String get breakdown => 'Detaylar';

  @override
  String get total => 'Toplam';

  @override
  String get recurring => 'Tekrarlayan';

  @override
  String get isRecurring => 'Tekrarlayan İşlem mi?';

  @override
  String get endDate => 'Bitiş Tarihi';

  @override
  String get tutorialAddTransactionTitle => 'İşlem Ekle';

  @override
  String get tutorialAddTransactionDesc => 'İlk gelirinizi veya giderinizi eklemek için buraya dokunun.';

  @override
  String get tutorialCategoriesTabTitle => 'Kategoriler';

  @override
  String get tutorialCategoriesTabDesc => 'Finansınızı düzenlemek için kategorilerinizi buradan yönetin.';

  @override
  String get tutorialAddCategoryTitle => 'Kategori Ekle';

  @override
  String get tutorialAddCategoryDesc => 'Daha iyi takip için özel kategoriler oluşturun.';

  @override
  String get tutorialReportsTabTitle => 'Raporlar';

  @override
  String get tutorialReportsTabDesc => 'Finansal özetinizi ve grafiklerinizi buradan görüntüleyin.';

  @override
  String get tutorialReportsTitle => 'Raporlara Genel Bakış';

  @override
  String get tutorialReportsDesc => 'Harcama alışkanlıklarınızı detaylı grafiklerle analiz edin.';

  @override
  String get tutorialNext => 'İleri';

  @override
  String get tutorialFinish => 'Bitir';
}
