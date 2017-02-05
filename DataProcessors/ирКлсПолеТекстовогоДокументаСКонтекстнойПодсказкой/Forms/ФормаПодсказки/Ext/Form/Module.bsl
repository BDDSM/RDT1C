﻿Перем ЛиНазад;
Перем ЛиОбработкаСобытия;
Перем Запрос;
Перем СтруктураКлюча;
Перем ПодходящиеСлова;
Перем РазмерГруппы;
Перем СтрокаСловаРезультата Экспорт;
Перем СтруктураТипаКонтекста Экспорт;
Перем ВКОбщая Экспорт;

Процедура ПодходящиеСловаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтрокаСловаРезультата = ВыбраннаяСтрока;
	Закрыть(Истина);
	
КонецПроцедуры

Процедура НайтиПодходящиеСлова(ТекущееСлово, ЛиНашли, ПерваяПодходящаяСтрока)

	ЛиНашли = Ложь;
	ДлинаТекущегоСлова = СтрДлина(ТекущееСлово);
	СтрокаМаксимальногоРейтинга = Неопределено;
	// Здесь в таблицу ПодходящиеСлова можно добавить колонку ИндексСлово = Лев(НСлово, 3) для ускорения поиска
	Для Каждого СтрокаСлова Из ПодходящиеСлова Цикл
		НСлово = СтрокаСлова.НСлово;
		Если СтрДлина(НСлово) < ДлинаТекущегоСлова Тогда 
			Продолжить;
		КонецЕсли;
		Если Лев(СтрокаСлова.НСлово, ДлинаТекущегоСлова) = Нрег(ТекущееСлово) Тогда
			ЛиНашли = Истина;
			Если СтрокаМаксимальногоРейтинга <> Неопределено Тогда
				Если СтрокаМаксимальногоРейтинга.Рейтинг < СтрокаСлова.Рейтинг Тогда
					СтрокаМаксимальногоРейтинга = СтрокаСлова;
				КонецЕсли;
			Иначе
				СтрокаМаксимальногоРейтинга = СтрокаСлова;
				ПерваяПодходящаяСтрока = СтрокаСлова;
			КонецЕсли;
		ИначеЕсли ЛиНашли Тогда 
			Прервать; 
		ИначеЕсли СтрокаСлова.НСлово > ТекущееСлово Тогда 
			ПерваяПодходящаяСтрока = СтрокаСлова;
			Прервать; 
		КонецЕсли;
	КонецЦикла;
	Если СтрокаМаксимальногоРейтинга <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(СтруктураКлюча, СтрокаМаксимальногоРейтинга);
		НайденныеСтроки = ТаблицаСлов.НайтиСтроки(СтруктураКлюча);
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = НайденныеСтроки[0];
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры // НайтиПодходящиеСлова()

