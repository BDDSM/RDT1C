﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мМенеджеры Экспорт;
Перем мИмяКолонкиПометки Экспорт;
Перем мИмяКолонкиРезультатаОбработки Экспорт;
Перем мИмяКолонкиПолногоИмениТаблицы Экспорт;
Перем мЗапрос Экспорт;
Перем мПлатформа Экспорт;
Перем мРезультатЗапроса Экспорт;
Перем мСхемаКолонок Экспорт;
Перем мВопросНаОбновлениеСтрокДляОбработкиЗадавался Экспорт;
Перем мСоставПланаОбмена;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ

// Разбирает строку выделяя из нее префикс и числовую часть
//
// Параметры:
//  Стр            - Строка. Разбираемая строка
//  ЧисловаяЧасть  - Число. Переменная в которую возвратится числовая часть строки
//  Режим          - Строка. Если "Число", то возвратит числовую часть иначе - префикс
//
// Возвращаемое значение:
//  Префикс строки
//              
Функция вПолучитьПрефиксЧислоНомера(Знач Стр, ЧисловаяЧасть="", Режим="") Экспорт
    
	Стр		=	СокрЛП(Стр);
	Префикс	=	Стр;
	Длина	=	СтрДлина(Стр);
	
	Для Сч = 1 По Длина Цикл
		Попытка
			ЧисловаяЧасть = Число(Стр);
		Исключение
		    Стр = Прав(Стр, Длина - Сч);
			Продолжить;
		КонецПопытки; 
		
	    Если (ЧисловаяЧасть > 0) И (СтрДлина(Формат(ЧисловаяЧасть, "ЧГ=0")) = Длина - Сч + 1) Тогда 
			Префикс	=	Лев(Префикс, Сч - 1);
			
			Пока Прав(Префикс, 1) = "0" Цикл
			    Префикс = Лев(Префикс, СтрДлина(Префикс)-1);
			КонецЦикла;
			
			Прервать;
	    Иначе
			Стр = Прав(Стр, Длина - Сч);
		КонецЕсли;
		
		Если ЧисловаяЧасть < 0 Тогда	ЧисловаяЧасть = - ЧисловаяЧасть		КонецЕсли;
			
	КонецЦикла;

	Если Режим = "Число" Тогда
	    Возврат(ЧисловаяЧасть);
	Иначе
		Возврат(Префикс);
	КонецЕсли;

КонецФункции // вПолучитьПрефиксЧислоНомера()

// Приводит номер (код) к требуемой длине. При этом выделяется префикс
// и числовая часть номера, остальное пространство между префиксом и
// номером заполняется нулями
//
// Параметры:
//  Стр            - Преобразовываемая строка
//  Длина          - Требуемая длина строки
//
// Возвращаемое значение:
//  Строка - код или номер, приведенная к требуемой длине
// 
Функция вПривестиНомерКДлине(Знач Стр, Длина) Экспорт
                            
	Стр			    =	СокрЛП(Стр);
		
	ЧисловаяЧасть	=	"";
	Результат		=	вПолучитьПрефиксЧислоНомера(Стр, ЧисловаяЧасть);
	Пока Длина - СтрДлина(Результат) - СтрДлина(Формат(ЧисловаяЧасть, "ЧГ=0")) > 0 Цикл
		Результат	=	Результат + "0";
	КонецЦикла;
	Результат	=	Результат + Формат(ЧисловаяЧасть, "ЧГ=0");
	
	Возврат(Результат);
	
КонецФункции // вПривестиНомерКДлине()

