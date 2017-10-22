﻿Перем мСвязанныйРедакторОбъектаБД;
Перем Построитель;
Перем ЭтоПеречисление;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Функция УстановитьОбъектМетаданных(ПолноеИмяТаблицы = Неопределено) Экспорт

	Если ПолноеИмяТаблицы <> Неопределено Тогда
		ЗначениеИзменено = Ложь;
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(фОбъект.ОбъектМетаданных, ПолноеИмяТаблицы, ЗначениеИзменено);
		Если Не ЗначениеИзменено Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЕсли; 
	ОписаниеТаблицы = ирОбщий.ПолучитьОписаниеТаблицыБДИис(фОбъект.ОбъектМетаданных);
	Если ОписаниеТаблицы = Неопределено Тогда
		фОбъект.ОбъектМетаданных = Неопределено;
		Возврат Ложь;
	КонецЕсли; 
	ЭлементыФормы.ДинамическийСписок.ИзменятьСоставСтрок = Истина;
	МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(фОбъект.ОбъектМетаданных);
	ОсновнойЭУ = ЭлементыФормы.ДинамическийСписок;
	ИмяТипаСписка = ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(фОбъект.ОбъектМетаданных, "Список");
	Если ЗначениеЗаполнено(ИмяТипаСписка) Тогда
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(фОбъект.ОбъектМетаданных);
		Если Истина
			И ЭтаФорма.Открыта()
			И ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(МассивФрагментов[0]) 
			И ОбъектМД.Измерения.Количество() = 0
			И ОбъектМД.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический
			И ОбъектМД.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый
		Тогда
			// Антибаг платформы 8.3 Приложение аварийно завершалось
			ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов("ТаблицаЗначений");
			Сообщить("Списки независимых непериодических регистров сведений без измерений после открытия формы не подключаются из-за ошибки платформы");
		Иначе
			ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов(ИмяТипаСписка);
			ирОбщий.НастроитьАвтоТабличноеПолеДинамическогоСпискаЛкс(ОсновнойЭУ, фОбъект.РежимИмяСиноним);
			ЭтаФорма.Отбор = ЭлементыФормы.ДинамическийСписок.Значение.Отбор;
		КонецЕсли; 
	Иначе
		ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 100000 РАЗРЕШЕННЫЕ Т.* ИЗ " + фОбъект.ОбъектМетаданных + " КАК Т";
		ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов("ТаблицаЗначений");
		Построитель.Текст = ТекстЗапроса;
		ОсновнойЭУ.Значение = Построитель.Результат.Выгрузить();
		ОсновнойЭУ.СоздатьКолонки();
		ОсновнойЭУ.ИзменятьСоставСтрок = Ложь;
		Для Каждого КолонкаТП Из ОсновнойЭУ.Колонки Цикл
			КолонкаТП.ТолькоПросмотр = Истина;
		КонецЦикла;
		Построитель.ЗаполнитьНастройки();
		КолонкаИдентификатора = ОсновнойЭУ.Колонки.Добавить("ИдентификаторСсылкиЛкс");
		КолонкаИдентификатора.ТекстШапки = "Идентификатор ссылки";
		ЭтаФорма.Отбор = Построитель.Отбор;
	КонецЕсли;
	ПредставлениеТаблицы = ОписаниеТаблицы.Представление;
	Для Каждого КолонкаТП Из ОсновнойЭУ.Колонки Цикл
		Если ТипЗнч(КолонкаТП.ЭлементУправления) = Тип("ПолеВвода") Тогда
			КолонкаТП.ЭлементУправления.УстановитьДействие("ОкончаниеВводаТекста", Новый Действие("ПолеВводаКолонкиСписка_ОкончаниеВводаТекста"));
			КолонкаТП.ЭлементУправления.УстановитьДействие("НачалоВыбора", Новый Действие("ПолеВводаКолонкиСписка_НачалоВыбора"));
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ПредставлениеТаблицы, ": ");
	Если РежимВыбора Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (выбор)";
	КонецЕсли; 
	КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(ОбъектМетаданных);
	ЭтоПеречисление = ирОбщий.ЛиКорневойТипПеречисленияЛкс(КорневойТип);
	фОбъект.ВместоОсновной = ирОбщий.ПолучитьИспользованиеДинамическогоСпискаВместоОсновнойФормыЛкс(ОбъектМетаданных);
	Попытка
		ЭлементыФормы.ДинамическийСписок.Колонки.Наименование.ОтображатьИерархию = Истина;
		ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.ОтображатьИерархию = Ложь;
		ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.Видимость = Ложь;
	Исключение
	КонецПопытки;
	ЭлементыФормы.КоманднаяПанельПереключателяДерева.Кнопки.РежимДерева.Доступность = ирОбщий.ЛиМетаданныеИерархическогоОбъектаЛкс(ОбъектМД);
	ирОбщий.НастроитьТабличноеПолеЛкс(ОсновнойЭУ);
	ЗагрузитьНастройкиКолонок();
	фОбъект.СтарыйОбъектМетаданных = фОбъект.ОбъектМетаданных;
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.КП_Список.Кнопки.ПоследниеВыбранные);
	Возврат Истина;
	
