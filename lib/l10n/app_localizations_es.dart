// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Rastreador de Presupuesto';

  @override
  String get home => 'Inicio';

  @override
  String get categories => 'Categorías';

  @override
  String get settings => 'Configuración';

  @override
  String get reports => 'Informes';

  @override
  String get income => 'Ingreso';

  @override
  String get expense => 'Gasto';

  @override
  String get balance => 'Saldo';

  @override
  String get selectDate => 'Selecciona una fecha para ver transacciones';

  @override
  String get noTransactions => 'No hay transacciones para esta fecha';

  @override
  String get addCategory => 'Agregar Categoría';

  @override
  String get categoryName => 'Nombre de Categoría';

  @override
  String get color => 'Color';

  @override
  String get type => 'Tipo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Agregar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirmDelete => 'Confirmar Eliminación';

  @override
  String confirmDeleteCategory(Object name) {
    return '¿Estás seguro de que quieres eliminar la categoría \"$name\"?';
  }

  @override
  String get confirmDeleteTransaction => '¿Estás seguro de que quieres eliminar esta transacción?';

  @override
  String get deleted => 'eliminado';

  @override
  String get transactionDeleted => 'Transacción eliminada';

  @override
  String get amount => 'Monto';

  @override
  String get category => 'Categoría';

  @override
  String get date => 'Fecha';

  @override
  String get explanation => 'Explicación';

  @override
  String get addTransaction => 'Agregar Transacción';

  @override
  String get editTransaction => 'Editar Transacción';

  @override
  String get saveTransaction => 'Guardar Transacción';

  @override
  String get updateTransaction => 'Actualizar Transacción';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get turkish => 'Turco';

  @override
  String get unknown => 'Desconocido';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get pickColor => 'Elegir un color';

  @override
  String get select => 'Seleccionar';

  @override
  String get monthFormat => 'Mes';

  @override
  String get twoWeekFormat => '2 Semanas';

  @override
  String get weekFormat => 'Semana';

  @override
  String get currency => 'Moneda';

  @override
  String get usd => 'Dólar estadounidense (USD)';

  @override
  String get eur => 'Euro (EUR)';

  @override
  String get gbp => 'Libra esterlina (GBP)';

  @override
  String get tl => 'Lira turca (TRY)';

  @override
  String get jpy => 'Yen japonés (JPY)';

  @override
  String get inr => 'Rupia india (INR)';

  @override
  String get noCategories => 'No hay categorías disponibles';

  @override
  String get update => 'Actualizar';

  @override
  String get breakdown => 'Detalles';

  @override
  String get total => 'Total';

  @override
  String get recurring => 'Recurrente';

  @override
  String get isRecurring => '¿Es recurrente?';

  @override
  String get endDate => 'Fecha final';

  @override
  String get tutorialAddTransactionTitle => 'Agregar transacción';

  @override
  String get tutorialAddTransactionDesc => 'Toca aquí para agregar tu primer ingreso o gasto.';

  @override
  String get tutorialCategoriesTabTitle => 'Categorías';

  @override
  String get tutorialCategoriesTabDesc => 'Administra tus categorías aquí para organizar tus finanzas.';

  @override
  String get tutorialAddCategoryTitle => 'Agregar categoría';

  @override
  String get tutorialAddCategoryDesc => 'Crea categorías personalizadas para un mejor seguimiento.';

  @override
  String get tutorialReportsTabTitle => 'Informes';

  @override
  String get tutorialReportsTabDesc => 'Mira tu resumen financiero y gráficos aquí.';

  @override
  String get tutorialReportsTitle => 'Resumen de informes';

  @override
  String get tutorialReportsDesc => 'Analiza tus hábitos de gasto con gráficos detallados.';

  @override
  String get tutorialNext => 'Siguiente';

  @override
  String get tutorialFinish => 'Finalizar';
}