// Добавляет к префиксу номера или кода подстроку
//
// Параметры:
//  Стр            - Строка. Номер или код
//  Добавок        - Добаляемая к префиксу подстрока
//  Длина          - Требуемая результрирубщая длина строки
//  Режим          - "Слева" - подстрока добавляется слева к префиксу, иначе - справа
//
// Возвращаемое значение:
//  Строка - номер или код, к префиксу которого добавлена указанная подстрока
//                                                                                                     
Функция вДобавитьКПрефиксу(Знач Стр, Добавок="", Длина="", Режим="Слева") Экспорт

	Стр = СокрЛП(Стр);
	
	Если ПустаяСтрока(Длина) Тогда
		Длина = СтрДлина(Стр);
	КонецЕсли;
	
	ЧисловаяЧасть	=	"";
	Префикс			=	вПолучитьПрефиксЧислоНомера(Стр, ЧисловаяЧасть);
	Если Режим="Слева" Тогда
		Результат	=	СокрЛП(Добавок) + Префикс;
	Иначе
		Результат	=	Префикс + СокрЛП(Добавок);
	КонецЕсли;

	Пока Длина - СтрДлина(Результат) - СтрДлина(Формат(ЧисловаяЧасть, "ЧГ=0")) > 0 Цикл
	    Результат	=	Результат + "0";
	КонецЦикла;
	Результат	=	Результат + Формат(ЧисловаяЧасть, "ЧГ=0");
	
	Возврат(Результат);
	
КонецФункции // вДобавитьКПрефиксу()

// Дополняет строку указанным символом до указанной длины
//
// Параметры: 
//  Стр            - Дополняемая строка
//  Длина          - Требуемая длина результирующей строки
//  Чем            - Символ, которым дополняется строка
//
// Возвращаемое значение:
//  Строка дополненная указанным символом до указанной длины
//
Функция вДополнитьСтрокуСимволами(Стр="", Длина, Чем=" ") Экспорт
	Результат = СокрЛП(Стр);
	Пока Длина - СтрДлина(Результат) > 0 Цикл
		Результат	=	Результат + Чем;
	КонецЦикла;
	Возврат(Результат);
КонецФункции // вДополнитьСтрокуСимволами() 

#Если Клиент Тогда
	
// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
Функция вВыполнитьГрупповуюОбработку(ФормаОбработки) Экспорт

	ПараметрыОбработки = Новый Структура;
	ФормаОбработки.ПередОбработкойВсех(ПараметрыОбработки);
	НайденныеОбъекты.ЗаполнитьЗначения("", мИмяКолонкиРезультатаОбработки);
	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	мСоставПланаОбмена = Неопределено;
	Если ЗначениеЗаполнено(УзелОтбораОбъектов) Тогда
		мСоставПланаОбмена = УзелОтбораОбъектов.Метаданные().Состав;
	КонецЕсли; 
	ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска));
	СтруктураКлючаОбъекта = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска), Ложь);
	СтруктураКлючаПолная = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска), Истина);
	Если МноготабличнаяВыборка Тогда
		СтруктураКлючаОбъекта.Вставить(мИмяКолонкиПолногоИмениТаблицы);
		СтруктураКлючаПолная.Вставить(мИмяКолонкиПолногоИмениТаблицы);
	КонецЕсли;
	СтрокаКлюча = "";
	Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
		Если СтрокаКлюча <> "" Тогда
			СтрокаКлюча  = СтрокаКлюча + ", ";
		КонецЕсли; 
		СтрокаКлюча = СтрокаКлюча + КлючИЗначение.Ключ;
	КонецЦикла;
	Если ДинамическаяВыборка Тогда
		Если СтруктураКлючаОбъекта.Количество() > 1 Тогда
			Сообщить("Динамическая выборка по сложному ключу не поддерживается. Используйте статическую выборку.", СтатусСообщения.Внимание);
			Возврат 0;
		КонецЕсли; 
		Если СтруктураКлючаПолная.Количество() = СтруктураКлючаОбъекта.Количество() Тогда
			ВыборкаКлючей = мРезультатЗапроса.Выбрать();
			КоличествоОбъектов = ВыборкаКлючей.Количество();
			КоличествоСтрок = КоличествоОбъектов;
			Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов);
			Пока ВыборкаКлючей.Следующий() Цикл
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
				СтрокиДляОбработки = НайденныеОбъекты.СкопироватьКолонки();
				ЗаполнитьЗначенияСвойств(СтрокиДляОбработки.Добавить(), ВыборкаКлючей);
				РезультатОбработки = ОбработатьЭлементыОбъекта(ФормаОбработки, ТипТаблицы, СтруктураКлючаОбъекта, СтруктураКлючаПолная, ВыборкаКлючей, СтрокиДляОбработки, ПараметрыОбработки);
			КонецЦикла;
		Иначе
			ЗапросКлючей = Новый Запрос();
			Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(мЗапрос.Текст, "//Секция_Упорядочить");
			ИсключаемоеПоле = Неопределено;
			Если СтруктураКлючаПолная <> СтруктураКлючаОбъекта Тогда
				ИсключаемоеПоле = "НомерСтроки";
			КонецЕсли; 
			СтрокаПорядка = ирОбщий.ПолучитьСтрокуПорядкаКомпоновкиЛкс(Компоновщик.Настройки.Порядок, ИсключаемоеПоле);
			СтрокаПолейПорядка = "";
			Для Каждого Колонка Из мРезультатЗапроса.Колонки Цикл
				Если Ложь
					Или СтруктураКлючаОбъекта.Свойство(Колонка.Имя) 
					Или ирОбщий.СтрокиРавныЛкс(ИсключаемоеПоле, Колонка.Имя)
				Тогда
					Продолжить;
				КонецЕсли; 
				СтрокаПолейПорядка = ", " + Колонка.Имя;
			КонецЦикла;
			Если ЗначениеЗаполнено(СтрокаПорядка) Тогда
				СтрокаПорядка = " УПОРЯДОЧИТЬ ПО " + СтрокаПорядка;
			КонецЕсли; 
			Если Ложь
				Или Автоупорядочивание 
				Или ЗначениеЗаполнено(СтрокаПорядка)
			Тогда
				СтрокаПорядка = СтрокаПорядка + "
				|АВТОУПОРЯДОЧИВАНИЕ";
			КонецЕсли; 
			ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ " + СтрокаКлюча + СтрокаПолейПорядка + "
			| ИЗ (" + Фрагменты[0] + ") КАК Т " + СтрокаПорядка; // Доделать имя таблицы (Т.) у полей
			ЗапросКлючей.Текст = ТекстЗапроса;
			ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(мЗапрос.Параметры, ЗапросКлючей.Параметры);
			РезультатЗапроса = ЗапросКлючей.Выполнить();
			#Если _ Тогда
				_Запрос = Новый Запрос;
			    ВыборкаЗапроса = _Запрос.Выполнить().Выбрать();
			#КонецЕсли
			ВыборкаКлючей = РезультатЗапроса.Выбрать();
			//Построитель = Новый ПостроительЗапроса;
			//Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(мРезультатЗапроса);
			//Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
			//	Построитель.ИсточникДанных.Колонки.Ссылка.Измерение = Истина;
			//КонецЦикла; 
			//Построитель.ЗаполнитьНастройки();
			//Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
			//	Построитель.Измерения.Добавить(КлючИЗначение.Ключ);
			//КонецЦикла; 
			//ВыборкаКлючей = Построитель.Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			ПостроительЗапросаДеталей = Новый ПостроительЗапроса();
			ПостроительЗапросаДеталей.Текст = мЗапрос.Текст;
			ПостроительЗапросаДеталей.ЗаполнитьНастройки();
			Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
				ЭлементОтбора = ПостроительЗапросаДеталей.Отбор.Добавить(КлючИЗначение.Ключ);
				ЭлементОтбора.Использование = Истина;
			КонецЦикла;
			КоличествоОбъектов = ВыборкаКлючей.Количество();
			КоличествоСтрок = 0;
			Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов, "Обработка объектов");
			ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(мЗапрос.Параметры, ПостроительЗапросаДеталей.Параметры);
			Пока ВыборкаКлючей.Следующий() Цикл
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
				Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
					ПостроительЗапросаДеталей.Отбор[КлючИЗначение.Ключ].Значение = ВыборкаКлючей[КлючИЗначение.Ключ];
				КонецЦикла;
				ТаблицаРезультатаДеталей = ПостроительЗапросаДеталей.Результат.Выгрузить();
				СтрокиДляОбработки = НайденныеОбъекты.СкопироватьКолонки();
				ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ТаблицаРезультатаДеталей, СтрокиДляОбработки);
				РезультатОбработки = ОбработатьЭлементыОбъекта(ФормаОбработки, ТипТаблицы, СтруктураКлючаОбъекта, СтруктураКлючаПолная, ВыборкаКлючей, СтрокиДляОбработки, ПараметрыОбработки);
				КоличествоСтрок = КоличествоСтрок + СтрокиДляОбработки.Количество();
			КонецЦикла;
		КонецЕсли; 
	Иначе
		// Порядок обработки строк таблицы БД сохраняется только в случае, если на каждый объект БД приходится только одна строка
		КлючиДляОбработки = НайденныеОбъекты.Скопировать(Новый Структура(мИмяКолонкиПометки, Истина));
		КоличествоСтрок = КлючиДляОбработки.Количество();
		КлючиДляОбработки.Колонки.Добавить("_ПорядокСтроки");
		Для Индекс = 0 По КлючиДляОбработки.Количество() - 1 Цикл
			СтрокаТаблицы  = КлючиДляОбработки[Индекс];
			СтрокаТаблицы._ПорядокСтроки = Индекс;
		КонецЦикла;
		КлючиДляОбработки.Свернуть(СтрокаКлюча, "_ПорядокСтроки");
		КлючиДляОбработки.Сортировать("_ПорядокСтроки");
		КоличествоОбъектов = КлючиДляОбработки.Количество();
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов, "Обработка объектов");
		СтруктураКлючаОбъекта.Вставить(мИмяКолонкиПометки, Истина);
		
		СтрокаИндекса = СтрокаКлюча;
		СтрокаИндекса = СтрокаИндекса + ", " + мИмяКолонкиПометки;
		Если МноготабличнаяВыборка Тогда
			СтрокаИндекса = СтрокаИндекса + ", "+ мИмяКолонкиПолногоИмениТаблицы;
		КонецЕсли;
		Индекс = "";
		Для Каждого Индекс Из НайденныеОбъекты.Индексы Цикл
			Если "" + Индекс = СтрокаИндекса Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		Если Индекс <> СтрокаИндекса Тогда
			НайденныеОбъекты.Индексы.Добавить(СтрокаИндекса);
		КонецЕсли; 
		
		Для Индекс = 0 По КоличествоОбъектов - 1 Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			СтрокаКлюча = КлючиДляОбработки[Индекс];
			ЗаполнитьЗначенияСвойств(СтруктураКлючаОбъекта, СтрокаКлюча); 
			СтрокиДляОбработки = НайденныеОбъекты.Скопировать(СтруктураКлючаОбъекта);
			РезультатОбработки = ОбработатьЭлементыОбъекта(ФормаОбработки, ТипТаблицы, СтруктураКлючаОбъекта, СтруктураКлючаПолная, СтрокаКлюча, СтрокиДляОбработки, ПараметрыОбработки);
			Для Каждого СтрокаДанных Из НайденныеОбъекты.НайтиСтроки(СтруктураКлючаОбъекта) Цикл
				СтрокаДанных[мИмяКолонкиРезультатаОбработки] = РезультатОбработки;
			КонецЦикла; 
		КонецЦикла;
	КонецЕсли; 
	Если Истина
		И КоличествоСтрок > 0 
		И КоличествоСтрок <> КоличествоОбъектов 
	Тогда
		Сообщить("Обработано " + КоличествоСтрок + " строк");
	КонецЕсли; 
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
	Если ВыполнятьВТранзакции Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	ФормаОбработки.ПослеОбработкиВсех(ПараметрыОбработки);
	мВопросНаОбновлениеСтрокДляОбработкиЗадавался = Ложь;
	Возврат Индекс;