КонецФункции

Процедура СохранитьНастройкиКолонок()
	
	Если Не ЗначениеЗаполнено(фОбъект.СтарыйОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли; 
	фОбъект.НастройкиКолонок.Очистить();
	Для Каждого КолонкаТП Из ЭлементыФормы.ДинамическийСписок.Колонки Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок.Добавить();
		ЗаполнитьЗначенияСвойств(ОписаниеКолонки, КолонкаТП); 
	КонецЦикла;
	ирОбщий.СохранитьЗначениеЛкс("ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, фОбъект.НастройкиКолонок.Выгрузить());
	
КонецПроцедуры

Процедура ЗагрузитьНастройкиКолонок()
	
	СохраненныеНастройки = ирОбщий.ВосстановитьЗначениеЛкс("ДинамическийСписок." + ОбъектМетаданных + "." + РежимВыбора);
	Если СохраненныеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	фОбъект.НастройкиКолонок.Загрузить(СохраненныеНастройки);
	НачальноеКоличество = фОбъект.НастройкиКолонок.Количество(); 
	КолонкиТП = ЭлементыФормы.ДинамическийСписок.Колонки;
	Для Счетчик = 1 По НачальноеКоличество Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок[НачальноеКоличество - Счетчик];
		КолонкаТП = КолонкиТП.Найти(ОписаниеКолонки.Имя);
		Если КолонкаТП <> Неопределено Тогда
			КолонкиТП.Сдвинуть(КолонкаТП, -КолонкиТП.Индекс(КолонкаТП));
			ЗаполнитьЗначенияСвойств(КолонкаТП, ОписаниеКолонки,, "Имя"); 
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Процедура НайтиСсылкуВСписке(КлючСтроки, УстановитьОбъектМетаданных = Истина) Экспорт

	МетаданныеТаблицы = Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(КлючСтроки));
	Если УстановитьОбъектМетаданных Тогда
		УстановитьОбъектМетаданных(МетаданныеТаблицы.ПолноеИмя());
	КонецЕсли; 
	ИмяXMLТипа = СериализаторXDTO.XMLТипЗнч(КлючСтроки).ИмяТипа;
	Если Ложь
		Или Найти(ИмяXMLТипа, "Ref.") > 0
		Или Найти(ИмяXMLТипа, "RecordKey.") > 0
	Тогда
		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = КлючСтроки;
	Иначе
		ирОбщий.СкопироватьОтборЛюбойЛкс(ЭлементыФормы.ДинамическийСписок.Значение.Отбор, КлючСтроки.Методы.Отбор);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ДинамическийСписок_ОбъектМетаданных_НачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбъектМетаданныхОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура КП_СписокОткрытьУниверсальныйОтбор(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок, ЭтаФорма);

КонецПроцедуры

Процедура КП_СписокСжатьКолонки(Кнопка)
	
	ирОбщий.СжатьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭтаФорма.СвязиИПараметрыВыбора = Истина;
	Если КлючУникальности <> Неопределено Тогда
		НовоеИмяТаблицы = КлючУникальности;
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(НовоеИмяТаблицы);
		Если ОбъектМД <> Неопределено Тогда
			УстановитьОбъектМетаданных(НовоеИмяТаблицы);
		КонецЕсли;
	КонецЕсли; 
	Если Истина
		И ЗначениеЗаполнено(фОбъект.ОбъектМетаданных)
		И НачальноеЗначениеВыбора <> Неопределено 
		И ЗначениеЗаполнено(НачальноеЗначениеВыбора) 
	Тогда
		Если Ложь
			Или ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора)
			Или ирОбщий.ЛиСсылкаНаПеречислениеЛкс(НачальноеЗначениеВыбора)
			Или ирОбщий.ЛиКлючЗаписиРегистраЛкс(НачальноеЗначениеВыбора)
		Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = НачальноеЗначениеВыбора;
		ИначеЕсли ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора, Ложь) Тогда 
			ДанныеСписка = ЭлементыФормы.ДинамическийСписок.Значение;
			ТекущаяСтрока = ДанныеСписка.Найти(НачальноеЗначениеВыбора, "Ссылка");
			Если ТекущаяСтрока <> Неопределено Тогда
				ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = ТекущаяСтрока;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	Если ЗначениеЗаполнено(фОбъект.ОбъектМетаданных) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДинамическийСписок;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокШиринаКолонок(Кнопка)
	
	ирОбщий.РасширитьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокРедакторОбъектаБДСтроки(Кнопка)
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок, ОбъектМетаданных);
	