Процедура ПодобратьСтроку(ЛиПередОткрытием = Ложь, НачальнаяСтрока = Неопределено)
	
	Если ЛиОбработкаСобытия Тогда
		Возврат;
	КонецЕсли; 
	ЛиОбработкаСобытия = Истина;
	Если ЛиНазад Тогда
		Если НачальнаяСтрока = Неопределено Тогда
			НачальнаяСтрока = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		КонецЕсли; 
		// Найдем предыдущую максимальную общую часть подходящих слов
		Если НачальнаяСтрока <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, НачальнаяСтрока);
		Иначе
			СтруктураКлюча.Слово = ТекущееСлово;
			СтруктураКлюча.НСлово = НРег(ТекущееСлово);
			СтруктураКлюча.Рейтинг = -1;
		КонецЕсли; 
		НайденныеСтроки = ПодходящиеСлова.НайтиСтроки(СтруктураКлюча);
		Если НайденныеСтроки.Количество() > 0 Тогда
			СтрокаСлова = НайденныеСтроки[0];
			ДлинаОбщейЧасти = СтрДлина(ТекущееСлово) + 1;
			СимволОдинаковый = Истина;
			СледующееНСлово = "";
			Если ПодходящиеСлова.Индекс(СтрокаСлова) < ПодходящиеСлова.Количество() - 1 Тогда
				Для Индекс = ПодходящиеСлова.Индекс(СтрокаСлова) + 1 По ПодходящиеСлова.Количество() - 1 Цикл
					СледующееНСлово = ПодходящиеСлова[Индекс].НСлово;
					Если Лев(ПодходящиеСлова[Индекс].НСлово, ДлинаОбщейЧасти) <> Лев(СтрокаСлова.НСлово, ДлинаОбщейЧасти) Тогда 
						СимволОдинаковый = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			Если СимволОдинаковый Тогда
				СледующееНСлово = "";
			КонецЕсли;
				
			СимволОдинаковый = Истина;
			ПредыдущееНСлово = "";
			Если ПодходящиеСлова.Индекс(СтрокаСлова) > 0 Тогда
				Для Индекс = 1 По ПодходящиеСлова.Индекс(СтрокаСлова)  Цикл
					ПредыдущееНСлово = ПодходящиеСлова[ПодходящиеСлова.Индекс(СтрокаСлова) - Индекс].НСлово;
					Если Лев(ПодходящиеСлова[ПодходящиеСлова.Индекс(СтрокаСлова) - Индекс].НСлово, ДлинаОбщейЧасти) <>
						Лев(СтрокаСлова.НСлово, ДлинаОбщейЧасти)
					Тогда 
						СимволОдинаковый = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			Если СимволОдинаковый Тогда
				ПредыдущееНСлово = "";
			КонецЕсли;
			СимволОдинаковый = Ложь;
			Пока Истина Цикл
				Если ДлинаОбщейЧасти = 0 Тогда 
					СимволОдинаковый = Истина;
					Прервать;
				КонецЕсли;
				ДлинаОбщейЧасти = ДлинаОбщейЧасти - 1;
				ОчереднойСимвол = Сред(СтрокаСлова.НСлово, ДлинаОбщейЧасти, 1);
				Если Лев(СледующееНСлово, ДлинаОбщейЧасти) = Нрег(Лев(ТекущееСлово, ДлинаОбщейЧасти)) Тогда 
					СимволОдинаковый = Истина;
					Прервать;
				КонецЕсли;
				Если Лев(ПредыдущееНСлово, ДлинаОбщейЧасти) = Нрег(Лев(ТекущееСлово, ДлинаОбщейЧасти)) Тогда 
					СимволОдинаковый = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			ТекущееСлово = Лев(СтрокаСлова.Слово, ДлинаОбщейЧасти);
			
			ЛиНашли = Ложь;
			ПерваяПодходящаяСтрока = Неопределено;
			НайтиПодходящиеСлова(ТекущееСлово, ЛиНашли, ПерваяПодходящаяСтрока);
			СтрокаСлова = ПерваяПодходящаяСтрока;
			
			Если Не ЛиНашли Тогда
				ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Очистить();
			КонецЕсли;
		КонецЕсли; 
	Иначе
		ЛиНашли = Ложь;
		ПерваяПодходящаяСтрока = Неопределено;
		НайтиПодходящиеСлова(ТекущееСлово, ЛиНашли, ПерваяПодходящаяСтрока);
		СтрокаСлова = ПерваяПодходящаяСтрока;
		
		Если Не ЛиНашли Тогда
			ЛиОбработкаСобытия = Ложь;
			Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = Неопределено Тогда 
				ЛиНазад = Истина;
				ВременнаяСтрока = ПодходящиеСлова.Добавить();
				ВременнаяСтрока.Слово = ТекущееСлово;
				ВременнаяСтрока.НСлово = НРег(ВременнаяСтрока.Слово);
				ВременнаяСтрока.Рейтинг = -1;
				ПодходящиеСлова.Сортировать("НСлово");
				ПодобратьСтроку(, ВременнаяСтрока);
				ПодходящиеСлова.Удалить(ВременнаяСтрока);
			Иначе
				ТекущееСлово = Лев(ТекущееСлово, СтрДлина(ТекущееСлово) - 1);
			КонецЕсли;
		Иначе
			// Найдем максимальную общую часть подходящих слов
			ДлинаОбщейЧасти = СтрДлина(ТекущееСлово);
			ДлинаТекущегоСлова = ДлинаОбщейЧасти;
			СимволОдинаковый = Истина;
			НСлово = "";
			Пока Истина Цикл
				Если ДлинаОбщейЧасти > СтрДлина(СтрокаСлова.НСлово) Тогда 
					СимволОдинаковый = Ложь;
				КонецЕсли;
				Если Не СимволОдинаковый Тогда
					Прервать;
				КонецЕсли;
				ДлинаОбщейЧасти = ДлинаОбщейЧасти + 1;
				ОчереднойСимвол = Сред(СтрокаСлова.НСлово, ДлинаОбщейЧасти, 1);
				РазмерГруппы = 1;
				Для Индекс = ПодходящиеСлова.Индекс(СтрокаСлова) + 1 По ПодходящиеСлова.Количество() - 1 Цикл
					НСлово = ПодходящиеСлова[Индекс].НСлово;
					Если Лев(НСлово, ДлинаТекущегоСлова) <> Нрег(ТекущееСлово) Тогда 
						Прервать;
					КонецЕсли;
					РазмерГруппы = РазмерГруппы + 1;
					Если Сред(НСлово, ДлинаОбщейЧасти, 1) <> ОчереднойСимвол Тогда 
						СимволОдинаковый = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если Не СимволОдинаковый Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			ДлинаОбщейЧастиГруппы = ДлинаОбщейЧасти - СтрДлина(ТекущееСлово) - 1;
			ТекущееСлово = Лев(СтрокаСлова.Слово, ДлинаОбщейЧасти - 1);
			Если Истина
				И ДлинаОбщейЧастиГруппы > 0
				И ЛиПередОткрытием
			Тогда
				Если РазмерГруппы = 1 Тогда 
					СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
				Иначе 
					СтрокаСловаРезультата = Новый Структура("Слово, ТипСлова", ТекущееСлово);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ЛиОбработкаСобытия = Ложь;
	ЛиНазад = Ложь;

