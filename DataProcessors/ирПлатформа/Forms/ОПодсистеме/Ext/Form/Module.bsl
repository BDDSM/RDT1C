﻿
Процедура ПриОткрытии()
	
	ЭтаФорма.Автор = "Старых Сергей Александрович ( tormozit )";
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ЭтаФорма.НазваниеВарианта = "Портативные";
		ЭтаФорма.ИспользуемаяВерсия = НазваниеВарианта + " " + ирПортативный.мВерсия;
	Иначе
		ЭтаФорма.НазваниеВарианта = "Подсистема";
		ЭтаФорма.ИспользуемаяВерсия = НазваниеВарианта + " " + Метаданные.Подсистемы.ИнструментыРазработчика.Комментарий;
	КонецЕсли; 
	ИмяСервера = ирКэш.АдресСайтаЛкс();
	ЭлементыФормы.НадписьОсновнойВебСайт.Заголовок = ЭлементыФормы.НадписьОсновнойВебСайт.Заголовок + " " + ИмяСервера;
	ПодключитьОбработчикОжидания("ПолучитьАктуальнуюВерсиюОтложенно", 0.1, Истина);
	Если ЗначениеЗаполнено(КлючУникальности) Тогда
		СтрокаОписания = ПолучитьСтрокуОписанияИнструмента();
		Если СтрокаОписания = Неопределено Тогда
			Сообщить("Описание инструмента " + КлючУникальности + " не найдено");
			НазваниеИнструмента = КлючУникальности;
		Иначе
			НазваниеИнструмента = СтрокаОписания.Синоним;
			ЭлементыФормы.ОписаниеНаСайте.Доступность = Истина;
		КонецЕсли; 
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, НазваниеИнструмента, ". ");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПолучитьАктуальнуюВерсиюОтложенно()
	
	НазваниеНаСайте = "Инструменты разработчика " + НазваниеВарианта + " 1С 8.2";
	ИмяСервера = ирКэш.АдресСайтаЛкс();
	Соединение = Новый HTTPСоединение(ИмяСервера,,,, ирОбщий.ИнтернетПрокси());
	Запрос = Новый HTTPЗапрос("load/osnovnye/1");
	Попытка
		СтрокаОтвета = Соединение.Получить(Запрос);
	Исключение
		СтрокаОтвета = Неопределено;
	КонецПопытки; 
	Если СтрокаОтвета <> Неопределено Тогда
		ЧтениеHtml = Новый ЧтениеHTML;
		ЧтениеHtml.УстановитьСтроку(СтрокаОтвета.ПолучитьТелоКакСтроку());
		ПостроительDOM = Новый ПостроительDOM;
		ДокументHTML = ПостроительDOM.Прочитать(ЧтениеHTML);
		УзлыФайлов = ДокументHTML.ПолучитьЭлементыПоИмени("a");
		Для Каждого УзелФайла Из УзлыФайлов Цикл
			ТекстовоеСодержимое = НРег(УзелФайла.ТекстовоеСодержимое);
			Если Найти(ТекстовоеСодержимое, НРег(НазваниеНаСайте)) > 0 Тогда
				ЭтаФорма.АктуальнаяВерсия = НазваниеВарианта + " " + СокрЛП(СтрЗаменить(СтрЗаменить(ТекстовоеСодержимое, НРег(НазваниеНаСайте), ""), "v", ""));
				ЭтаФорма.СсылкаНаСтраницуСкачивания = УзелФайла.Гиперссылка;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли;
	ЭлементыФормы.КнопкаОбновить.Доступность = Истина
		И ЗначениеЗаполнено(АктуальнаяВерсия) 
		И Не ирОбщий.СтрокиРавныЛкс(ЭтаФорма.АктуальнаяВерсия, ИспользуемаяВерсия);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура Надпись2Нажатие(Элемент)
	
	ЗапуститьПриложение("http://" + ирКэш.АдресСайтаЛкс());
	
КонецПроцедуры

Процедура ОписаниеНаСайтеНажатие(Элемент)
	
	СтрокаОписания = ПолучитьСтрокуОписанияИнструмента();
	ЗапуститьПриложение("http://" + ирКэш.АдресСайтаЛкс() + "/" + СтрокаОписания.Описание);
	
КонецПроцедуры

Функция ПолучитьСтрокуОписанияИнструмента()
	
	СтрокаОписания = ПолучитьСписокИнструментов().Найти(КлючУникальности, "ПолноеИмя");
	Если СтрокаОписания = Неопределено И СтрЧислоВхождений(КлючУникальности, ".") > 1 Тогда
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(КлючУникальности);
		ПолноеИмяМД = ОбъектМД.Родитель().ПолноеИмя();
		СтрокаОписания = ПолучитьСписокИнструментов().Найти(ПолноеИмяМД, "ПолноеИмя");
	КонецЕсли; 
	Возврат СтрокаОписания;

КонецФункции

Процедура Надпись5Нажатие(Элемент)
	
	ЗапуститьПриложение("mailto:tormozit@mail.ru?subject=Инструменты разработчика " + ИспользуемаяВерсия);
	
КонецПроцедуры

Процедура ПорядокОписанияПроблемНажатие(Элемент)
	
	ЗапуститьПриложение("http://devtool1c.ucoz.ru/forum/2-2-1");
	
КонецПроцедуры