КонецФункции // вВыполнитьОбработку()

// <Описание процедуры>
//
// Параметры:
//  СтрокиДляОбработки – ТаблицаЗначений – ;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
// 
Функция ОбработатьЭлементыОбъекта(ФормаОбработки, ТипТаблицы, СтруктураКлючаОбъекта, СтруктураКлючаПолная, СтрокаКлюча, СтрокиДляОбработки, ПараметрыОбработки)

	Если РежимОбходаДанных = "Строки" Тогда
		Если СтрокиДляОбработки.Колонки.Найти("НомерСтроки") <> Неопределено Тогда
			СтрокиДляОбработки.Сортировать("НомерСтроки Убыв");
		КонецЕсли; 
	КонецЕсли; 
	Если МноготабличнаяВыборка Тогда
		ПолноеИмяТаблицыСтроки = СтруктураКлючаОбъекта[мИмяКолонкиПолногоИмениТаблицы];
	Иначе
		ПолноеИмяТаблицыСтроки = ОбластьПоиска;
	КонецЕсли; 
	//ЭтоРегистрБухгалтерии = ирОбщий.ЛиПолноеИмяРегистраБухгалтерииЛкс(ПолноеИмяТаблицыСтроки);
	МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ПолноеИмяТаблицыСтроки);
	ОбъектМДЗаписи = мПлатформа.ПолучитьОбъектМДПоПолномуИмени(МассивФрагментов[0] + "." + МассивФрагментов[1]);
	ПроводитьПроведенные = Истина
		И ПроводитьПроведенныеДокументыПриЗаписи
		И ирОбщий.ПолучитьПервыйФрагментЛкс(ПолноеИмяТаблицыСтроки) = "Документ"
		И ОбъектМДЗаписи.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить;
	КоллекцияСтрок = Неопределено;
	ЗагрузитьСтрокиПослеОбработки = Ложь;
	МассивОбъектов = Новый Массив();
	Если ирОбщий.ЛиКорневойТипОбъектаБДЛкс(ТипТаблицы) Тогда
		Если РежимОбходаДанных = "КлючиОбъектов" Тогда
			ОбъектДляЗаписи = СтрокаКлюча.Ссылка
		Иначе
			ОбъектДляЗаписи = СтрокаКлюча.Ссылка.ПолучитьОбъект();
		КонецЕсли; 
		МассивОбъектов.Добавить(ОбъектДляЗаписи);
	ИначеЕсли ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицы) Тогда
		ОбъектДляЗаписи = СтрокаКлюча.Ссылка.ПолучитьОбъект();
		Если РежимОбходаДанных = "Строки" Тогда
			ИмяТЧ = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ПолноеИмяТаблицыСтроки))[2];
			КоллекцияСтрок = ОбъектДляЗаписи[ИмяТЧ];
			Для Каждого СтрокаДляОбработки Из СтрокиДляОбработки Цикл
				Если КоллекцияСтрок.Количество() < СтрокаДляОбработки.НомерСтроки Тогда
					ВызватьИсключение "Строка таблицы с номером " + СтрокаДляОбработки.НомерСтроки + " не найдена в объекте БД";
				КонецЕсли; 
				МассивОбъектов.Добавить(КоллекцияСтрок[СтрокаДляОбработки.НомерСтроки - 1]);
			КонецЦикла;
		Иначе
			МассивОбъектов.Добавить(ОбъектДляЗаписи);
		КонецЕсли; 
	ИначеЕсли Ложь
		Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(ТипТаблицы) 
		Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(ТипТаблицы)
	Тогда
		//ОбъектДляЗаписи = Новый (СтрЗаменить(ПолноеИмяТаблицыСтроки, ".", "НаборЗаписей."));
		//Для Каждого ЭлементОтбора Из ОбъектДляЗаписи.Отбор Цикл
		//	ЭлементОтбора.Использование = Истина;
		//	ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
		//	//ЭлементОтбора.Значение = СтруктураКлючаОбъекта[ЭлементОтбора.Имя];
		//	ЭлементОтбора.Значение = СтрокаКлюча[ЭлементОтбора.Имя];
		//КонецЦикла;
		ОбъектДляЗаписи = ирОбщий.ПолучитьНаборЗаписейПоКлючуЛкс(ПолноеИмяТаблицыСтроки, СтрокаКлюча);
		Если РежимОбходаДанных <> "КлючиОбъектов" Тогда
			ОбъектДляЗаписи.Прочитать();
		КонецЕсли;
		Если РежимОбходаДанных = "Строки" Тогда
			КоллекцияСтрок = ОбъектДляЗаписи.Выгрузить();
			ЗагрузитьСтрокиПослеОбработки = Истина;
			Если СтруктураКлючаПолная.Свойство("НомерСтроки") Тогда
				ИмяКлюча = "НомерСтроки";
				КлючСтроки = Новый Структура(ИмяКлюча);
			ИначеЕсли СтруктураКлючаПолная.Свойство("Период") Тогда
				ИмяКлюча = "Период";
				КлючСтроки = Новый Структура(ИмяКлюча);
			Иначе
				КлючСтроки = Неопределено;
			КонецЕсли; 
			Для Каждого СтрокаДляОбработки Из СтрокиДляОбработки Цикл
				Если КлючСтроки = Неопределено Тогда
					СтрокаОбъекта = КоллекцияСтрок[0];
				Иначе
					ЗаполнитьЗначенияСвойств(КлючСтроки, СтрокаДляОбработки); 
					НайденныеСтроки = КоллекцияСтрок.НайтиСтроки(КлючСтроки);
					Если НайденныеСтроки.Количество() = 0 Тогда
						ВызватьИсключение "Строка таблицы по ключу " + КлючСтроки[ИмяКлюча] + " не найдена в объекте БД";
					КонецЕсли;
					//Если ЭтоРегистрБухгалтерии Тогда
						СтрокаОбъекта = НайденныеСтроки[0];
					//Иначе
					//	ИндексСтрокиНабора = КоллекцияСтрок.Индекс(НайденныеСтроки[0]);
					//	СтрокаОбъекта = ОбъектДляЗаписи[ИндексСтрокиНабора];
					//КонецЕсли; 
				КонецЕсли; 
				МассивОбъектов.Добавить(СтрокаОбъекта);
			КонецЦикла;
		Иначе
			КоллекцияСтрок = Неопределено;
			МассивОбъектов.Добавить(ОбъектДляЗаписи);
		КонецЕсли; 
	КонецЕсли; 
	Если РежимОбходаДанных <> "КлючиОбъектов" Тогда
		Попытка
			ОбменДанными = ОбъектДляЗаписи.ОбменДанными;
		Исключение
			ОбменДанными = Неопределено;
		КонецПопытки; 
		Если ОбменДанными <> Неопределено Тогда
			ОбменДанными.Загрузка = ОтключатьКонтрольЗаписи;
		КонецЕсли;
	КонецЕсли; 
	ТекстСообщенияОбОбработкеОбъекта = "Обработка объекта " + ирОбщий.ПолучитьXMLКлючОбъектаБДЛкс(ОбъектДляЗаписи);
	Если ВыводитьСообщения Тогда
		Сообщить(ТекстСообщенияОбОбработкеОбъекта);
	КонецЕсли; 
	Попытка
		Для Каждого Объект Из МассивОбъектов Цикл
			ФормаОбработки.вОбработатьОбъект(Объект, КоллекцияСтрок, ПараметрыОбработки);
		КонецЦикла;
		Если ЗагрузитьСтрокиПослеОбработки Тогда
			Если КоллекцияСтрок <> Неопределено Тогда
				ОбъектДляЗаписи.Загрузить(КоллекцияСтрок);
			КонецЕсли; 
		КонецЕсли; 
		Если РежимОбходаДанных <> "КлючиОбъектов" Тогда
			Попытка
				Модифицированность = ОбъектДляЗаписи.Модифицированность();
			Исключение
				// Объект мог быть удален
				Модифицированность = Ложь;
			КонецПопытки; 
			Если Модифицированность Тогда
				РежимЗаписи = Неопределено;
				Если Истина
					И ПроводитьПроведенные
					И ОбъектДляЗаписи.Проведен
				Тогда
					РежимЗаписи = РежимЗаписиДокумента.Проведение;
				КонецЕсли;
				ирОбщий.ЗаписатьОбъектЛкс(ОбъектДляЗаписи, ЗаписьНаСервере, РежимЗаписи);
			КонецЕсли;
		КонецЕсли; 
		РезультатОбработки = "Успех";
		Если ВыводитьСообщения Тогда
			Сообщить(Символы.Таб + РезультатОбработки);
		КонецЕсли; 
	Исключение
		РезультатОбработки = ОписаниеОшибки();
		Если Не ВыводитьСообщения Тогда
			Сообщить(ТекстСообщенияОбОбработкеОбъекта);
		КонецЕсли; 
		Сообщить(Символы.Таб + РезультатОбработки, СтатусСообщения.Внимание);
		Если Не ПропускатьОшибки Тогда
			ВызватьИсключение;
		КонецЕсли; 
	КонецПопытки;
	Если Истина
		И РезультатОбработки = "Успех"
		И УдалятьРегистрациюНаУзлеПослеОбработкиОбъекта 
		И ЗначениеЗаполнено(УзелОтбораОбъектов)
	Тогда 
		Если мСоставПланаОбмена.Содержит(ОбъектДляЗаписи.Метаданные()) Тогда
			ирОбщий.ИзменитьРегистрациюДляУзлаЛкс(УзелОтбораОбъектов, ОбъектДляЗаписи, Ложь);
		КонецЕсли; 
	КонецЕсли; 
	Возврат РезультатОбработки;

