﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Процедура КнопкаВыполнитьНажатие(Кнопка)

	Платформа = ирКэш.Получить();
	Если Ложь Тогда
	    Платформа = Обработки.ирПлатформа.Создать();
	КонецЕсли;
	НуженПерезапускПроцесса = Ложь;
	Для Каждого Строка Из ТаблицаCOMКомпонент Цикл 
		Если Не Строка.Установить Тогда
			Продолжить;
		КонецЕсли; 
		ИмяКомпоненты = Строка.Идентификатор;
		Если ИмяКомпоненты = "GoldParser" Тогда
			Путь = "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full";
			РеестрОС = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv");
			НомерВерсииNET = 0;
			РеестрОС.GetDWORDValue(, Путь, "Release", НомерВерсииNET);
			Если Не ЗначениеЗаполнено(НомерВерсииNET) Или НомерВерсииNET < 378389 Тогда
				Сообщить("Для установки компоненты " + ИмяКомпоненты + " необходимо установить NET Framework 4.5", СтатусСообщения.Внимание);
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		ФайлКомпоненты = Новый Файл(КаталогУстановки + "\" + ИмяКомпоненты + ".dll");
		ВременныйФайл = Новый Файл(ПолучитьИмяВременногоФайла("dll"));
		ДвоичныеДанные = Платформа.ПолучитьМакет(ИмяКомпоненты);
		Если ТипЗнч(ДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
			ФайлКомпоненты = Платформа.ПроверитьЗаписатьКомпонентуИзМакетаВФайл(ИмяКомпоненты, КаталогУстановки, "dll");
			Если ФайлКомпоненты = Неопределено Тогда 
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		Если Не ФайлКомпоненты.Существует() Тогда
			Сообщить("Для компоненты " + ИмяКомпоненты + " не обнаружен файл """ + ФайлКомпоненты.ПолноеИмя + """. ", СтатусСообщения.Внимание);
			Продолжить;
		КонецЕсли; 
		Если Не Строка.ВспомогательныйФайл Тогда
			Результат = Платформа.ЗарегистрироватьПолучитьCOMОбъект(Строка.ProgID, ФайлКомпоненты.ПолноеИмя, Истина, Строка.ИмяТипаВК);
			Если Результат = Неопределено Тогда
				НуженПерезапускПроцесса = Истина;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	ОбновитьТаблицу();
	Если НуженПерезапускПроцесса Тогда
		Ответ = Вопрос("Для перехода к использованию новых версий компонент может требоваться перезапуск приложения. Выполнить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ПараметрыЗапуска = "";
			Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
				ИмяФайлаБазовогоМодуля = ирПортативный.ИспользуемоеИмяФайла;
				Если ЗначениеЗаполнено(ИмяФайлаБазовогоМодуля) Тогда
					ПараметрыЗапуска = ПараметрыЗапуска + " /Execute""" + ИмяФайлаБазовогоМодуля + """";
				КонецЕсли; 
			КонецЕсли; 
			ЗавершитьРаботуСистемы(, Истина, ПараметрыЗапуска);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьТаблицу()
	
	ТаблицаCOMКомпонент.Очистить();
	
	СтрокаКомпоненты = ТаблицаCOMКомпонент.Добавить();
	СтрокаКомпоненты.Идентификатор = "FM20ENU";
	СтрокаКомпоненты.ProgID = "Forms.TextBox.1";
	СтрокаКомпоненты.ЗависящаяФункцияПодсистемы = "Форма списка слов контекстной подсказки и форма индекса синтакс-помощника";
	СтрокаКомпоненты.ВспомогательныйФайл = Истина;
	
	СтрокаКомпоненты = ТаблицаCOMКомпонент.Добавить();
	СтрокаКомпоненты.Идентификатор = "FM20";
	СтрокаКомпоненты.ProgID = "Forms.TextBox.1";
	СтрокаКомпоненты.ЗависящаяФункцияПодсистемы = "Форма списка слов контекстной подсказки и форма индекса синтакс-помощника";
	
	СтрокаКомпоненты = ТаблицаCOMКомпонент.Добавить();
	СтрокаКомпоненты.Идентификатор = "TLBINF32";
	СтрокаКомпоненты.ProgID = "TLI.TLIApplication";
	СтрокаКомпоненты.ЗависящаяФункцияПодсистемы = "Вычисление контекста COM объектов";
	
	СтрокаКомпоненты = ТаблицаCOMКомпонент.Добавить();
	СтрокаКомпоненты.Идентификатор = "GoldParser";
	//СтрокаКомпоненты.ProgID = "GOLDParserEngine.GOLDParser";
	СтрокаКомпоненты.ProgID = "GoldParserForNet.Parser";
	СтрокаКомпоненты.ЗависящаяФункцияПодсистемы = "Режим дерева запроса в консоли запросов и шаблоны текста";
	СтрокаКомпоненты.Версия64 = Истина;
	
	СтрокаКомпоненты = ТаблицаCOMКомпонент.Добавить();
	СтрокаКомпоненты.Идентификатор = "Zlib1";
	СтрокаКомпоненты.ProgID = "GameWithFire.ADOUtils";
	СтрокаКомпоненты.ЗависящаяФункцияПодсистемы = "Преобразование ADODB.RecordSet в результата запроса и быстрая выгрузка ADODB.RecordSet в таблицу значений";
	СтрокаКомпоненты.ИмяТипаВК = "ADOUtils";
	СтрокаКомпоненты.ВспомогательныйФайл = Истина;
	
	СтрокаКомпоненты = ТаблицаCOMКомпонент.Добавить();
	СтрокаКомпоненты.Идентификатор = "GameWithFire";
	СтрокаКомпоненты.ProgID = "GameWithFire.ADOUtils";
	СтрокаКомпоненты.ЗависящаяФункцияПодсистемы = "Преобразование ADODB.RecordSet в результата запроса и быстрая выгрузка ADODB.RecordSet в таблицу значений";
	СтрокаКомпоненты.ИмяТипаВК = "ADOUtils";
	
	СтрокаКомпоненты = ТаблицаCOMКомпонент.Добавить();
	СтрокаКомпоненты.Идентификатор = "StrMatchExtension";
	СтрокаКомпоненты.ProgID = "StrMatchExtension";
	СтрокаКомпоненты.ЗависящаяФункцияПодсистемы = "Нечеткое сравнение строк в поиске дублей и замене ссылок";
	СтрокаКомпоненты.ИмяТипаВК = "StrMatchExtension";
	
	СтрокаКомпоненты = ТаблицаCOMКомпонент.Добавить();
	СтрокаКомпоненты.Идентификатор = "DynamicWrapperX";
	СтрокаКомпоненты.ProgID = "DynamicWrapperX";
	СтрокаКомпоненты.ЗависящаяФункцияПодсистемы = "Некоторые функции общего назначения, отсутствующие в платформе и вызываемые через WinAPI";
	СтрокаКомпоненты.Версия64 = Истина;

	Платформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
	    Платформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Для Каждого Строка Из ТаблицаCOMКомпонент Цикл
		Макет = Платформа.ПолучитьДвоичныеДанныеКомпоненты(Строка.Идентификатор);
		МетаМакет = Платформа.Метаданные().Макеты.Найти(Строка.Идентификатор);
		Строка.Описание = МетаМакет.Комментарий;
		Строка.ИмяФайла = Строка.Идентификатор + ".dll";
		Если ЗначениеЗаполнено(Строка.ProgID) Тогда
			Пустышка = Платформа.ПолучитьПроверитьCOMОбъект(Строка.ProgID, Строка.ИмяТипаВК);
			Строка.Установлена = (Пустышка <> Неопределено);
		КонецЕсли; 
		Файл = Новый Файл(КаталогУстановки + "\" + Строка.ИмяФайла);
		Строка.ФайлОбнаружен = Ложь
			Или ТипЗнч(Платформа.ПолучитьМакет(Строка.Идентификатор)) = Тип("ДвоичныеДанные")
			Или Файл.Существует()
			;
		Строка.Установить = Истина
			И Не Строка.Установлена 
			//И Строка.ФайлОбнаружен
			;
		Пустышка = Неопределено;
	КонецЦикла;

КонецПроцедуры

Процедура ПутьУстановкиНачалоВыбора(Элемент, СтандартнаяОбработка)

	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ВыборФайла.Каталог = Элемент.Значение;
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли; 
	Элемент.Значение = ВыборФайла.Каталог;
	КаталогУстановкиПриИзменении(Элемент);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	КаталогУстановки = КаталогПрограммы();
	Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(КаталогУстановки, "\");
	Для Счетчик = 1 По 3 Цикл
		Фрагменты.Удалить(Фрагменты.ВГраница());
	КонецЦикла;
	Фрагменты.Добавить("Common");
	КаталогУстановки = ирОбщий.ПолучитьСтрокуСРазделителемИзМассиваЛкс(Фрагменты, "\");
	ОбновитьТаблицу();
	
КонецПроцедуры

Процедура ПутьУстановкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура ТаблицаCOMКомпонентПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если Не ДанныеСтроки.Установлена Тогда
		ОформлениеСтроки.ЦветФона = WebЦвета.СветлоРозовый;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КаталогУстановкиПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, "АдминистративнаяРегистрацияCOM");
	ОбновитьТаблицу();
	
КонецПроцедуры

Процедура КаталогУстановкиНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, "АдминистративнаяРегистрацияCOM");
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанель1УстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхСтрокЛкс(ЭлементыФормы.ТаблицаCOMКомпонент, "Установить", Истина);

КонецПроцедуры

Процедура КоманднаяПанель1СнятьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхСтрокЛкс(ЭлементыФормы.ТаблицаCOMКомпонент, "Установить", Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗапуститьОтАдминистратора(Кнопка)
	
	ирОбщий.ЗапуститьСеансПодПользователемЛкс(ИмяПользователя(),,, "ОбычноеПриложение",,,,,,,, Истина);
	
КонецПроцедуры

//ирПортативный #Если Клиент Тогда
//ирПортативный Контейнер = Новый Структура();
//ирПортативный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 	ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный КонецЕсли; 
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирПортативный #КонецЕсли

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.АдминистративнаяРегистрацияCOM");
