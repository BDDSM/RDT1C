﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мПлатформа Экспорт;
Перем мСервисныйПроцессор Экспорт; // Для программного вызова из Интеграции
Перем ТаблицаБукв;
Перем мИскомыйОбъектПоискаДублей Экспорт;
Перем мСтруктураПоиска Экспорт;

Функция ЭтоБуква (Символ)
	
	Код = КодСимвола(Символ);
	
	Если (Код<=47) ИЛИ (Код>=58 И Код<=64) ИЛИ (Код>=91 И Код<=96)  ИЛИ (Код>=123 И Код<=126) Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция АнализРазличийВСловах(Список1, Список2, ПолныйСписок, ОдинаковыхСлов,ДопустимоеРазличиеСлов) Экспорт
	Если Список1.Количество() = ПолныйСписок.Количество()
		 ИЛИ Список2.Количество() = ПолныйСписок.Количество() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ПолныйСписок.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Список1.Количество() = Список2.Количество() Тогда
		ЕстьОтличия = ПроверитьСловаНаОтличие(Список1, Список2, ДопустимоеРазличиеСлов);
		ЕСли  НЕ ЕстьОтличия Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЦелоеСлово = "";
	Для Каждого Слово ИЗ ПолныйСписок Цикл
		ЦелоеСлово = ЦелоеСлово + Слово.Значение;
	КонецЦикла;
	Слово1 = "";
	Для Каждого Слово ИЗ Список1 Цикл
		Слово1 = Слово1 + Слово.Значение;
	КонецЦикла;
	Слово2 = "";
	Для Каждого Слово ИЗ Список2 Цикл
		Слово2 = Слово2 + Слово.Значение;
	КонецЦикла;
	
	Если Окр(СтрДлина(Слово1)/СтрДлина(ЦелоеСлово)*100) < ДопустимоеРазличиеСлов
		И Окр(СтрДлина(Слово2)/СтрДлина(ЦелоеСлово)*100) < ДопустимоеРазличиеСлов Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
	
КонецФункции

Функция СравнитьСлова(Слово1, Слово2, ДопустимоеРазличиеСлов)
	ТаблицаБукв.Очистить();
	ТаблицаБуквПустая = Истина;
		
	ЕСли СтрДлина(Слово1)<=СтрДлина(Слово2) Тогда
		Слово = ВРЕГ(Слово1);
		ИскомоеСлово = ВРЕГ(Слово2);
	Иначе
		Слово = ВРЕГ(Слово2);
		ИскомоеСлово = ВРЕГ(Слово1);
	КонецЕсли;
	
	Для индекс = 1 по СтрДлина(Слово) Цикл
		Символ = Сред(Слово, индекс, 1);
		ЕСли ТаблицаБуквПустая  Тогда
			поз = Найти(ИскомоеСлово, Символ);
			поправка = 0;
			Пока поз>0 Цикл
				ТаблицаБуквПустая = Ложь;
				НовСтр = ТаблицаБукв.Добавить();
				НовСтр.Позиция = поз + поправка;
				НовСтр.ДлинаСлова = 1;
				НовСтр.КолвоПропущенных = 0;
				поправка = поправка + поз;
				поз = Найти(Сред(ИскомоеСлово, поправка+1), Символ);
			КонецЦикла;
		Иначе
			Для Каждого Вхождение ИЗ ТаблицаБукв Цикл
				Если Сред(ИскомоеСлово, Вхождение.Позиция + Вхождение.ДлинаСлова, 1) = Символ Тогда
					Вхождение.ДлинаСлова = Вхождение.ДлинаСлова + 1;
				ИначеЕсли Сред(Слово, Вхождение.Позиция + Вхождение.ДлинаСлова - Вхождение.КолвоПропущенных, 1) = Вхождение.ПропущеноНа Тогда
					Вхождение.ПропущеноНа = "";
					Вхождение.ДлинаСлова = Вхождение.ДлинаСлова + 1;
					Если Сред(ИскомоеСлово, Вхождение.Позиция + Вхождение.ДлинаСлова, 1) = Символ Тогда
						Вхождение.ДлинаСлова = Вхождение.ДлинаСлова + 1;
					Иначе
						Вхождение.КолвоПропущенных = Вхождение.КолвоПропущенных + 1;
					КонецЕсли;
				Иначе					
					ЕСли Окр((Вхождение.КолвоПропущенных + 1) / СтрДлина(ИскомоеСлово) * 100)<=ДопустимоеРазличиеСлов Тогда
						Вхождение.КолвоПропущенных = Вхождение.КолвоПропущенных + 1;
						Вхождение.ДлинаСлова = Вхождение.ДлинаСлова + 1;
						Вхождение.ПропущеноНа = Символ;
					Иначе
						Вхождение.КолвоПропущенных = Вхождение.КолвоПропущенных + 1;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;			
		КонецЕсли;		
	КонецЦикла;
	
	ЕСли ТаблицаБуквПустая Тогда
		Возврат Ложь;
	КонецЕсли;
	
	
	ТаблицаБукв.Сортировать("ДлинаСлова УБЫВ, КолвоПропущенных ВОЗР");
	
	СовпалоСимволов = ТаблицаБукв[0].ДлинаСлова - ТаблицаБукв[0].КолвоПропущенных;
	
	Возврат (Окр(СовпалоСимволов / СтрДлина(ИскомоеСлово) * 100) >= (100 - ДопустимоеРазличиеСлов));
		