КонецПроцедуры // ПодобратьСтроку()

Процедура ЭлементУправленияTextBoxChange(Элемент)
	
	ПриИзмененииОтбора();
	
КонецПроцедуры

Процедура ОбработкаОбщихКлавиш(KeyCode)

	Если KeyCode.Value = 40 Тогда // {DOWN}
		Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено Тогда
			Смещение = + 1;
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока);
			ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
			НовыйИндекс = Мин(ИндексТекущейСтроки + Смещение, ПодходящиеСлова.Количество() - 1);
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
			ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = ТаблицаСлов.НайтиСтроки(СтруктураКлюча)[0];
		КонецЕсли;
	ИначеЕсли KeyCode.Value = 38 Тогда // {UP} 
		Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено Тогда
			Смещение = - 1;
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока);
			ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
			НовыйИндекс = Макс(ИндексТекущейСтроки + Смещение, 0);
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
			ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = ТаблицаСлов.НайтиСтроки(СтруктураКлюча)[0];
		КонецЕсли;
	ИначеЕсли KeyCode.Value = 34 Тогда // {PGDW} 
		Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено Тогда
			Смещение = + 20;
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока);
			ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
			НовыйИндекс = Мин(ИндексТекущейСтроки + Смещение, ПодходящиеСлова.Количество() - 1);
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
			ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = ТаблицаСлов.НайтиСтроки(СтруктураКлюча)[0];
		КонецЕсли;
	ИначеЕсли KeyCode.Value = 33 Тогда // {PGUP} 
		Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено Тогда
			Смещение = - 20;
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока);
			ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
			НовыйИндекс = Макс(ИндексТекущейСтроки + Смещение, 0);
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
			ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = ТаблицаСлов.НайтиСтроки(СтруктураКлюча)[0];
		КонецЕсли;
	ИначеЕсли KeyCode.Value = 13 Тогда // {ENTER} 
		Если Истина
			И ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено
			И ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Содержит(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока)
		Тогда 
			СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		Иначе
			СтрокаСловаРезультата = Новый Структура("Слово, ТипСлова", ТекущееСлово);
		КонецЕсли;
		Закрыть(Истина);
	ИначеЕсли KeyCode.Value = 187 Тогда // "=" 
		Если Истина
			И ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено
			И ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Содержит(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока)
		Тогда 
			СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		Иначе
			СтрокаСловаРезультата = Новый Структура("Слово, ТипСлова", ТекущееСлово);
		КонецЕсли;
		Закрыть(" = ");
	ИначеЕсли KeyCode.Value = 191 Тогда // "."
		ОткрытьДочерние();
	КонецЕсли;