КонецПроцедуры

Процедура КП_СписокОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДинамическийСписокПриПолученииДанных(Элемент, ОформленияСтрок)
	
	КолонкаИдентификатор = Элемент.Колонки.Найти("ИдентификаторСсылкиЛкс");
	Если КолонкаИдентификатор <> Неопределено Тогда
		КолонкаИдентификатораВидима = КолонкаИдентификатор.Видимость;
	Иначе
		КолонкаИдентификатораВидима = Ложь;
	КонецЕсли; 
	КолонкаИмяПредопределенного = Элемент.Колонки.Найти("ИмяПредопределенныхДанных");
	Если КолонкаИмяПредопределенного <> Неопределено Тогда
		КолонкаИмяПредопределенногоВидима = КолонкаИмяПредопределенного.Видимость;
	Иначе
		КолонкаИмяПредопределенногоВидима = Ложь;
	КонецЕсли; 
	КолонкаЭтоГруппа = Элемент.Колонки.Найти("ЭтоГруппа");
	Если Истина
		И КолонкаЭтоГруппа <> Неопределено 
		И КолонкаЭтоГруппа.Данные = ""
		И КолонкаЭтоГруппа.ДанныеФлажка = ""
	Тогда
		// Антибаг платформы 8.2-8.3.9 В свойство Данные и ДанныеФлажка нельзя записать "ЭтоГруппа", поэтому выводим значение в ячейки сами
		КолонкаЭтоГруппаВидима = КолонкаЭтоГруппа.Видимость;
	Иначе
		КолонкаЭтоГруппаВидима = Ложь;
	КонецЕсли;
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		Если ДанныеСтроки = неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если КолонкаИдентификатораВидима Тогда
			ЯчейкаИдентификатора = ОформлениеСтроки.Ячейки["ИдентификаторСсылкиЛкс"];
			Если ЭтоПеречисление Тогда
				ИдентификаторСсылки = "" + XMLСтрока(ДанныеСтроки);
			Иначе
				ИдентификаторСсылки = "" + ирОбщий.ПолучитьИдентификаторСсылкиЛкс(ДанныеСтроки.Ссылка);
			КонецЕсли; 
			ЯчейкаИдентификатора.УстановитьТекст(ИдентификаторСсылки);
		КонецЕсли;
		Если КолонкаИмяПредопределенногоВидима Тогда
			ЯчейкаИмяПредопределенного = ОформлениеСтроки.Ячейки["ИмяПредопределенныхДанных"];
			ИмяПредопределенного = ирОбщий.ПолучитьМенеджерЛкс(ОбъектМетаданных).ПолучитьИмяПредопределенного(ДанныеСтроки.Ссылка);
			ЯчейкаИмяПредопределенного.УстановитьТекст(ИмяПредопределенного);
		КонецЕсли;
		Если КолонкаЭтоГруппаВидима Тогда
			ЯчейкаИдентификатора = ОформлениеСтроки.Ячейки["ЭтоГруппа"];
			ЯчейкаИдентификатора.Значение = ДанныеСтроки.ЭтоГруппа;
		КонецЕсли;
		Если Истина
			И Не ЭтоПеречисление
			И Элемент.Значение.Колонки.Найти("Активность") <> Неопределено
			И ДанныеСтроки.Активность = Ложь 
		Тогда
			ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
		КонецЕсли; 
		ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КП_Список.Кнопки.Идентификаторы);
	КонецЦикла;