КонецФункции

Функция ПроверитьСловаНаОтличие(СписокСлов1, СписокСлов2, ДопустимоеРазличиеСлов) Экспорт
	СписокРазличающихсяСлов = Новый СписокЗначений;
	Для Каждого Слово1 ИЗ СписокСлов1 Цикл
		ЕстьПара = Ложь;
		Для Каждого Слово2 Из СписокСлов2 Цикл
			Если СравнитьСлова(Слово1.Значение, Слово2.Значение, ДопустимоеРазличиеСлов) Тогда
				ЕстьПара = Истина;
				СписокСлов2.Удалить(Слово2);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		ЕСли НЕ ЕстьПара Тогда
			СписокРазличающихсяСлов.Добавить(Слово1.Значение);
		КонецЕсли;
	КонецЦикла;	
	
	СписокСлов1 = СписокРазличающихсяСлов;
	
	Возврат Не (СписокСлов1.Количество() = 0 И СписокСлов2.Количество() = 0)
	
КонецФункции

Функция ПолучитьСписокСлов(ЗначениеРеквизита) Экспорт
	
	СписокСлов = Новый СписокЗначений;
	Слово = "";
	Для индекс = 1 по СтрДлина(ЗначениеРеквизита) Цикл
		Символ = Сред(ЗначениеРеквизита, индекс, 1);
		Если ЭтоБуква(Символ) Тогда
			Слово = Слово + Символ;
		Иначе
			Если Слово<>"" Тогда
			СписокСлов.Добавить(ВРЕГ(Слово));
			Слово = "";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Слово<>"" Тогда
		СписокСлов.Добавить(ВРЕГ(Слово));
	КонецЕсли;
	СписокСлов.СортироватьПоЗначению();
	Возврат СписокСлов;
	
КонецФункции // ()

