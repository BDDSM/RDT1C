﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Процедура ЗапуститьСеансПодПользователем(ИмяПользователяИнфобазы, ПарольПользователяИнфобазы, ИспользоватьAutomation = Ложь)

	Если ИспользоватьAutomation Тогда
		ирОбщий.СоздатьСеансИнфобазы1С8Лкс(, ИмяПользователяИнфобазы, ПарольПользователяИнфобазы, , Истина);
	Иначе
		//Если ирКэш.Получить().ВерсияПлатформы = 802015 Тогда 
		//	Предупреждение("В релиза 8.2.15 функция недоступна", 20); // Антибаг платформы 8.2.15
		//	Возврат;
		//КонецЕсли; 
		Если РежимЗапуска = "Авто" Тогда
			// Антибаг платформы. При передачи этого режима в явном виде в некоторых случаях пароль в командной строке игнорируется
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователяИнфобазы);
			Если ПользовательИБ.РежимЗапуска = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
				КонечнныйРежимЗапуска = "УправляемоеПриложениеТонкий";
			ИначеЕсли ПользовательИБ.РежимЗапуска = РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Тогда
				КонечнныйРежимЗапуска = "ОбычноеПриложение";
			Иначе //Авто
				Если Метаданные.ОсновнойРежимЗапуска = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
					КонечнныйРежимЗапуска = "УправляемоеПриложениеТонкий";
				Иначе
					КонечнныйРежимЗапуска = "ОбычноеПриложение";
				КонецЕсли;
			КонецЕсли;
		Иначе
			КонечнныйРежимЗапуска = РежимЗапуска;
		КонецЕсли; 
		ПараметрыЗапуска = ирОбщий.ПолучитьПараметрыЗапускаПриложения1СТекущейБазыЛкс(ИмяПользователяИнфобазы, ПарольПользователяИнфобазы, КодРазрешения, Ложь, КонечнныйРежимЗапуска,
			РазрешитьОтладку, ОчисткаКэшаКлиентСерверныхВызовов, ДополнительныеПараметры, СообщитьКоманднуюСтроку, , ОткрытьПортативныеИнструменты);
		ТекущаяДата = ирСервер.ПолучитьТекущуюДатуЛкс();
		Если КонечнныйРежимЗапуска = "УправляемоеПриложениеТонкий" Тогда
			СтрокаЗапуска = """" + КаталогПрограммы() + "1cv8c.exe""  " + ПараметрыЗапуска;
			ЗапуститьПриложение(СтрокаЗапуска);
		Иначе
			ЗапуститьСистему(ПараметрыЗапуска);
		КонецЕсли; 
		Состояние("Ожидание запуска сеанса...");
		Успех = Ложь;
		ДатаПоследнегоВопроса = ирСервер.ПолучитьТекущуюДатуЛкс();
		Пока Не Успех Цикл
			ОбработкаПрерыванияПользователя();
			Если ирСервер.ПолучитьТекущуюДатуЛкс() - ДатаПоследнегоВопроса >= 5 Тогда
				Ответ = Вопрос("Продолжить ожидание сеанса (5 сек)?", РежимДиалогаВопрос.ДаНет);
				Если Ответ = КодВозвратаДиалога.Нет Тогда
					Прервать;
				КонецЕсли;
				ДатаПоследнегоВопроса = ирСервер.ПолучитьТекущуюДатуЛкс();
			КонецЕсли; 
			Сеансы = ПолучитьСеансыИнформационнойБазы();
			Успех = Ложь;
			Для Каждого Сеанс Из Сеансы Цикл
				Если Истина
					И Сеанс.НачалоСеанса >= ТекущаяДата 
					И НРег(Сеанс.ИмяКомпьютера) = НРег(ИмяКомпьютера())
					И Сеанс.Пользователь <> Неопределено
					И НРег(Сеанс.Пользователь.Имя) = НРег(ИмяПользователяИнфобазы)
				Тогда
					Успех = Истина;
					Прервать;
				КонецЕсли; 
			КонецЦикла;
		КонецЦикла; 
	КонецЕсли; 

КонецПроцедуры

Функция УстановитьВременныйПарольПользователя() Экспорт
	
	мhash = ПользовательИБ.СохраняемоеЗначениеПароля;
	НужноВыставитьПароль = Ложь;
	НужноВернутьДомен = Ложь;
	Если ПользовательИБ.АутентификацияСтандартная = Ложь Тогда 
		ПользовательИБ.АутентификацияСтандартная = Истина;
		НужноВыставитьПароль = Истина;
	КонецЕсли;
	Если ПользовательИБ.АутентификацияОС = Истина Тогда 
		ПользовательИБ.АутентификацияОС = Ложь;
		НужноВернутьДомен = Истина;
	КонецЕсли;
	Пароль = Формат(ТекущаяДата(), "ДФ=HHmmss");
    ПользовательИБ.Пароль = Пароль;
	УдалитьРольРазработчикИР = Ложь;
	Если ВременноПредоставитьПравоРазработчикИР Тогда
		Если Не ПользовательИБ.Роли.Содержит(Метаданные.Роли.ирРазработчик) Тогда
			УдалитьРольРазработчикИР = Истина;
			ПользовательИБ.Роли.Добавить(Метаданные.Роли.ирРазработчик);
		КонецЕсли; 
	КонецЕсли; 
    ПользовательИБ.Записать();
	НаборПараметров = Новый Структура();
	НаборПараметров.Вставить("mHash", мhash);
	НаборПараметров.Вставить("НужноВыставитьПароль", НужноВыставитьПароль);
    НаборПараметров.Вставить("НужноВернутьДомен", НужноВернутьДомен);
	НаборПараметров.Вставить("ПользовательИБ", ПользовательИБ);
	НаборПараметров.Вставить("УдалитьРольРазработчикИР", УдалитьРольРазработчикИР);
	НаборПараметров.Вставить("Имя", ПользовательИБ.Имя);
	НаборПараметров.Вставить("Пароль", Пароль);
	Возврат НаборПараметров;
	
КонецФункции

Процедура ВернутьПостоянныйПарольПользователя(НаборПараметров = Неопределено) Экспорт;
	
	//УстановитьПривилегированныйРежим(Истина); 
	Если НЕ НаборПараметров = Неопределено Тогда
		мhash = НаборПараметров.mhash;
		НужноВыставитьПароль = НаборПараметров.НужноВыставитьПароль;
		НужноВернутьДомен = НаборПараметров.НужноВернутьДомен;
		ПользовательИБ = НаборПараметров.ПользовательИБ;
		УдалитьРольРазработчикИР = НаборПараметров.УдалитьРольРазработчикИР;
	Иначе
		Возврат;
	КонецЕсли;
	ПользовательИБ.СохраняемоеЗначениеПароля = мHash;
	Если НужноВыставитьПароль Тогда 
		Пользовательиб.АутентификацияСтандартная = Ложь; 
	КонецЕсли;
	Если НужноВернутьДомен Тогда 
		Пользовательиб.АутентификацияОС = Истина; 
	КонецЕсли;
	Если УдалитьРольРазработчикИР Тогда
		ПользовательИБ.Роли.Удалить(Метаданные.Роли.ирРазработчик);
	КонецЕсли; 
	ПользовательИБ.Записать();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	СтруктураПользователя = УстановитьВременныйПарольПользователя();
	Если СтруктураПользователя = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Попытка
		ЗапуститьСеансПодПользователем(СтруктураПользователя.Имя, СтруктураПользователя.Пароль, ИспользоватьAutomation);
	Исключение
		ВернутьПостоянныйПарольПользователя(СтруктураПользователя);
		ВызватьИсключение;
	КонецПопытки;
	ВернутьПостоянныйПарольПользователя(СтруктураПользователя);

КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.ИспользоватьAutomation.Доступность = ПравоДоступа("Automation", Метаданные, ПользовательИБ);
	Если ПользовательИБ <> Неопределено Тогда
		Заголовок = Заголовок + " " + ПользовательИБ.Имя;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДополнительныеПараметрыНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, "ирРедакторПользователей");

КонецПроцедуры

Процедура ДополнительныеПараметрыПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, "ирРедакторПользователей");

КонецПроцедуры

Процедура ИспользоватьAutomationПриИзменении(Элемент)
	
	ЭлементыФормы.ДополнительныеПараметры.Доступность = Не ИспользоватьAutomation;
	
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

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторПользователей.Форма.ЗапускПодПользователем");
ЭтаФорма.РежимЗапуска = "ОбычноеПриложение";
ЭтаФорма.РазрешитьОтладку = Истина;
ЭтаФорма.ВременноПредоставитьПравоРазработчикИР = Не ирКэш.ЛиПортативныйРежимЛкс();
ЭтаФорма.ОткрытьПортативныеИнструменты = ирКэш.ЛиПортативныйРежимЛкс();
ЭлементыФормы.ВременноПредоставитьПравоРазработчикИР.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
ЭлементыФормы.ОткрытьПортативныеИнструменты.Доступность = ирКэш.ЛиПортативныйРежимЛкс();