КонецПроцедуры

Процедура КП_СписокОбработатьОбъекты(Кнопка)
	
	ирОбщий.ОткрытьПодборИОбработкуОбъектовИзТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура КП_СписокОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура ОбъектМетаданныхПриИзменении(Элемент)
	
	СохранитьНастройкиКолонок();
	ЭтаФорма.КлючУникальности = фОбъект.ОбъектМетаданных;
	Если УстановитьОбъектМетаданных() Тогда 
		ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ОбъектМетаданныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		лПолноеИмяОбъекта = Неопределено;
		Если ВыбранноеЗначение.Свойство("ПолноеИмяОбъекта", лПолноеИмяОбъекта) Тогда
			ОбъектМетаданных = ВыбранноеЗначение.ПолноеИмяОбъекта;
			ОбъектМетаданныхПриИзменении(Элемент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КП_СписокСколькоСтрок(Кнопка)
	
	ирОбщий.ТабличноеПолеИлиТаблицаФормы_СколькоСтрокЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	УстановитьОбъектМетаданных();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЗначениеТабличногоПоля = ЭлементыФормы.ДинамическийСписок.Значение;
	Попытка
		ПредставлениеОтбора = "" + ЗначениеТабличногоПоля.Отбор;
	Исключение
		ПредставлениеОтбора = "";
	КонецПопытки; 
	Если ПредставлениеОтбора = "" Тогда
		ПредставлениеОтбора = "нет";
	КонецЕсли; 
	ЭлементыФормы.НадписьОтбор.Заголовок = "Отбор: " + ПредставлениеОтбора;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанОбъект" Тогда
		Если ТипЗнч(Параметр) = Тип("Тип") Тогда
			ОбъектМД = Метаданные.НайтиПоТипу(Параметр);
		Иначе
			ОбъектМД = Метаданные.НайтиПоТипу(ТипЗнч(Параметр));
		КонецЕсли; 
		Если ОбъектМД <> Неопределено Тогда
			Если ОбъектМД.ПолноеИмя() = ОбъектМетаданных Тогда
				ЭлементыФормы.ДинамическийСписок.Значение.Обновить();
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДинамическийСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		Если ирОбщий.ПолучитьТипТаблицыБДЛкс(ОбъектМетаданных) = "Точки" Тогда
			Если ТипЗнч(ВыбраннаяСтрока) = Тип("Массив") Тогда
				Массив = Новый Массив;
				Для Каждого ЭлементМассива Из ВыбраннаяСтрока Цикл
					Массив.Добавить(ЭлементМассива.Ссылка);
				КонецЦикла;
			Иначе
				Массив = ВыбраннаяСтрока.Ссылка;
			КонецЕсли; 
			ВыбраннаяСтрока = Массив;
		КонецЕсли; 
		ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, ВыбраннаяСтрока);
		ОповеститьОВыборе(ВыбраннаяСтрока);
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокВыбратьНужноеКоличество(Кнопка)
	
	Количество = 10;
	Если Не ВвестиЧисло(Количество, "Введите количество", 6, 0) Тогда
		Возврат;
	КонецЕсли; 
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ВыделитьПервыеСтрокиДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, Количество);
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КП_СписокКопироватьСсылку(Кнопка)
	
	ТекущийЭлементФормы = ЭлементыФормы.ДинамическийСписок;
	ТекущаяСтрока = ТекущийЭлементФормы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.БуферОбмена_УстановитьЗначениеЛкс(ТекущаяСтрока);
	