Функция НайтиДубли(ИскомыйОбъект, СтруктураПоиска) Экспорт
	
	мИскомыйОбъектПоискаДублей   = ИскомыйОбъект;
	мСтруктураПоиска             = СтруктураПоиска;
	
	НайденныеОбъекты = Новый ТаблицаЗначений;
	НайденныеОбъекты.Колонки.Добавить("Ссылка");
	ИмяСправочника = ИскомыйОбъект.Метаданные().Имя;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ Разрешенные 
	|	Ссылка*
	|Из Справочник." + ИмяСправочника + " КАК Спр
	|Где Не Спр.ЭтоГруппа";
	
	
	Реквизиты = "";
	СтрокаГде = "";
	ВЗапросеТолькоРавенство = Истина;
	МетаданныеОбъекта = ИскомыйОбъект.Метаданные();
	МетаданныеРеквизитов = МетаданныеОбъекта.Реквизиты;
	СтруктураИсходныхРеквизитов = Новый Структура;
	
	Для каждого КлючИЗначение Из СтруктураПоиска Цикл
		ИмяРеквизита      = КлючИЗначение.Ключ;
		СтепеньСхожести   = КлючИЗначение.Значение;
		ЗначениеРеквизита = ИскомыйОбъект[ИмяРеквизита];
		 
		МетаданныеРеквизита    = МетаданныеРеквизитов.Найти(ИмяРеквизита);
		ПредставлениеРеквизита = ?(МетаданныеРеквизита = Неопределено, ИмяРеквизита, Строка(МетаданныеРеквизита));
		
		СтруктураИсходногоРеквизита = Новый Структура("ЗначениеРеквизита,СтепеньСхожести,СписокСлов"
		,ЗначениеРеквизита,СтепеньСхожести,ПолучитьСписокСлов(ЗначениеРеквизита));
		
		СтруктураИсходныхРеквизитов.Вставить(ИмяРеквизита,СтруктураИсходногоРеквизита);
		
		Если Не МетаданныеРеквизита = Неопределено Тогда
			ТипРеквизита = МетаданныеРеквизита.Тип;
		ИначеЕсли ИмяРеквизита = "Код" Тогда
			
			Если МетаданныеОбъекта.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Строка Тогда
				ТипРеквизита = Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(МетаданныеОбъекта.ДлинаКода));
			Иначе
				ТипРеквизита = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(МетаданныеОбъекта.ДлинаКода));
			КонецЕсли;
			
		ИначеЕсли ИмяРеквизита = "Наименование" Тогда
			
			ТипРеквизита = Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(МетаданныеОбъекта.ДлинаНаименования));
			
		Иначе
			ТипРеквизита = Неопределено;
			
		КонецЕсли; 
		
		НайденныеОбъекты.Колонки.Добавить(ИмяРеквизита, ТипРеквизита, ПредставлениеРеквизита);
		НайденныеОбъекты.Колонки.Добавить(ИмяРеквизита+"_Флаг");
		
		Реквизиты = Реквизиты+",
		|	"+ ИмяРеквизита;
		
		Если ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
			
			Если СтепеньСхожести = "=" Тогда
				
				ЗнакСравнения = ?(Не МетаданныеРеквизита = Неопределено И МетаданныеРеквизита.Тип.СодержитТип(Тип("Строка")) и МетаданныеРеквизита.Тип.КвалификаторыСтроки.Длина = 0,"Подобно","=");
				СтрокаГде = ?(СтрокаГде = "", "",СтрокаГде +" или ")+"Спр."+ИмяРеквизита +" " +ЗнакСравнения+ " &"+ИмяРеквизита;
				Запрос.УстановитьПараметр(""+ИмяРеквизита,ЗначениеРеквизита);
				
			ИначеЕсли Не СтепеньСхожести = Неопределено Тогда
				
				ВЗапросеТолькоРавенство = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "*", Реквизиты);
	
	Если ВЗапросеТолькоРавенство Тогда
		
		Запрос.Текст = Запрос.Текст + Символы.ПС + "	И("+СтрокаГде+")";
		
	КонецЕсли;
	
	ТаблицаСправочника = Запрос.Выполнить().Выгрузить();
	
	Для каждого Строка Из ТаблицаСправочника Цикл
		
		СтруктураНайденных = Новый Структура;
		
		Для каждого КлючИЗначение Из СтруктураИсходныхРеквизитов Цикл
			
			СтепеньСхожести   = КлючИЗначение.Значение.СтепеньСхожести;
			
			Если СтепеньСхожести = "=" Тогда
				
				ИмяРеквизита      = КлючИЗначение.Ключ;
				ЗначениеРеквизита = КлючИЗначение.Значение.ЗначениеРеквизита;
				
				//Поиск по равному значению
				Если ЗначениеРеквизита = Строка[ИмяРеквизита] Тогда
					
					СтруктураНайденных.Вставить(ИмяРеквизита);
					
				КонецЕсли;
				
			ИначеЕсли Не СтепеньСхожести = Неопределено Тогда
				
				ИмяРеквизита      = КлючИЗначение.Ключ;
				
				//Поиск по похожим словам
				СписокИскомыхСлов  = КлючИЗначение.Значение.СписокСлов.Скопировать();
				СписокНайденыхСлов = ПолучитьСписокСлов(Строка[ИмяРеквизита]);
				Если Не ПроверитьСловаНаОтличие(СписокИскомыхСлов,СписокНайденыхСлов,СтепеньСхожести) Тогда
					
					СтруктураНайденных.Вставить(ИмяРеквизита);
					
				КонецЕсли;
				 
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не СтруктураНайденных.Количество()=0 Тогда
			
			НоваяСтрока = НайденныеОбъекты.Добавить();
			НоваяСтрока.Ссылка = Строка.Ссылка;
			Для каждого КлючИЗначение Из СтруктураПоиска Цикл
				
				ИмяРеквизита    = КлючИЗначение.Ключ;
				
				НоваяСтрока[ИмяРеквизита] = Строка[ИмяРеквизита];
				НоваяСтрока[ИмяРеквизита+"_Флаг"] = СтруктураНайденных.Свойство(ИмяРеквизита);
				
			КонецЦикла;
			
		КонецЕсли;
		 
	КонецЦикла;
	
	Возврат НайденныеОбъекты;
	
КонецФункции // ()

