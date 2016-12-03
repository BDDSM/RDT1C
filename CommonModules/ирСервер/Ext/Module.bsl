﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

// Поместить строку соединения во временное хранилище
Функция ПоместитьСтрокуСоединенияВХранилищеЛкс(Адрес) Экспорт
	
	ПоместитьВоВременноеХранилище(СтрокаСоединенияИнформационнойБазы(), Адрес);
	
КонецФункции

// Получить строку соединения сервера
Функция ПолучитьСтрокуСоединенияСервераЛкс() Экспорт
	
	Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		Результат = СтрокаСоединенияИнформационнойБазы();
	Иначе
		Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
			Результат = СтрокаСоединенияИнформационнойБазы();
		Иначе
			// Антибаг https://partners.v8.1c.ru/forum/t/1361906/m/1361906
			//Если МонопольныйРежим() Тогда
			//	ВызватьИсключение "Невозможно определить строку соединения сервера в монопольном режиме";
			//КонецЕсли; 
			АдресХранилища = ПоместитьВоВременноеХранилище("");
			Параметры = Новый Массив();
			Параметры.Добавить(АдресХранилища);
			ФоновоеЗадание = ФоновыеЗадания.Выполнить("ирСервер.ПоместитьСтрокуСоединенияВХранилищеЛкс", Параметры,, "Получение строки соединения сервера (ИР)");
			ФоновоеЗадание.ОжидатьЗавершения();
			Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
		КонецЕсли; 
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

/////////////////////////////////////////////
// БСП. Отладка внешних обработок

Процедура ПриПодключенииВнешнейОбработки(Ссылка, СтандартнаяОбработка, Результат) Экспорт
	
	#Если _ Тогда
	    Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка();
	#КонецЕсли
	СтандартнаяОбработка = Истина;
	ОтладкаВключена = ХранилищеСистемныхНастроек.Загрузить("ирОтладкаВнешнихОбработок", "СозданиеВнешнихОбработокЧерезФайл");
	Если ОтладкаВключена = Истина Тогда
		ПутьКФайлу = ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(Ссылка);
	Иначе
		Результат = "";
		Возврат;
	КонецЕсли;
	Если Ложь
		Или Ссылка = Вычислить("Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка()") 
		Или ТипЗнч(Ссылка) <> Вычислить("Тип(""СправочникСсылка.ДополнительныеОтчетыИОбработки"")") 
	Тогда
		Результат = Неопределено;
		Возврат;
	КонецЕсли;
	Если Ложь
		Или Ссылка.Вид = Вычислить("Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет") 
		Или Ссылка.Вид = Вычислить("Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет") 
	Тогда
		Менеджер = ВнешниеОтчеты;
	Иначе
		Менеджер = ВнешниеОбработки;
	КонецЕсли;
	ФайлВнешнейОбработки = Новый Файл(ПутьКФайлу);
	Если Не ФайлВнешнейОбработки.Существует() Тогда
		Ссылка.ХранилищеОбработки.Получить().Записать(ФайлВнешнейОбработки.ПолноеИмя);
	КонецЕсли; 
	ВнешнийОбъект = Менеджер.Создать(ПутьКФайлу, Ложь);
	ИмяОбработки = ВнешнийОбъект.Метаданные().Имя;
	Результат = ИмяОбработки;
	СтандартнаяОбработка = Ложь;
	Возврат;

КонецПроцедуры

Функция ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(Ссылка, КаталогФайловогоКэша = "") Экспорт 
	
	#Если _ Тогда
	    Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка();
	#КонецЕсли
	Если Не ЗначениеЗаполнено(КаталогФайловогоКэша) Тогда
		Обработчик = НайтиПерехватВнешнихОбработокБСПЛкс();
		Если Обработчик = Неопределено Тогда
			ВызватьИсключение "Перехват внеших обработок не включен";
		КонецЕсли; 
		КаталогФайловогоКэша = Обработчик.КаталогФайловогоКэша;
	КонецЕсли; 
	ИмяФайла = Ссылка.ИмяФайла;
	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
		ИмяФайла = "" + Ссылка.УникальныйИдентификатор() + ".epf";
	КонецЕсли; 
	ПутьКФайлу = КаталогФайловогоКэша + "\" + ИмяФайла;
	Возврат ПутьКФайлу;

КонецФункции