КонецПроцедуры

Процедура КП_СписокЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.ДинамическийСписок.ОбновитьСтроки();
	
КонецПроцедуры

Процедура ДинамическийСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель = Неопределено, ЭтоГруппа = Неопределено)
	
	Ответ = Вопрос("Использовать редактор объекта БД?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписьНаСервере = ирОбщий.ПолучитьРежимЗаписиНаСервереПоУмолчаниюЛкс();
		ЗаписьНаСервере = Истина; // Для отладки
		Отказ = Истина;
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных);
		Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ирОбщий.ПолучитьПервыйФрагментЛкс(ОбъектМетаданных)) Тогда
			Если Копирование Тогда
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(ОбъектМетаданных, Элемент.ТекущаяСтрока,,, ЗаписьНаСервере);
				СтруктураОбъекта = ирОбщий.КопияОбъектаБДЛкс(СтруктураОбъекта);
			Иначе
				ЭтоГруппа = Ложь
					Или ЭтоГруппа = Истина
					Или (Истина
						И ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(ОбъектМД)
						И ЭлементыФормы.ДинамическийСписок.Значение.Отбор.ЭтоГруппа.Использование = Истина
						И ЭлементыФормы.ДинамическийСписок.Значение.Отбор.ЭтоГруппа.ВидСравнения = ВидСравнения.Равно
						И ЭлементыФормы.ДинамическийСписок.Значение.Отбор.ЭтоГруппа.Значение = Истина);
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(ОбъектМетаданных, ЭтоГруппа,,, ЗаписьНаСервере);
			КонецЕсли; 
			ирОбщий.УстановитьЗначенияРеквизитовПоОтборуЛкс(СтруктураОбъекта.Данные, ЭлементыФормы.ДинамическийСписок.Значение.Отбор);
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(СтруктураОбъекта);
		Иначе
			КлючОбъекта = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(ОбъектМетаданных, Ложь);
			Для Каждого КлючИЗначение Из КлючОбъекта Цикл
				Если Копирование Тогда
					КлючОбъекта[КлючИЗначение.Ключ] = Элемент.ТекущаяСтрока[КлючИЗначение.Ключ];
				КонецЕсли; 
			КонецЦикла;
			СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(ОбъектМетаданных, КлючОбъекта,,, ЗаписьНаСервере);
			ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(СтруктураОбъекта);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура КП_СписокСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПолеВводаКолонкиСписка_НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = ЭлементыФормы.ДинамическийСписок;
	Если СвязиИПараметрыВыбора Тогда
		ИмяПоляТаблицы = ТабличноеПоле.ТекущаяКолонка.Имя;
		ПоляТаблицыБД = ирКэш.ПолучитьПоляТаблицыБДЛкс(ОбъектМетаданных);
		МетаРеквизит = ПоляТаблицыБД.Найти(ИмяПоляТаблицы, "Имя").Метаданные;
		СтруктураОтбора = ирОбщий.ПолучитьСтруктуруОтбораПоСвязямИПараметрамВыбораЛкс(ТабличноеПоле.ТекущиеДанные, МетаРеквизит);
	КонецЕсли; 
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ТабличноеПоле, СтандартнаяОбработка,, Истина, СтруктураОтбора);

КонецПроцедуры