КонецПроцедуры // ОбработкаОбщихКлавиш()

Процедура ОткрытьДочерние()

	Если Истина
		И ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено
		И ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Содержит(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока)
	Тогда 
		СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		Закрыть(".");
	КонецЕсли;

КонецПроцедуры // ОткрытьДочерние()

Процедура ЭлементУправленияTextBoxKeyDown(Элемент, KeyCode, Shift)
	
	Если KeyCode.Value = 8 Тогда // {BACKSPACE} 
		ЛиНазад = Истина;
	КонецЕсли;
	ОбработкаОбщихКлавиш(KeyCode);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
                
	ЛиНазад = Ложь;
	ЛиОбработкаСобытия = Истина;
	ИдентификаторКласса = "Forms.TextBox.1";
	Попытка
		Пустышка = Новый COMОбъект(ИдентификаторКласса);
	Исключение
		ИмяМакетаДополнительнойБиблиотеки = "FM20ENU";
		ИмяМакетаКомпоненты = "FM20";
		Пустышка = мПлатформа.ПолучитьCOMОбъектИзМакета(ИмяМакетаКомпоненты, ИдентификаторКласса,, ИмяМакетаДополнительнойБиблиотеки);
		Если Пустышка = Неопределено Тогда
			Отказ = Истина;
			Предупреждение("Для работы формы контекстной подсказки необходимо зарегистрировать библиотеки FM20.dll и FM20ENU.dll из состава MS Office 97-2007.
			|Это можно сделать с помощью формы ""Административная регистрация COM компонент"" из состава подсистемы");
			Возврат;
		КонецЕсли; 
	КонецПопытки; 
	ОтборПоСлову = ЭлементыФормы.ТаблицаСлов.ОтборСтрок.Слово;
	ОтборПоСлову.ВидСравнения = ВидСравнения.Содержит;
	ОтборПоСлову.Использование = Истина;
	
	ЛиОбработкаСобытия = Ложь;

	//НачальногоСловаНетВТаблице = ТаблицаСлов.Найти(НРег(ТекущееСлово), "НСлово") = Неопределено;
	//Если НачальногоСловаНетВТаблице Тогда
	//	// Если слово не равно ни одному из слов списка, то фильтр включаем
	//	ЭлементыФормы.ТаблицаСлов.ОтборСтрок.Слово.Значение = ТекущееСлово;
	//	НачальноеСлово = ТекущееСлово;
	//КонецЕсли; 
	ПодключитьОбработчикИзмененияДанных("ЭлементыФормы.ТаблицаСлов.Отбор", "ПриИзмененииОтбора", Истина);
		
	ПриИзмененииОтбора();
	ИспользоватьПромежуточныеДополнения = ВосстановитьЗначение(ИмяКласса + ".ИспользоватьПромежуточныеДополнения");
	Если ИспользоватьПромежуточныеДополнения <> Истина Тогда
		Если Истина
			И СтрокаСловаРезультата <> Неопределено
			И СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока 
		Тогда
			//Если НачальногоСловаНетВТаблице Тогда 
			//            ЭлементыФормы.ТаблицаСлов.ОтборСтрок.Слово.Значение = "";
			//            ТекущееСлово = НачальноеСлово;
			//            Если СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока Тогда
			//                           Отказ = Истина;
			//            КонецЕсли; 
			//Иначе
			Отказ = Истина;
			//КонецЕсли;
		КонецЕсли;
	Иначе
		Если СтрокаСловаРезультата <> Неопределено Тогда 
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	Если Отказ Тогда
		ОповеститьОВыборе(Истина); // Аналог Закрыть(), но Закрыть() нельзя здесь вызывать
	Иначе
		ВКОбщая = ирКэш.ВКОбщая();
		ОбработкаПрерыванияПользователя();
		ВКОбщая.ПолучитьПозициюКаретки();
	КонецЕсли; 

КонецПроцедуры

Процедура ПриОткрытии()
		
	Заголовок = Заголовок + Контекст;
	Если Ложь
		Или ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = Неопределено 
		Или Лев(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока.НСлово, СтрДлина(ТекущееСлово)) <> НРег(ТекущееСлово)
	Тогда 
		ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Очистить();
	КонецЕсли;
	ТипКонтекста = ирКэш.Получить().ПолучитьСтрокуКонкретногоТипа(СтруктураТипаКонтекста);
	ТекущийЭлемент = ЭлементыФормы.ЭлементУправленияTextBox;
	Если ВосстановитьЗначение(ИмяКласса + ".ВычислятьТипыВСписке") <> Истина И ЯзыкПрограммы = 0 Тогда
		ЭлементыФормы.ТаблицаСлов.Колонки.ТипЗначения.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура ПодходящиеСловаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если Лев(ДанныеСтроки.НСлово, СтрДлина(ТекущееСлово)) <> НРег(ТекущееСлово) Тогда 
		ОформлениеСтроки.ЦветТекста = WebЦвета.Коричневый;
	Иначе
		ОформлениеСтроки.Ячейки.КлючеваяБуква.УстановитьТекст(ВРег(Сред(ДанныеСтроки.НСлово, СтрДлина(ТекущееСлово) + 1, 1)));
	КонецЕсли;
	ЯчейкаКартинки = ОформлениеСтроки.Ячейки.Картинка;
	ЯчейкаКартинки.ОтображатьКартинку = Истина;
	ИндексКартинки = ирОбщий.ПолучитьИндексКартинкиСловаПодсказкиЛкс(ДанныеСтроки);
	Если ИндексКартинки >= 0 Тогда
		ЯчейкаКартинки.ИндексКартинки = ИндексКартинки;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриИзмененииОтбора(ИмяДанных = "")

	Если ЛиОбработкаСобытия Тогда
		Возврат;
	КонецЕсли;
	ЛиОбработкаСобытия = Истина;
	СписокФильтраПоТипуСлова = Новый СписокЗначений;
	Если ЭлементыФормы.ДействияФормы.Кнопки.НеМетоды.Пометка Тогда
		СписокФильтраПоТипуСлова.Добавить("Метод");
	КонецЕсли;
	Если ЭлементыФормы.ДействияФормы.Кнопки.НеСвойства.Пометка Тогда
		СписокФильтраПоТипуСлова.Добавить("Свойство");
	КонецЕсли;
	Если ЭлементыФормы.ДействияФормы.Кнопки.НеКлючевыеСлова.Пометка Тогда
		СписокФильтраПоТипуСлова.Добавить("Ключевое слово");
	КонецЕсли;
	ОтборПоТипуСлова = ЭлементыФормы.ТаблицаСлов.ОтборСтрок.ТипСлова;
	Если СписокФильтраПоТипуСлова.Количество() > 0 Тогда
		ОтборПоТипуСлова.ВидСравнения = ВидСравнения.НеВСписке;
		ОтборПоТипуСлова.Значение = СписокФильтраПоТипуСлова;
		ОтборПоТипуСлова.Использование = Истина;
	ИначеЕсли ОтборПоТипуСлова.ВидСравнения = ВидСравнения.НеВСписке Тогда 
		ОтборПоТипуСлова.Использование = Ложь;
	КонецЕсли;
	ВременнныйПостроительЗапроса = ирОбщий.ПолучитьПостроительТабличногоПоляСОтборомКлиентаЛкс(ЭлементыФормы.ТаблицаСлов);
	//ВременнныйПостроительЗапроса.Выполнить();
	ПодходящиеСлова = ВременнныйПостроительЗапроса.Результат.Выгрузить();
	ЛиОбработкаСобытия = Ложь;
	ПодобратьСтроку(Не Открыта());

КонецПроцедуры // ПриИзмененииОтбора()

Процедура ДействияФормыНеМетоды(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПриИзмененииОтбора();
	
КонецПроцедуры

Процедура ДействияФормыНеСвойства(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПриИзмененииОтбора();
	
КонецПроцедуры

Процедура ДействияФормыНеКлючевыеСлова(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПриИзмененииОтбора();
	
КонецПроцедуры

Процедура КоманднаяПанельФормыКонтекстнаяСправка(Кнопка)
	
	Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПутьКСлову = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока.Слово;
	Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока.ТипСлова = "Метод" Тогда
		ПутьКСлову = ПутьКСлову + "(";
	КонецЕсли;
	ОткрытьКонтекстнуюСправку(ПутьКСлову);
	
КонецПроцедуры

Процедура ПолеОтбораПоПодстрокеKeyDown(Элемент, KeyCode, Shift)

	ОбработкаОбщихКлавиш(KeyCode);
	
КонецПроцедуры

Процедура КоманднаяПанельФормыВнутрь(Кнопка)
	
	ОткрытьДочерние();
	
КонецПроцедуры

Процедура КнопкаОчисткиФильтраНажатие(Элемент)
	
	ЭлементыФормы.ПолеОтбораПоПодстроке.Значение = "";
	
КонецПроцедуры

Процедура ОткрытьОтладчик(Кнопка)
	
	ВызватьИсключение ирОбщий.ПолучитьПриглашениеОткрытьОтладчикЛкс();
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ЛиНазад = Ложь;
	ЛиОбработкаСобытия = Истина;
	ТекущееСлово = "";
	
КонецПроцедуры

Процедура ТаблицаСловПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Если ВКОбщая <> Неопределено Тогда
		ВКОбщая.ПереместитьОкноВПозициюКаретки();
		ВКОбщая = Неопределено;
	КонецЕсли; 

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Форма.ФормаПодсказки");

ЛиНазад = Ложь;
ЛиОбработкаСобытия = Истина;
СтруктураКлюча = Новый Структура;
Для Каждого КолонкаРезультата Из Метаданные().ТабличныеЧасти.ТаблицаСлов.Реквизиты Цикл
	СтруктураКлюча.Вставить(КолонкаРезультата.Имя);
КонецЦикла;
ПодходящиеСлова = ТаблицаСлов.ВыгрузитьКолонки();

// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
Попытка
	Пустышка = ЭлементыФормы.ПолеОтбораПоПодстроке.AutoSize;
Исключение
	Пустышка = Неопределено;
КонецПопытки;
Если Пустышка <> Неопределено Тогда
	ЭлементыФормы.ПолеОтбораПоПодстроке.Данные = "ЭлементыФормы.ТаблицаСлов.Отбор.Слово.Значение";
КонецЕсли; 