Процедура ВключитьПерехватВнешнихОбработокБСПЛкс(Знач КаталогФайловогоКэша) Экспорт
	
	Обработчики = ПолучитьОбработчикиПриПодключенииВнешнейОбработки();
	СтруктураОбработчика = Новый Структура("Модуль, Версия, Подсистема, КаталогФайловогоКэша", "ирСервер", "", "tormozit", КаталогФайловогоКэша);
	Обработчики.Добавить(СтруктураОбработчика);
	УстановитьОбработчикиПриПодключенииВнешнейОбработки(Обработчики);

КонецПроцедуры

Функция ПолучитьОбработчикиПриПодключенииВнешнейОбработки()
	
	ИмяОбработчика = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки\ПриПодключенииВнешнейОбработки";
	КонстантаПараметрыСлужебныхСобытий = Вычислить("Константы.ПараметрыСлужебныхСобытий");
	СтруктруаПараметрыСлужебныхСобытий = КонстантаПараметрыСлужебныхСобытий.Получить().Получить();
	ОбработчикиНаСервере = СтруктруаПараметрыСлужебныхСобытий.ОбработчикиСобытий.НаСервере;
	ОбработчикиСлужебныхСобытий = ОбработчикиНаСервере.ОбработчикиСлужебныхСобытий;
	Обработчики = ОбработчикиСлужебныхСобытий[ИмяОбработчика];
	Обработчики = Новый Массив(Обработчики);
	Возврат Обработчики;

КонецФункции

Процедура УстановитьОбработчикиПриПодключенииВнешнейОбработки(Обработчики)
	
	ИмяОбработчика = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки\ПриПодключенииВнешнейОбработки";
	КонстантаПараметрыСлужебныхСобытий = Вычислить("Константы.ПараметрыСлужебныхСобытий");
	СтруктруаПараметрыСлужебныхСобытий = КонстантаПараметрыСлужебныхСобытий.Получить().Получить();
	ОбработчикиНаСервере = СтруктруаПараметрыСлужебныхСобытий.ОбработчикиСобытий.НаСервере;
	ОбработчикиСлужебныхСобытий = Вычислить("Новый Соответствие(ОбработчикиНаСервере.ОбработчикиСлужебныхСобытий)");
	ОбработчикиСлужебныхСобытий[ИмяОбработчика] = Новый ФиксированныйМассив(Обработчики);
	ОбработчикиНаСервере.ОбработчикиСлужебныхСобытий = Новый ФиксированноеСоответствие(ОбработчикиСлужебныхСобытий);
	КонстантаПараметрыСлужебныхСобытий.Установить(Новый ХранилищеЗначения(СтруктруаПараметрыСлужебныхСобытий));
	ОбновитьПовторноИспользуемыеЗначения();

КонецПроцедуры

Функция НайтиПерехватВнешнихОбработокБСПЛкс(Выключить = Ложь) Экспорт
	
	Обработчики = ПолучитьОбработчикиПриПодключенииВнешнейОбработки();
	ОбновитьЗначениеКонстанты = Ложь;
	Для СчетчикОбработчики = - Обработчики.Количество() + 1 По 0 Цикл
		Индекс = -СчетчикОбработчики;
		Обработчик = Обработчики[Индекс];
		Если Обработчик.Модуль = "ирСервер" Тогда
			Если Не Выключить Тогда
				Возврат Обработчик;
			КонецЕсли; 
			Обработчики.Удалить(Индекс);
			ОбновитьЗначениеКонстанты = Истина;
		КонецЕсли;
	КонецЦикла;
	Если ОбновитьЗначениеКонстанты Тогда
		УстановитьОбработчикиПриПодключенииВнешнейОбработки(Обработчики);
	КонецЕсли;
	Возврат Неопределено;

КонецФункции


/////////////////////////////////////////////
// Редиректы

Функция ПолучитьКаталогНастроекПриложения1СЛкс(ИспользоватьОбщийКаталогНастроек = Истина, СоздатьЕслиОтсутствует = Ложь) Экспорт
	
	Результат = ирОбщий.ПолучитьКаталогНастроекПриложения1СЛкс(ИспользоватьОбщийКаталогНастроек, СоздатьЕслиОтсутствует);
	Возврат Результат;
	
КонецФункции

Функция ПолучитьИмяФайлаАктивнойНастройкиТехноЖурналаЛкс() Экспорт

	Результат = ирОбщий.ПолучитьИмяФайлаАктивнойНастройкиТехноЖурналаЛкс();
	Возврат Результат;

КонецФункции

Функция ЛиКаталогТехножурналаНедоступенЛкс(КаталогЖурнала) Экспорт

	Результат = ирОбщий.ЛиКаталогТехножурналаНедоступенЛкс(КаталогЖурнала);
	Возврат Результат;