Процедура ПолеВводаКолонкиСписка_ОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	СохранитьНастройкиКолонок();
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КП_СписокРедакторОбъектаБДЯчейки(Кнопка)
	
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Функция Отбор() Экспорт 
	Возврат Отбор;
КонецФункции

Функция ПользовательскийОтбор() Экспорт 
	Возврат Отбор;
КонецФункции

Процедура КП_СписокОсновнаяФорма(Кнопка)
	
	Если Не ЗначениеЗаполнено(фОбъект.ОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли; 
	Если РежимВыбора Тогда
		Закрыть();
	КонецЕсли; 
	ДинамическийСписок = ЭлементыФормы.ДинамическийСписок.Значение;
	Попытка
		Отбор = ДинамическийСписок.Отбор;
	Исключение
		Отбор = Неопределено;
	КонецПопытки;
	Форма = ирОбщий.ОткрытьФормуСпискаЛкс(фОбъект.ОбъектМетаданных, Отбор, Ложь, ВладелецФормы, РежимВыбора, МножественныйВыбор, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
	Если Форма = Неопределено Тогда
		ЭтаФорма.Открыть();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВместоОсновнойПриИзменении(Элемент)
	
	ирОбщий.СохранитьЗначениеЛкс("ирДинамическийСписок.ВместоОсновной." + ОбъектМетаданных, фОбъект.ВместоОсновной);

КонецПроцедуры

Процедура КП_СписокСвязанныйРедакторОбъектаБДСтроки(Кнопка)

	Если ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	
КонецПроцедуры

Процедура ДинамическийСписокПриАктивизацииСтроки(Элемент)
	
	Если мСвязанныйРедакторОбъектаБД <> Неопределено И мСвязанныйРедакторОбъектаБД.Открыта() Тогда
		ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьСвязанныйРедакторОбъектаБДСтроки()
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок, ОбъектМетаданных,, Истина, мСвязанныйРедакторОбъектаБД);

КонецПроцедуры

Процедура КП_СписокРежимДерева(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	Если Кнопка.Пометка Тогда
		Попытка
			ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр = Истина;
		Исключение
		КонецПопытки;
	КонецЕсли;
	Попытка
		Если ЭлементыФормы.ДинамическийСписок.Дерево <> Кнопка.Пометка Тогда
			ЭлементыФормы.ДинамическийСписок.Дерево = Кнопка.Пометка;
		КонецЕсли;
	Исключение
	КонецПопытки;
	Попытка
		ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр = Истина;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура КП_СписокОбновить(Кнопка)
	
	ЭлементыФормы.ДинамическийСписок.Значение.Обновить();
	
КонецПроцедуры

Процедура КП_СписокСправкаМетаданного(Кнопка)
	
	ОткрытьСправку(Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных));
	
КонецПроцедуры

Процедура КП_СписокИмяСиноним(Кнопка)
	
	фОбъект.РежимИмяСиноним = Не Кнопка.Пометка;
	Кнопка.Пометка = фОбъект.РежимИмяСиноним;
	ирОбщий.НастроитьЗаголовкиАвтоТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, фОбъект.РежимИмяСиноним);
	
КонецПроцедуры

Процедура КП_СписокОткрытьОбъектМетаданных(Кнопка)
	
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(ОбъектМетаданных);
	
КонецПроцедуры

Процедура КП_СписокСброситьНастройкиКолонок(Кнопка)
	
	ирОбщий.СохранитьЗначениеЛкс("ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, Неопределено);
	УстановитьОбъектМетаданных();
	
КонецПроцедуры

Процедура КП_СписокСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокВывестиВТабличныйДокумент(Кнопка)
	
	ирОбщий.ВывестиСтрокиТабличногоПоляИПоказатьЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ирОбщий.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.ДинамическийСписок, , Кнопка);
	
КонецФункции

Процедура ОбъектМетаданныхОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(ОбъектМетаданных);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирДинамическийСписок.Форма.Форма");
Если КлючУникальности = "Связанный" Тогда
	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (связанный)";
КонецЕсли;
Построитель = Новый ПостроительЗапроса;
