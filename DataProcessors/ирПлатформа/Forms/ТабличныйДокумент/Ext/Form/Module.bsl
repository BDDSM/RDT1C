﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем СравнительТабличныхДокументов;

Функция ПолучитьРезультат()
	
	Возврат ЭлементыФормы.ПолеТабличногоДокумента.ПолучитьОбласть();
	
КонецФункции

Процедура УстановитьРедактируемоеЗначение(НовоеЗначение)
	
	ЭлементыФормы.ПолеТабличногоДокумента.ВставитьОбласть(НовоеЗначение.Область());
	ЗаполнитьЗначенияСвойств(ЭлементыФормы.ПолеТабличногоДокумента, НовоеЗначение,, "ТолькоПросмотр"); 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если НачальноеЗначениеВыбора = Неопределено Тогда
		НачальноеЗначениеВыбора = Новый ТабличныйДокумент;
	КонецЕсли;
	УстановитьРедактируемоеЗначение(НачальноеЗначениеВыбора);

КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	Модифицированность = Ложь;
	НовоеЗначение = ПолучитьРезультат();
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Модифицированность Тогда
		Ответ = Вопрос("Данные в форме были изменены. Хотите сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
			Возврат;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			Модифицированность = Ложь;
			ОсновныеДействияФормыОК();
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаЗагрузитьИзФайла(Кнопка)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(, "mxl");
	Если ПолноеИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Попытка
		ЭлементыФормы.ПолеТабличногоДокумента.Прочитать(ПолноеИмяФайла);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	ирОбщий.ОткрытьФормуПроизвольногоЗначенияЛкс(ПолучитьРезультат().ПолучитьОбласть(),,,, Ложь);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументАвтосумма(Кнопка)
	
	ЭтаФорма.Автосумма = Не Кнопка.Пометка;
	Кнопка.Пометка = Автосумма;
	ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть;
	
КонецПроцедуры

Процедура ПолеТабличногоДокументаПриАктивизацииОбласти(Элемент)
	
	Если Автосумма Тогда
		ТекстКнопки = ирОбщий.ПолеТабличногоДокумента_ПолучитьПредставлениеСуммыВыделенныхЯчеекЛкс(Элемент);
	Иначе
		ТекстКнопки = "";
	КонецЕсли;
	ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.Автосумма.Текст = ТекстКнопки;

КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(СравнительТабличныхДокументов, ЭлементыФормы.ПолеТабличногоДокумента);
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументРедактирование(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементыФормы.ПолеТабличногоДокумента.ТолькоПросмотр = Не Кнопка.Пометка;
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументРедакторОбъектаБД(Кнопка)
	
	Расшифровка = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Расшифровка;
	Если ирОбщий.ЛиСсылкаНаОбъектБДЛкс(Расшифровка) Тогда
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(Расшифровка);
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументПередатьВПодборИОбработкуОбъектов(Кнопка)
	
	ТаблицаЗначений = ирОбщий.ПолучитьТаблицуКлючейИзТабличногоДокументаЛкс(ЭлементыФормы.ПолеТабличногоДокумента);
	Если ТаблицаЗначений.Количество() > 0 Тогда
		ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(ТаблицаЗначений.ВыгрузитьКолонку(0));
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументАвтоширина(Кнопка)
	
	ирОбщий.УстановитьАвтоширинуКолонокТабличногоДокументаЛкс(ЭлементыФормы.ПолеТабличногоДокумента);
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументЗафиксировать(Кнопка)
	
	ЭлементыФормы.ПолеТабличногоДокумента.ФиксацияСлева = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Лево - 1;
	ЭлементыФормы.ПолеТабличногоДокумента.ФиксацияСверху = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Верх - 1;
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументСохранитьВФайл(Кнопка)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(Ложь, "mxl");
	Если ПолноеИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Попытка
		ЭлементыФормы.ПолеТабличногоДокумента.Записать(ПолноеИмяФайла);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки; 
	
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

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ТабличныйДокумент");