КонецФункции

Функция ПолучитьОписаниеТиповОбрабатываемогоЭлемента(ИскомыйОбъект) Экспорт
	
	МассивОбъектовМД = Новый Массив();
	Если ИскомыйОбъект <> Неопределено Тогда
		ТипТаблицы = ИскомыйОбъект.ТипТаблицы;
		Если МноготабличнаяВыборка Тогда
			МассивОбъектовМД = ИскомыйОбъект.МетаОбъект;
		Иначе
			МассивОбъектовМД.Добавить(ИскомыйОбъект.МетаОбъект);
		КонецЕсли; 
	КонецЕсли; 
	МассивТипов = Новый Массив();
	Если ирОбщий.ЛиКорневойТипОбъектаБДЛкс(ТипТаблицы) Тогда
		Для Каждого ОбъектМД Из МассивОбъектовМД Цикл
			МассивТипов.Добавить(Тип(СтрЗаменить(ОбъектМД.ПолноеИмя(), ".", "Объект.")));
		КонецЦикла;
	ИначеЕсли ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицы) Тогда
		Для Каждого ОбъектМД Из МассивОбъектовМД Цикл
			МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбъектМД.ПолноеИмя()));
			Если РежимОбходаДанных = "Строки" Тогда
				МассивТипов.Добавить(Тип(МассивФрагментов[0] + ТипТаблицы + "Строка." + МассивФрагментов[1] + "." + МассивФрагментов[2]));
			ИначеЕсли РежимОбходаДанных = "КлючиОбъектов" Тогда
				МассивТипов.Добавить(Тип(МассивФрагментов[0] + "Ссылка." + МассивФрагментов[1]));
			Иначе
				МассивТипов.Добавить(Тип(МассивФрагментов[0] + "Объект." + МассивФрагментов[1]));
			КонецЕсли; 
		КонецЦикла;                                                 
	ИначеЕсли Ложь
		Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(ТипТаблицы) 
		Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(ТипТаблицы)
	Тогда
		Для Каждого ОбъектМД Из МассивОбъектовМД Цикл
			Если РежимОбходаДанных = "Строки" Тогда
				РасширениеТипа = "Запись";
			Иначе
				РасширениеТипа = "НаборЗаписей";
			КонецЕсли; 
			ИмяТаблицы = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбъектМД);
			ТипЭлементаДанных = Тип(ирОбщий.ПолучитьИмяТипаДанныхТаблицыРегистраЛкс(ИмяТаблицы, РасширениеТипа));
			МассивТипов.Добавить(ТипЭлементаДанных);
		КонецЦикла;                                                 
	КонецЕсли; 
	Результат = Новый ОписаниеТипов(МассивТипов);
	Возврат Результат;