// Заменяемые - Соответствие, Массив строк таблицы
// ЗамещениеВсегда - Число - замещение к ключах независимых регистров сведений, 1 - замещать, 0 - спрашивать (на клиенте) или пропускать
//
Функция ВыполнитьЗаменуЭлементов(Заменяемые, ТаблицаСсылающихсяОбъектов = Неопределено, Знач ЗаголовокИндикации = "", ЗамещениеВсегда = 0) Экспорт
	
	БылиИсключения = Ложь;
	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	//ОбрабатываемаяСсылка = Неопределено;
		
	Параметры = Новый Структура;
		
	Параметры.Вставить("Объект", Неопределено);
	СтруктураКоллизий = Новый Структура;
	ИзмененныеПроведенныеДокументы.Очистить();
	Если ТаблицаСсылающихсяОбъектов = Неопределено Тогда
		СписокСсылок = Новый Массив;
		Для Каждого КлючИЗначение Из Заменяемые Цикл
			СписокСсылок.Добавить(КлючИЗначение.Ключ);
		КонецЦикла;
		ТаблицаСсылающихсяОбъектов = НайтиПоСсылкам(СписокСсылок);
	КонецЕсли;
	Если ТаблицаСсылающихсяОбъектов.Количество() > 0 Тогда
		Если Не ЗначениеЗаполнено(ЗаголовокИндикации) Тогда
			ЗаголовокИндикации = "Замена ссылок";
		КонецЕсли;
		Если мСервисныйПроцессор <> Неопределено Тогда
			Индикатор = мСервисныйПроцессор.ПолучитьИндикаторПроцесса(ТаблицаСсылающихсяОбъектов.Количество(), ЗаголовокИндикации);
		Иначе
			Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТаблицаСсылающихсяОбъектов.Количество(), ЗаголовокИндикации);
		КонецЕсли; 
		Для Каждого СтрокаТаблицы Из ТаблицаСсылающихсяОбъектов Цикл
			Если мСервисныйПроцессор <> Неопределено Тогда
				мСервисныйПроцессор.ОбновитьИндикатор(Индикатор);
			Иначе
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			КонецЕсли; 
			Ссылка = СтрокаТаблицы.Ссылка;
			ПравильныйЭлемент = Заменяемые[Ссылка];
			Если ПравильныйЭлемент = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			ОбъектИзменен = Ложь;
			
			Если ТипЗнч(СтрокаТаблицы.Данные) = Тип("Строка") Тогда
				ОбъектСодержащийСсылку = ЗначениеИзСтрокиВнутр(СтрокаТаблицы.Данные);
			Иначе
				ОбъектСодержащийСсылку = СтрокаТаблицы.Данные;
			КонецЕсли; 
			Параметры.Объект = Неопределено;
			Если ТипЗнч(СтрокаТаблицы.Метаданные) = Тип("Строка") Тогда
				//ОбъектМД = Метаданные.НайтиПоПолномуИмени(СтрокаТаблицы.Метаданные);
				ОбъектМД = мПлатформа.ПолучитьОбъектМДПоПолномуИмени(СтрокаТаблицы.Метаданные);
			Иначе
				ОбъектМД = СтрокаТаблицы.Метаданные;
			КонецЕсли; 
			ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(ОбъектМД.ПолноеИмя());
			Если ирОбщий.ЛиКорневойТипОбъектаБДЛкс(ТипТаблицы) Тогда
				Параметры.Объект = ОбъектСодержащийСсылку.ПолучитьОбъект();
				Если Параметры.Объект <> Неопределено Тогда
					ПредставлениеОбъекта = "" + Параметры.Объект;
					ОбъектИзменен = ирОбщий.ЗаменитьЗначениеВОбъектеБДЛкс(Параметры.Объект, Ссылка, ПравильныйЭлемент) Или ОбъектИзменен;
				Иначе
					ПредставлениеОбъекта = "" + ОбъектСодержащийСсылку;
				КонецЕсли;
			Иначе
				ПредставлениеОбъекта = "" + ОбъектСодержащийСсылку;
			КонецЕсли;
			Сообщить("Обрабатывается " + ПредставлениеОбъекта);
			Если Метаданные.Документы.Содержит(ОбъектМД) Тогда
				
				Для Каждого Движение ИЗ ОбъектМД.Движения Цикл
					//НаборЗаписей = Параметры.Объект.Движения[Движение.Имя];
					НаборЗаписей = Новый (СтрЗаменить(Движение.ПолноеИмя(), ".", "НаборЗаписей."));
					НаборЗаписей.Отбор.Регистратор.Установить(ОбъектСодержащийСсылку);
					БылиИсключения = Не ОбработатьДанныеРегистра(НаборЗаписей, Заменяемые);
					Если Истина
						И БылиИсключения 
						И ВыполнятьВТранзакции
					Тогда
						Перейти ~ОТКАТ;
					КонецЕсли;
				КонецЦикла;
				
				Для Каждого Последовательность ИЗ Метаданные.Последовательности Цикл
					Если Последовательность.Документы.Содержит(ОбъектМД) Тогда
						НаборЗаписей = Новый (СтрЗаменить(Последовательность.ПолноеИмя(), ".", "НаборЗаписей."));
						НаборЗаписей.Отбор.Регистратор.Установить(ОбъектСодержащийСсылку);
						БылиИсключения = Не ОбработатьДанныеРегистра(НаборЗаписей, Заменяемые);
						Если Истина
							И БылиИсключения 
							И ВыполнятьВТранзакции
						Тогда
							Перейти ~ОТКАТ;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
			ИначеЕсли Метаданные.Константы.Содержит(ОбъектМД) Тогда
				
				Если ОбъектМД.Тип.СодержитТип(ТипЗнч(ПравильныйЭлемент)) Тогда
					Константы[ОбъектМД.Имя].Установить(ПравильныйЭлемент);
					ОбъектИзменен = Истина;
				КонецЕсли; 
				
			ИначеЕсли Метаданные.РегистрыСведений.Содержит(ОбъектМД) Тогда
				
				МенеджерЗаписи            = РегистрыСведений[ОбъектМД.Имя].СоздатьМенеджерЗаписи();
				КоллизийныйМенеджерЗаписи = РегистрыСведений[ОбъектМД.Имя].СоздатьМенеджерЗаписи();
				Периодический = (ОбъектМД.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический);
				МассивИзмененныхИзмерений = Новый Массив;
				Если Периодический Тогда
					МенеджерЗаписи.Период            = ОбъектСодержащийСсылку.Период;
					КоллизийныйМенеджерЗаписи.Период = ОбъектСодержащийСсылку.Период;
				КонецЕсли;
				Для каждого Рекв Из ОбъектМД.Измерения Цикл
					ЗначениеИзмерения = ОбъектСодержащийСсылку[Рекв.Имя];
					МенеджерЗаписи[Рекв.Имя] = ЗначениеИзмерения;
					Если ЗначениеИзмерения = Ссылка Тогда
						Если ирОбщий.БезопасноПрисвоитьПроизвольнуюСсылкуЛкс(КоллизийныйМенеджерЗаписи[Рекв.Имя], ПравильныйЭлемент) Тогда 
							МассивИзмененныхИзмерений.Добавить(Рекв.Имя);
							ОбъектИзменен = Истина;
						КонецЕсли; 
					Иначе
						КоллизийныйМенеджерЗаписи[Рекв.Имя] = ЗначениеИзмерения;
					КонецЕсли;
				КонецЦикла;
				
				БылаКоллизия = Ложь;
				Если МассивИзмененныхИзмерений.Количество() > 0 Тогда
					КоллизийныйМенеджерЗаписи.Прочитать();
					Если КоллизийныйМенеджерЗаписи.Выбран() Тогда
						МенеджерЗаписи.Прочитать();
						МассивКоллекцийРеквизитов = Новый Массив;
						МассивКоллекцийРеквизитов.Добавить(ОбъектМД.Ресурсы);
						МассивКоллекцийРеквизитов.Добавить(ОбъектМД.Реквизиты);
						Если Не СтруктураКоллизий.Свойство(ОбъектМД.Имя) Тогда 
							ТаблицаЗаписей = РегистрыСведений[ОбъектМД.Имя].СоздатьНаборЗаписей().Выгрузить();
							ТаблицаЗаписей.Колонки.Добавить("МенеджерЗамены");
							ТаблицаЗаписей.Колонки.Добавить("МенеджерОригинала");
							Для Каждого КоллекцияРеквизитов Из МассивКоллекцийРеквизитов Цикл
								Для Каждого МетаРеквизит Из КоллекцияРеквизитов Цикл
									ИмяКолонки = МетаРеквизит.Имя;
									ПредставлениеКолонки = МетаРеквизит.Представление();
									КолонкаОригинала = ТаблицаЗаписей.Колонки[ИмяКолонки];
									КолонкаОригинала.Имя       = "Оригинал"   + ИмяКолонки;
									КолонкаОригинала.Заголовок = "Оригинал: " + ПредставлениеКолонки;
									КолонкаЗамены = ТаблицаЗаписей.Колонки.Вставить(ТаблицаЗаписей.Колонки.Индекс(КолонкаОригинала),
										"Замена" + ИмяКолонки, , "Замена: " + ПредставлениеКолонки);
									ЗаполнитьЗначенияСвойств(КолонкаЗамены, КолонкаОригинала, , "Имя, Заголовок");
								КонецЦикла;
							КонецЦикла;
							ТаблицаЗаписей.Колонки.Вставить(0, "Заменить", Новый ОписаниеТипов("Булево"), "Заменить");
							СтруктураКоллизий.Вставить(ОбъектМД.Имя, ТаблицаЗаписей);
						КонецЕсли;
						НоваяКоллизийнаяЗапись = СтруктураКоллизий[ОбъектМД.Имя].Добавить();
						Для Каждого КоллекцияРеквизитов Из МассивКоллекцийРеквизитов Цикл
							Для Каждого МетаРеквизит Из КоллекцияРеквизитов Цикл
								ИмяКолонки = МетаРеквизит.Имя;
								ЗначениеРеквизита = МенеджерЗаписи[ИмяКолонки];
								НоваяКоллизийнаяЗапись["Оригинал" + ИмяКолонки] = КоллизийныйМенеджерЗаписи[ИмяКолонки];
								Если ЗначениеРеквизита = Ссылка Тогда
									НоваяКоллизийнаяЗапись["Замена" + ИмяКолонки] = ПравильныйЭлемент;
								Иначе
									НоваяКоллизийнаяЗапись["Замена" + ИмяКолонки] = ЗначениеРеквизита;
								КонецЕсли;
								КоллизийныйМенеджерЗаписи[ИмяКолонки] = НоваяКоллизийнаяЗапись["Замена" + ИмяКолонки];
								Если НоваяКоллизийнаяЗапись["Оригинал" + ИмяКолонки] <> НоваяКоллизийнаяЗапись["Замена" + ИмяКолонки] Тогда
									БылаКоллизия = Истина;
								КонецЕсли;
							КонецЦикла;
						КонецЦикла;
						Если БылаКоллизия Тогда
							ЗаполнитьЗначенияСвойств(НоваяКоллизийнаяЗапись, КоллизийныйМенеджерЗаписи);
							Для Каждого ИмяКолонки Из МассивИзмененныхИзмерений Цикл
								НоваяКоллизийнаяЗапись[ИмяКолонки] = МенеджерЗаписи[ИмяКолонки];
							КонецЦикла;
							НоваяКоллизийнаяЗапись.МенеджерЗамены    = КоллизийныйМенеджерЗаписи;
							НоваяКоллизийнаяЗапись.МенеджерОригинала = МенеджерЗаписи;
						Иначе
							СтруктураКоллизий[ОбъектМД.Имя].Удалить(НоваяКоллизийнаяЗапись);
							МенеджерЗаписи.Удалить();
							БылаКоллизия = Истина;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
				Если БылаКоллизия Тогда
					БылиИсключения = Ложь;
				Иначе
					БылиИсключения = Не ОбработатьДанныеРегистра(МенеджерЗаписи, Заменяемые);
				КонецЕсли;
				
				Если Истина
					И БылиИсключения 
					И ВыполнятьВТранзакции
				Тогда
					Перейти ~ОТКАТ;
				КонецЕсли;

			//Иначе
			//	Сообщить("Ссылки типа в объектах типа " + ОбъектМД.ПолноеИмя() + " не заменяются!!");
			КонецЕсли;
			Если Параметры.Объект <> Неопределено Тогда
				//Если Параметры.Объект.Модифицированность() Тогда
				Если ОбъектИзменен Тогда
					Если ОтключатьКонтрольЗаписи Тогда
						Попытка
							Параметры.Объект.ОбменДанными.Загрузка = Истина;
						Исключение
							// Для планов обмена такой прием не проходит
						КонецПопытки; 
					КонецЕсли;
					Попытка
						ирОбщий.ЗаписатьОбъектЛкс(Параметры.Объект, ЗаписьНаСервере);
						Если ОтключатьКонтрольЗаписи Тогда
							ЗаписьЖурналаРегистрации("Запись с флагом Загрузка", УровеньЖурналаРегистрации.Информация, ОбъектМД,
								ОбъектСодержащийСсылку, "");
						КонецЕсли;
					Исключение
						Сообщить(ОписаниеОшибки(), СтатусСообщения.Важное);
						БылиИсключения = Истина;
						ОбъектИзменен = Ложь;
						Если ВыполнятьВТранзакции Тогда
							Перейти ~ОТКАТ;
						КонецЕсли;
					КонецПопытки;
					Если Истина
						И ОбъектИзменен
						И Метаданные.Документы.Содержит(ОбъектМД)
						И ОбъектМД.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить 
						И Параметры.Объект.Проведен
					Тогда
						СтрокаДляДокумента = ИзмененныеПроведенныеДокументы.Добавить();
						СтрокаДляДокумента.ДатаДокумента = Параметры.Объект.Дата;
						СтрокаДляДокумента.ТипДокумента = ОбъектМД.Имя;
						СтрокаДляДокумента.Документ = Параметры.Объект.Ссылка;
					КонецЕсли; 
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла;
		Если мСервисныйПроцессор <> Неопределено Тогда
			мСервисныйПроцессор.ОсвободитьИндикаторПроцесса(Индикатор, Истина);
		Иначе
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс(Индикатор, Истина);
		КонецЕсли; 
	КонецЕсли; 

	МассивЭлементовКУдалению = Новый Массив; 
	Для Каждого ЭлементТаблицыРегистра Из СтруктураКоллизий Цикл
		Если ЭлементТаблицыРегистра.Значение.Количество() = 0 Тогда
			МассивЭлементовКУдалению.Добавить(ЭлементТаблицыРегистра.Ключ);
		КонецЕсли;
	КонецЦикла;
	Для Каждого ЭлементКУдалению Из МассивЭлементовКУдалению Цикл
		СтруктураКоллизий.Удалить(ЭлементКУдалению);
	КонецЦикла;
	Если СтруктураКоллизий.Количество() > 0 Тогда
		Если ЗамещениеВсегда = 1 Тогда
			ЗамещатьВЭтотРаз = Истина;
		Иначе
		#Если Клиент Тогда
			ФормаЗамещенияВНезависимыхРегистрахСведений = ПолучитьФорму("ФормаЗамещенияВНезависимыхРегистрахСведений");
			ФормаЗамещенияВНезависимыхРегистрахСведений.КодВсегда = ЗамещениеВсегда;
			ФормаЗамещенияВНезависимыхРегистрахСведений.СтруктураКоллизий = СтруктураКоллизий;
			ФормаЗамещенияВНезависимыхРегистрахСведений.ОткрытьМодально();
			ЗамещениеВсегда = ФормаЗамещенияВНезависимыхРегистрахСведений.КодВсегда;
			ЗамещатьВЭтотРаз = ФормаЗамещенияВНезависимыхРегистрахСведений.РезультатФормы;
		#Иначе
			ЗамещатьВЭтотРаз = Ложь;
		#КонецЕсли
		КонецЕсли; 
		Если ЗамещатьВЭтотРаз Тогда
			Для Каждого ЭлементРегистра Из СтруктураКоллизий Цикл
				Для Каждого СтрокаЗаписи Из ЭлементРегистра.Значение Цикл
					Если СтрокаЗаписи.Заменить Тогда
						СтрокаЗаписи.МенеджерЗамены.Записать();
					КонецЕсли;
					СтрокаЗаписи.МенеджерОригинала.Удалить();
				КонецЦикла;
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли;
~ОТКАТ:
	Если ВыполнятьВТранзакции Тогда
		Если БылиИсключения Тогда
			ОтменитьТранзакцию();
			ИзмененныеПроведенныеДокументы.Очистить();
		Иначе
			ЗафиксироватьТранзакцию();
		КонецЕсли;	
	КонецЕсли;
	Возврат Не БылиИсключения;
	