КонецФункции

Функция ЗаписатьТекстВФайлЛкс(ПолноеИмяФайла, Текст, Кодировка = Неопределено) Экспорт
	
	Результат = ирОбщий.ЗаписатьТекстВФайлЛкс(ПолноеИмяФайла, Текст, Кодировка);
	Возврат Результат;
	
КонецФункции

Функция ПрочитатьТекстИзФайлаЛкс(ПолноеИмяФайла, Кодировка = Неопределено) Экспорт
	
	Результат = ирОбщий.ПрочитатьТекстИзФайлаЛкс(ПолноеИмяФайла, Кодировка);
	Возврат Результат;
	
КонецФункции

Функция НайтиИменаФайловЛкс(Путь, Маска = Неопределено, ИскатьВПодкаталогах = Истина) Экспорт
	
	Результат = ирОбщий.НайтиИменаФайловЛкс(Путь, Маска, ИскатьВПодкаталогах);
	Возврат Результат;
	
КонецФункции

Функция ВычислитьРазмерКаталогаЛкс(Каталог, ВключаяПодкаталоги = Истина) Экспорт
	
	Результат = ирОбщий.ВычислитьРазмерКаталогаЛкс(Каталог, ВключаяПодкаталоги);
	Возврат Результат;

КонецФункции

Функция ПолучитьТекущуюДатуЛкс() Экспорт
	
	Результат = ирОбщий.ПолучитьТекущуюДатуЛкс();
	Возврат Результат;
	
КонецФункции

Процедура ОчиститьКаталогТехножурналаЛкс(КаталогЖурнала, ВыводитьПредупрежденияИСообщения = Истина) Экспорт

	ирОбщий.ОчиститьКаталогТехножурналаЛкс(КаталогЖурнала, , ВыводитьПредупрежденияИСообщения);

КонецПроцедуры // ОчиститьКаталогТехножурналаЛкс()


Процедура ВыполнитьЗапросЛкс(ТекстЗапроса) Экспорт 
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПереместитьФайлЛкс(ИмяИсточника, ИмяПриемника) Экспорт 

	ПереместитьФайл(ИмяИсточника, ИмяПриемника);

КонецПроцедуры // ПереместитьФайл()

Функция ЛиФайлСуществуетЛкс(ПолноеИмяФайла, выхДатаИзменения = Неопределено) Экспорт 

	Файл1 = Новый Файл(ПолноеИмяФайла);
	ФайлНайден = Файл1.Существует();
	Если ФайлНайден Тогда
		выхДатаИзменения = Файл1.ПолучитьВремяИзменения() + ирКэш.ПолучитьСмещениеВремениЛкс();
	КонецЕсли; 
	Возврат ФайлНайден;

КонецФункции // ЛиФайлСуществует()
 
// Выполняет текст алгоритма.
//
// Параметры:
//  ТекстДляВыполнения – Строка;
//  _АлгоритмОбъект - СправочникОбъект
//  *СтруктураПараметров - Структура, *Неопределено.
//
Функция ВыполнитьАлгоритм(_ТекстДляВыполнения, _АлгоритмОбъект = Null, _Режим  = Null,
	_П0 = Null, _П1 = Null, _П2 = Null, _П3 = Null, _П4 = Null, _П5 = Null, _П6 = Null, _П7 = Null, _П8 = Null, _П9 = Null) Экспорт 
	
	Перем Результат;
	Если Истина
		И ирКэш.ЛиПортативныйРежимЛкс()
		И ирПортативный.ЛиСерверныйМодульДоступенЛкс(Ложь)
	Тогда
		ПараметрыКоманды = Новый Структура("_ТекстДляВыполнения, _АлгоритмОбъект", _ТекстДляВыполнения, _АлгоритмОбъект);
		ирПортативный.ВыполнитьСерверныйМетодЛкс("ВыполнитьАлгоритм", ПараметрыКоманды);
	Иначе
		Выполнить(_ТекстДляВыполнения);
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции // ПозиционныйМетод()

Процедура ВыполнитьАлгоритмБезРезультата(_ТекстДляВыполнения) Экспорт 
	
	Выполнить(_ТекстДляВыполнения);
	
КонецПроцедуры

Функция ВычислитьВыражение(Выражение) Экспорт
	
	Возврат Вычислить(Выражение);
	
КонецФункции