КонецФункции

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура вЗагрузитьОбработки(ДоступныеОбработки, ВыбранныеОбработки) Экспорт

	ТаблицаОбработок = ирОбщий.ПолучитьТаблицуИзТабличногоДокументаЛкс(ПолучитьМакет("Обработки"));
	Для каждого СтрокаОбработки из ТаблицаОбработок Цикл
		МетаФорма = Метаданные().Формы[СтрокаОбработки.Имя];
		НайденнаяСтрока = ДоступныеОбработки.Строки.Найти(МетаФорма.Имя, "ИмяФормы");
		Если НайденнаяСтрока = Неопределено Тогда
			НайденнаяСтрока = ДоступныеОбработки.Строки.Добавить();
			НайденнаяСтрока.ИмяФормы  = МетаФорма.Имя;
		КонецЕсли; 
		ЗаполнитьЗначенияСвойств(НайденнаяСтрока, СтрокаОбработки); 
		НайденнаяСтрока.Групповая = Вычислить(СтрокаОбработки.Групповая);
		НайденнаяСтрока.Обработка = МетаФорма.Синоним;
		ФормаОбработки = ЭтотОбъект.ПолучитьФорму(МетаФорма.Имя);
		Если ФормаОбработки.КартинкаЗаголовка.Вид <> ВидКартинки.Пустая Тогда
			НайденнаяСтрока.Картинка = ФормаОбработки.КартинкаЗаголовка;
		КонецЕсли; 
		Попытка
			ИспользоватьНастройки = ФормаОбработки.мИспользоватьНастройки;
		Исключение
			ИспользоватьНастройки = Ложь;
		КонецПопытки; 
		Если Не ИспользоватьНастройки Тогда
			НайденнаяСтрока.Строки.Очистить();
		КонецЕсли;
	КонецЦикла;

	МассивДляУдаления = Новый Массив;
	
	Для каждого ДоступнаяОбработка из ДоступныеОбработки.Строки Цикл
		Если ТаблицаОбработок.Найти(ДоступнаяОбработка.ИмяФормы, "Имя") = Неопределено Тогда
			МассивДляУдаления.Добавить(ДоступнаяОбработка);
		КонецЕсли;
	КонецЦикла;

	Для Индекс = 0 по МассивДляУдаления.Количество() - 1 Цикл
		ДоступныеОбработки.Строки.Удалить(МассивДляУдаления[Индекс]);
	КонецЦикла;

	МассивДляУдаления.Очистить();
	
	Для каждого ВыбраннаяОбработка из ВыбранныеОбработки Цикл
		Если      ВыбраннаяОбработка.СтрокаДоступнойОбработки = Неопределено Тогда
			МассивДляУдаления.Добавить(ВыбраннаяОбработка);
		Иначе
			Если ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель = Неопределено Тогда
				Если ДоступныеОбработки.Строки.Найти(ВыбраннаяОбработка.СтрокаДоступнойОбработки.ИмяФормы, "ИмяФормы") = Неопределено Тогда
					МассивДляУдаления.Добавить(ВыбраннаяОбработка);
				КонецЕсли;
			Иначе
				Если ДоступныеОбработки.Строки.Найти(ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель.ИмяФормы, "ИмяФормы") = Неопределено Тогда
					МассивДляУдаления.Добавить(ВыбраннаяОбработка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Для Индекс = 0 по МассивДляУдаления.Количество() - 1 Цикл
		ВыбранныеОбработки.Удалить(МассивДляУдаления[Индекс]);
	КонецЦикла;

КонецПроцедуры // вЗагрузитьОбработки()

//////////////////////////////////////////////////////////////////////////////////
//// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

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

ЭтотОбъект.НастройкиКомпоновки = Новый Соответствие;
ЭтотОбъект.АвтоВыбранныеПоля = Истина;
ЭтотОбъект.ВыводитьСообщения = Истина;
ЭтотОбъект.ПропускатьОшибки = Истина;
ЭтотОбъект.РежимОбходаДанных = "Строки";
ЭтотОбъект.ОбластьПоиска = "";
ЭтотОбъект.ЗаписьНаСервере = ирОбщий.ПолучитьРежимЗаписиНаСервереПоУмолчаниюЛкс();
мПлатформа = ирКэш.Получить();
мИмяКолонкиПометки = "_ПометкаСлужебная";
мИмяКолонкиРезультатаОбработки = "_РезультатОбработки";
мИмяКолонкиПолногоИмениТаблицы = "_ПолноеИмяТаблицы";
мВопросНаОбновлениеСтрокДляОбработкиЗадавался = Истина;