Процедура ОбновитьНажатие(Элемент)
	
	ИмяСервера = ирКэш.АдресСайтаЛкс();
	Соединение = Новый HTTPСоединение(ИмяСервера,,,, ирОбщий.ИнтернетПрокси());
	Запрос = Новый HTTPЗапрос(СсылкаНаСтраницуСкачивания);
	СтрокаОтвета = Соединение.Получить(Запрос);
	СсылкаНаСкачивание = Неопределено;
	Если СтрокаОтвета <> Неопределено Тогда
		ЧтениеHtml = Новый ЧтениеHTML;
		ЧтениеHtml.УстановитьСтроку(СтрокаОтвета.ПолучитьТелоКакСтроку());
		ПостроительDOM = Новый ПостроительDOM;
		ДокументHTML = ПостроительDOM.Прочитать(ЧтениеHTML);
		УзлыФайлов = ДокументHTML.ПолучитьЭлементыПоИмени("a");
		Для Каждого УзелФайла Из УзлыФайлов Цикл
			ТекстовоеСодержимое = НРег(УзелФайла.ТекстовоеСодержимое);
			Если Найти(ТекстовоеСодержимое, НРег("Скачать с сервера")) > 0 Тогда
				СсылкаНаСкачивание = УзелФайла.Гиперссылка;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли;
	Если СсылкаНаСкачивание = Неопределено Тогда
		ВызватьИсключение "Ссылка на скачивание не найдена"; 
	КонецЕсли; 
	Запрос = Новый HTTPЗапрос(СсылкаНаСкачивание);
	СтрокаОтвета = Соединение.Получить(Запрос);
	СсылкаНаСкачивание = СтрокаОтвета.Заголовки.Получить("Location");
	Запрос = Новый HTTPЗапрос(ирОбщий.РазделитьURLЛкс(СсылкаНаСкачивание).ПутьКФайлуНаСервере);
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		БазоваяФорма = ирПортативный.ПолучитьФорму();
		БазоваяФорма.Закрыть();
		Если БазоваяФорма.Открыта() Тогда 
			Возврат;
		КонецЕсли; 
		Ответ = Вопрос("При завершении обновления будет необходимо выполнить перезапуск клиентского приложения. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		ФайлКаталога = Новый Файл(ирПортативный.мКаталогОбработки);
		ИмяАрхиваСтаройВерсии = ФайлКаталога.Путь + "ИР " + ИспользуемаяВерсия + ".zip";
		АрхивированиеУспешно = Истина;
		Попытка
			ЗаписьZip = Новый ЗаписьZipФайла(ИмяАрхиваСтаройВерсии);
			ЗаписьZip.Добавить(ирПортативный.мКаталогОбработки + "*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
			ЗаписьZip.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
			АрхивированиеУспешно = Ложь;
		КонецПопытки;
		Если АрхивированиеУспешно Тогда
			Предупреждение("Используемая версия заархивирована в """ + ИмяАрхиваСтаройВерсии + """", 10);
		Иначе
			Ответ = Вопрос("При архивировании используемой версии возникла ошибка. Продолжить обновление?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ <> КодВозвратаДиалога.ОК Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли; 
		СтрокаОтвета = Соединение.Получить(Запрос);
		ДвоичныеДанные = СтрокаОтвета.ПолучитьТелоКакДвоичныеДанные();
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("zip");
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		ЧтениеZip = Новый ЧтениеZipФайла(ИмяВременногоФайла);
		ЧтениеZip.ИзвлечьВсе(ирПортативный.мКаталогОбработки, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		УдалитьФайлы(ИмяВременногоФайла);
		ЗавершитьРаботуСистемы(, Истина, "/Execute""" + ирПортативный.ИспользуемоеИмяФайла + """");
	Иначе
		Каталог = ирОбщий.ВыбратьКаталогВФормеЛкс(,, "Выберите каталог для сохранения файла подсистемы");
		Если Не ЗначениеЗаполнено(Каталог) Тогда
			Возврат;
		КонецЕсли; 
		СтрокаОтвета = Соединение.Получить(Запрос);
		ДвоичныеДанные = СтрокаОтвета.ПолучитьТелоКакДвоичныеДанные();
		ИмяФайла = Каталог + "\Инструменты разработчика " + АктуальнаяВерсия + ".CF";
		ДвоичныеДанные.Записать(ИмяФайла);
		Сообщить("Теперь выполните объединение конфигурации базы с """ + ИмяФайла + """");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИнформацияДляТехническойПоддержкиНажатие(Элемент)
	
	Текст = ИнформацияДляТехническойПоддержки();
	ирОбщий.ОткрытьТекстЛкс(Текст, "Информация для технической поддержки");
	
КонецПроцедуры

Функция ИнформацияДляТехническойПоддержки()
	
	//Платформа: 1С:Предприятие 8.3 (8.3.9.2033)
	//Конфигурация: Комплексная автоматизация, редакция 1.1 (1.1.20.1) (http://v8.1c.ru/ka/)
	//Copyright (С) ООО "1C", 2010-2012. Все права защищены
	//(http://www.1c.ru/)
	//Режим: Файловый (без сжатия)
	//Приложение: Тонкий клиент
	//Локализация: Информационная база: русский (Россия), Сеанс: русский (Россия)
	//Вариант интерфейса: Такси
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Текст = 
	"ОС: " + СистемнаяИнформация.ТипПлатформы + " " + СистемнаяИнформация.ВерсияОС + "
	|Платформа: " + СистемнаяИнформация.ВерсияПриложения + "
	|Конфигурация: " + Метаданные.Синоним + " (" + Метаданные.Версия + ")
	|Режим БД: " + ?(ирКэш.ЭтоФайловаяБазаЛкс(), "файловый", "клиент-серверный") + "
	|Приложение: " + ТекущийРежимЗапуска() + " " + ?(ирКэш.Это64битныйПроцессЛкс(), "64б", "32б") + "
	|Режим совместимости: " + Метаданные.РежимСовместимости + "
	|Инструменты разработчика: " + ИспользуемаяВерсия + "
	|";
	Возврат Текст;

КонецФункции

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ОПодсистеме");