Процедура ЗаписатьОбъектXMLЛкс(ОбъектXML, ДополнительныеСвойства, РежимЗаписи = Неопределено, РежимПроведения = Неопределено, ОтключатьКонтрольЗаписи = Неопределено,
	БезАвторегистрацииИзменений = Неопределено) Экспорт 
	
	Если Истина
		И ирКэш.ЛиПортативныйРежимЛкс()
		И ирПортативный.ЛиСерверныйМодульДоступенЛкс()
	Тогда
		ПараметрыКоманды = Новый Структура("ОбъектXML, ДополнительныеСвойства, РежимЗаписи, РежимПроведения, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений",
			ОбъектXML, ДополнительныеСвойства, РежимЗаписи, РежимПроведения, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
		ирПортативный.ВыполнитьСерверныйМетодЛкс("ЗаписатьОбъектXMLЛкс", ПараметрыКоманды);
		ДополнительныеСвойства = ПараметрыКоманды.ДополнительныеСвойства;
		ОбъектXML = ПараметрыКоманды.ОбъектXML;
	Иначе
		Объект = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(ОбъектXML);
		ирОбщий.ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, ДополнительныеСвойства);
		ирОбщий.ЗаписатьОбъектЛкс(Объект, Ложь, РежимЗаписи, РежимПроведения, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
		ДополнительныеСвойства = ирОбщий.СериализоватьДополнительныеСвойстваОбъектаЛкс(Объект);
		ОбъектXML = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Объект);
	КонецЕсли; 
	
КонецПроцедуры

Процедура УдалитьОбъектЛкс(ХМЛ, СтруктураДополнительныхСвойств) Экспорт 
	
	Объект = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(ХМЛ);
	Объект.Прочитать();
	ирОбщий.ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, СтруктураДополнительныхСвойств);
	//Объект.Удалить();
	ирОбщий.УдалитьОбъектЛкс(Объект, Ложь);
	
КонецПроцедуры

Процедура УстановитьПометкуУдаленияОбъектаЛкс(ОбъектXML, СтруктураДополнительныхСвойств, ЗначениеПометки = Истина, БезАвторегистрацииИзменений = Неопределено) Экспорт 
	
	Объект = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(ОбъектXML);
	Объект.Прочитать(); // Иначе объект будет модифицирован и возникнет ошибка
	ирОбщий.ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, СтруктураДополнительныхСвойств);
	ирОбщий.УстановитьПометкуУдаленияОбъектаЛкс(Объект,, ЗначениеПометки, БезАвторегистрацииИзменений);
	ДополнительныеСвойства = ирОбщий.СериализоватьДополнительныеСвойстваОбъектаЛкс(Объект);
	ОбъектXML = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Объект);
	
КонецПроцедуры

Функция ПолучитьИмяКомпьютераЛкс() Экспорт
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		Результат = НСтр(СтрокаСоединенияИнформационнойБазы(), "Srvr");
	Иначе
		Результат = ИмяКомпьютера();
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ПолучитьИспользованиеСобытияЖурналаРегистрацииКакСтруктуру(ИмяСобытия) Экспорт
	
	Результат = Новый Структура("Использование, ОписаниеИспользования");
	
	ИспользованиеСобытия = ПолучитьИспользованиеСобытияЖурналаРегистрации(ИмяСобытия);
	Результат.Использование = ИспользованиеСобытия.Использование;
	
	Если ТипЗнч(ИспользованиеСобытия.ОписаниеИспользования) = Тип("Массив") И ИспользованиеСобытия.ОписаниеИспользования.Количество() > 0  Тогда
		
		ОписаниеИспользования = Новый Массив();
		
		Если ТипЗнч(ИспользованиеСобытия.ОписаниеИспользования[0]) = Тип("ОписаниеИспользованияСобытияДоступЖурналаРегистрации") Тогда
			
			СтрокаКлючей = "Объект, ПоляРегистрации, ПоляДоступа";
			
		ИначеЕсли ТипЗнч(ИспользованиеСобытия.ОписаниеИспользования[0]) = Тип("ОписаниеИспользованияСобытияОтказВДоступеЖурналаРегистрации") Тогда
			
			СтрокаКлючей = "Объект, ПоляРегистрации";
			
		Иначе
			
			//ВызватьИсключение "Неизвестный тип " + ТипЗнч(ИспользованиеСобытия.ОписаниеИспользования[0]);
			
		КонецЕсли;
		
		Для Каждого ЭлементОписания Из ИспользованиеСобытия.ОписаниеИспользования Цикл
		
			ЭлементМассива = Новый Структура(СтрокаКлючей);		
			ЗаполнитьЗначенияСвойств(ЭлементМассива, ЭлементОписания); 
			ОписаниеИспользования.Добавить(ЭлементМассива);
			
		КонецЦикла;
		
		Результат.ОписаниеИспользования = ОписаниеИспользования;
		
	Иначе
		
		Результат.ОписаниеИспользования = Неопределено;
		
	КонецЕсли; 	
		
	Возврат Результат;
	