КонецФункции // ВыполнитьЗаменуЭлементов()

Функция ОбработатьДанныеРегистра(НаборЗаписейИлиМенеджерЗаписи, Заменяемые)
	
	ОбъектМД = ирОбщий.ПолучитьМетаданныеЛкс(НаборЗаписейИлиМенеджерЗаписи);
	ИмяТаблицыРегистра = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбъектМД);
	ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(ИмяТаблицыРегистра);
	ЭтоПоследовательность = ТипТаблицы = "Последовательность";
	Попытка
		НаборЗаписейИлиМенеджерЗаписи.Прочитать();
	Исключение
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Важное);
		Возврат Ложь;
	КонецПопытки; 
	Если Истина
		И Не ЭтоПоследовательность
		И Не НаборЗаписейИлиМенеджерЗаписи.Выбран() 
	Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ирОбщий.ЛиМенеджерЗаписиРегистраЛкс(НаборЗаписейИлиМенеджерЗаписи) Тогда
		НаборЗаписей = ирОбщий.ПолучитьНаборЗаписейПоКлючуЛкс(ИмяТаблицыРегистра, НаборЗаписейИлиМенеджерЗаписи, Истина);
	Иначе
		НаборЗаписей = НаборЗаписейИлиМенеджерЗаписи;
	КонецЕсли;
	
	// Старый пустой набор нужен для очистки строк по старому отбору в случае изменения отбора набора
	СтарыйНабор = ирОбщий.СоздатьНаборЗаписейПоИмениТаблицыБДЛкс(ИмяТаблицыРегистра);
	ирОбщий.СкопироватьОтборЛкс(СтарыйНабор.Отбор, НаборЗаписей.Отбор);
	ОтборИзменен = Ложь;
	Для Каждого ЭлементОтбора Из НаборЗаписей.Отбор Цикл
		ЗначениеПоля = ЭлементОтбора.Значение;
		НаЧтоЗаменять = Заменяемые[ЗначениеПоля];
		Если НаЧтоЗаменять = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ОтборИзменен = ирОбщий.БезопасноПрисвоитьПроизвольнуюСсылкуЛкс(ЭлементОтбора.Значение, НаЧтоЗаменять) Или ОтборИзменен;
	КонецЦикла;
	
	КомпоновщикТаблицы = ирКэш.ПолучитьКомпоновщикТаблицыМетаданныхЛкс(ОбъектМД.ПолноеИмя()); // Это быстрее при малом числе различных регистров
	//КомпоновщикТаблицы = ирКэш.ПолучитьКомпоновщикТаблицыБДПоМетаданнымЛкс(ОбъектМД.ПолноеИмя()); // Это быстрее при большом числе различных регистров
	#Если _ Тогда
	    КомпоновщикТаблицы = Новый КомпоновщикНастроекКомпоновкиДанных
	#КонецЕсли
	ДоступныеПоляВыбора = КомпоновщикТаблицы.Настройки.ДоступныеПоляВыбора.Элементы;
	ОбъектИзменен = ОтборИзменен; // Антибаг платформы 8.2. При изменении реквизитов строк набора записей для регистра бухгалтерии не взводится модифицированность
	ЭтоРегистрБухгалтерии = ирОбщий.ПолучитьПервыйФрагментЛкс(ИмяТаблицыРегистра) = "РегистрБухгалтерии";
	Если ЭтоРегистрБухгалтерии Тогда
		ТаблицаНабора = НаборЗаписей.Выгрузить();
	Иначе
		ТаблицаНабора = НаборЗаписей;
	КонецЕсли; 
	Для Каждого Запись Из ТаблицаНабора Цикл
		Для каждого Поле Из ДоступныеПоляВыбора Цикл
			//Если Не Поле.Поле Тогда // было для полей построителя запроса
			//	// Антибаг платформы. Зачем то добавляются лишние поля в доступные поля, не свойственные по признаку наличия корресподнеции
			//	// у бухгалтерских таблиц.
			//	Продолжить;
			//КонецЕсли;
			//ИмяПоля = Поле.Имя;
			Если Поле.Папка Тогда
				Продолжить;
			КонецЕсли; 
			ИмяПоля = "" + Поле.Поле;
			ЗначениеПоля = Запись[ИмяПоля];
			НаЧтоЗаменять = Заменяемые[ЗначениеПоля];
			Если НаЧтоЗаменять = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ОбъектИзменен = ирОбщий.БезопасноПрисвоитьПроизвольнуюСсылкуЛкс(Запись[ИмяПоля], НаЧтоЗаменять) Или ОбъектИзменен;
		КонецЦикла; 
		#Если Клиент Тогда
		ОбработкаПрерыванияПользователя();
		#КонецЕсли 
	КонецЦикла;
	Если ЭтоРегистрБухгалтерии Тогда
		НаборЗаписей.Загрузить(ТаблицаНабора);
	КонецЕсли; 
	Если ОбъектИзменен Тогда
		Если ОтключатьКонтрольЗаписи Тогда
			СтарыйНабор.ОбменДанными.Загрузка = Истина;
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
		КонецЕсли;
		НачатьТранзакцию();
		Попытка
			Если ОтборИзменен Тогда
				ирОбщий.ЗаписатьОбъектЛкс(СтарыйНабор, ЗаписьНаСервере);
			КонецЕсли; 
			ирОбщий.ЗаписатьОбъектЛкс(НаборЗаписей, ЗаписьНаСервере);
		Исключение
			ОтменитьТранзакцию();
			Сообщить(ОписаниеОшибки(), СтатусСообщения.Важное);
			Возврат Ложь;
		КонецПопытки;
		ЗафиксироватьТранзакцию();
	КонецЕсли; 
	Если ТипТаблицы = "РегистрРасчета" Тогда
		Для Каждого Перерасчет Из ОбъектМД.Перерасчеты Цикл
			ИмяТаблицыПерерасчета = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(Перерасчет);
			НаборЗаписейПерерасчета = ирОбщий.СоздатьНаборЗаписейПоИмениТаблицыБДЛкс(ИмяТаблицыПерерасчета);
			НаборЗаписейПерерасчета.Отбор.ОбъектПерерасчета.Установить(НаборЗаписей.Отбор.Регистратор.Значение);
			БылиИсключения = Не ОбработатьДанныеРегистра(НаборЗаписейПерерасчета, Заменяемые);
			Если БылиИсключения Тогда
				Возврат Ложь;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	Возврат Истина;

КонецФункции // ОбработатьДанныеРегистра()

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

мПлатформа = ирКэш.Получить();
ТаблицаБукв = Новый ТаблицаЗначений;
ТаблицаБукв.Колонки.Добавить("Позиция");
ТаблицаБукв.Колонки.Добавить("КолвоПропущенных");
ТаблицаБукв.Колонки.Добавить("ДлинаСлова");
ТаблицаБукв.Колонки.Добавить("ПропущеноНа");
ЗаписьНаСервере = ирОбщий.ПолучитьРежимЗаписиНаСервереПоУмолчаниюЛкс();
ЭтотОбъект.ОтключатьКонтрольЗаписи = Истина;