КонецФункции

Процедура УстановитьИспользованиеСобытияЖурналаРегистрацииПоСтруктуре(ИмяСобытия, пИспользованиеСобытия) Экспорт
	
	ИспользованиеСобытия = Новый ИспользованиеСобытияЖурналаРегистрации;
	ИспользованиеСобытия.Использование = пИспользованиеСобытия.Использование;
	
	пОписаниеИспользования = Неопределено;
	пИспользованиеСобытия.Свойство("ОписаниеИспользования", пОписаниеИспользования);
	Если Истина
		 И ТипЗнч(пОписаниеИспользования) = Тип("Массив") 
		 И пОписаниеИспользования.Количество() > 0
		 И (Ложь
		 	Или ИмяСобытия = "_$Access$_.Access"
			Или ИмяСобытия = "_$Access$_.AccessDenied") Тогда
		
		ТипОписанияСтрокой = ?(ИмяСобытия = "_$Access$_.Access", "ОписаниеИспользованияСобытияДоступЖурналаРегистрации","ОписаниеИспользованияСобытияОтказВДоступеЖурналаРегистрации");			
		ОписаниеИспользования = Новый Массив();
		Для Каждого пЭлементОписания Из пОписаниеИспользования Цикл
			
			ЭлементОписания = Новый(ТипОписанияСтрокой);
			ЗаполнитьЗначенияСвойств(ЭлементОписания, пЭлементОписания); 
			ОписаниеИспользования.Добавить(ЭлементОписания);
			
		КонецЦикла; 			
		
		ИспользованиеСобытия.ОписаниеИспользования = ОписаниеИспользования;
				
	КонецЕсли; 
	
	УстановитьИспользованиеСобытияЖурналаРегистрации(ИмяСобытия, ИспользованиеСобытия)
	
КонецПроцедуры

Функция ПолучитьПараметрыПроцессаАгентаСервера(выхИдентификаторПроцесса = Неопределено, выхКомманднаяСтрока = Неопределено, выхИмяСлужбы = Неопределено) Экспорт 
	
	выхИмяСлужбы = Неопределено;
	РабочийПроцесс = ирОбщий.ПолучитьПроцессОСЛкс(ирКэш.Получить().ПолучитьИдентификаторПроцессаОС());
	Если ТипЗнч(РабочийПроцесс) = Тип("Строка") Тогда
		Сообщить("Ошибка обращения к процессу ОС рабочего процесса: " + РабочийПроцесс);
		Возврат Неопределено;
	КонецЕсли; 
	КомпьютерКластера = ирОбщий.ИмяКомпьютераКластераЛкс();
	Если Не ЗначениеЗаполнено(КомпьютерКластера) Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Попытка
		WMIЛокатор = ирКэш.ПолучитьCOMОбъектWMIЛкс(КомпьютерКластера);
	Исключение
		Сообщить("У пользователя рабочего процесса нет прав на подключение к WMI кластера: " + ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки; 
	выхИдентификаторПроцесса = РабочийПроцесс.ParentProcessId;
	ПроцессАгента = ирОбщий.ПолучитьПроцессОСЛкс(выхИдентификаторПроцесса,, КомпьютерКластера);
	Если ТипЗнч(ПроцессАгента) = Тип("COMОбъект") Тогда
		выхКомманднаяСтрока = ПроцессАгента.CommandLine;
		ТекстЗапросаWQL = "Select * from Win32_Service Where ProcessId = " + XMLСтрока(выхИдентификаторПроцесса);
		ВыборкаСистемныхСлужб = WMIЛокатор.ExecQuery(ТекстЗапросаWQL);
		Для Каждого лСистемнаяСлужба Из ВыборкаСистемныхСлужб Цикл
			СистемнаяСлужба = лСистемнаяСлужба;
			Прервать;
		КонецЦикла;
	КонецЕсли; 
	Если СистемнаяСлужба = Неопределено Тогда
		//Сообщить("Не удалось определить имя системной службы агента сервера приложений", СтатусСообщения.Внимание);
		Возврат Неопределено;
	КонецЕсли;
	выхИмяСлужбы = СистемнаяСлужба.Name;
	Возврат выхИдентификаторПроцесса;
	
КонецФункции


