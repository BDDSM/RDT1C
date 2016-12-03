﻿Перем мИмяСлужебногоПоля;
Перем мПредставленияТиповВыражений;
Перем ДиалектSQL Экспорт;
Перем ПараметрыДиалектаSQL;

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	Если Кнопка = ирОбщий.ПолучитьКнопкуКоманднойПанелиЭкземпляраКомпонентыЛкс(ПодсказкаПоляТекстаВыражения, "ПерейтиКОпределению") Тогда
		ТекущееВыражение = ПодсказкаПоляТекстаВыражения.ПолучитьТекущееОбъектноеВыражение();
		Если Лев(ТекущееВыражение, 1) = "&" Тогда
			ИмяПараметра = Сред(ТекущееВыражение, 2);
			ДоступныйПараметр = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных("ПараметрыДанных.ИмяПараметра"));
			Если ДоступныйПараметр <> Неопределено Тогда
				ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступныйПараметр;
				ПараметрСхемы = СхемаКомпоновки.Параметры.Найти(ирОбщий.ПолучитьПоследнийФрагментЛкс(ДоступныйПараметр.Поле));
				Если ПараметрСхемы <> Неопределено Тогда
					Если ПараметрСхемы.Выражение <> "" Тогда
						Попытка 
							ЗначениеПараметра = Вычислить(ПараметрСхемы.Выражение);
							ОткрытьЗначение(ЗначениеПараметра);
						Исключение
							ирОбщий.СообщитьСУчетомМодальностиЛкс("Ошибка при вычислении параметра """ + ПараметрСхемы.ИмяПараметра + """"
								+ Символы.ПС + ОписаниеОшибки(), МодальныйРежим, СтатусСообщения.Важное);
						КонецПопытки;
					Иначе
						ЗначениеПараметра = ПараметрСхемы.Значение;
						ОткрытьЗначение(ЗначениеПараметра);
					КонецЕсли;
				КонецЕсли; 
			КонецЕсли;
			Возврат;
		Иначе
			ДоступноеПоле = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных(ТекущееВыражение));
			Если ДоступноеПоле <> Неопределено Тогда
				ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступноеПоле;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	ПодсказкаПоляТекстаВыражения.Нажатие(Кнопка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКэш.Получить().ИнициализацияОписанияМетодовИСвойств();
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	ПодсказкаПоляТекстаВыражения.Инициализировать(,
		ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, ЭлементыФормы.КоманднаяПанельТекста,
		1, "ПроверитьВыражение", ЭтаФорма, "Выражение");
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
	СтрокаПредставленияТипаВыражения = мПредставленияТиповВыражений.НайтиПоЗначению(ТипВыражения);
	Если СтрокаПредставленияТипаВыражения <> Неопределено Тогда
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, СтрокаПредставленияТипаВыражения.Представление);
	КонецЕсли; 
	Если мДиалектыSQL <> Неопределено Тогда
		ПараметрыДиалектаSQL = мДиалектыSQL.Найти(ДиалектSQL, "Диалект");
		ЭлементыФормы.КПЗапросы.Кнопки.ПеренестиВоВременнуюТаблицу.Доступность = Истина
			И ПараметрыДиалектаSQL.ВременныеТаблицы 
			И ПараметрыДиалектаSQL.Пакет;
	КонецЕсли; 
	УстановитьСхемуКомпоновки();
	//мПлатформа = ирКэш.Получить();
	Если ирОбщий.СтрокиРавныЛкс(мДиалектSQL, "1С") Тогда
		СтруктураТипаКонтекста = мПлатформа.ПолучитьНовуюСтруктуруТипа();
		СтруктураТипаКонтекста.ИмяОбщегоТипа = "Локальный контекст";
		СписокСлов = мПлатформа.ПолучитьВнутреннююТаблицуПредопределенныхСлов(СтруктураТипаКонтекста,,,,1);
		//ТаблицаСлов = мПлатформа.ПолучитьВнутреннююТаблицуПредопределенныхСлов(СтруктураТипа, 1);
		Для Каждого СтрокаСлова Из СписокСлов Цикл
			Если Не ирОбщий.СтрокиРавныЛкс(СтрокаСлова.ТипСлова, "Метод") Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаФункции = ТаблицаФункций.Добавить();
			СтрокаФункции.Функция = СтрокаСлова.Слово;
			СтрокаФункции.СтруктураТипа = СтрокаСлова.ТаблицаСтруктурТипов[0];
		КонецЦикла;
	КонецЕсли; 
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли;
	ЭлементыФормы.ПолеТекстаВыражения.УстановитьТекст(Выражение);
	КоманднаяПанельТекстаОбновитьЗапросы();

КонецПроцедуры

Функция УстановитьСхемуКомпоновки()
	
	ТекстПроверочногоЗапроса = ПолучитьТекстПроверочногоЗапроса(, Истина);
	Если ТекстПроверочногоЗапроса = Неопределено Тогда
		ОбновитьКонтекстнуюПодсказку();
		Возврат Неопределено;
	КонецЕсли;
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = ирОбщий.ДобавитьЛокальныйИсточникДанныхЛкс(СхемаКомпоновки);
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	НаборДанных.Запрос = ТекстПроверочногоЗапроса;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	ПолеНабора = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	ПолеНабора.Поле = мИмяСлужебногоПоля;
	ПолеНабора.ПутьКДанным = мИмяСлужебногоПоля;
	ПолеНабора.ОграничениеИспользования.Условие = Истина;
	Если Параметры = Неопределено Тогда
		ирОбщий.СообщитьСУчетомМодальностиЛкс("Не передана таблица параметров", МодальныйРежим, СтатусСообщения.Внимание);
		Возврат Неопределено;
	КонецЕсли; 
	Для Каждого CтрокаПараметра Из Параметры Цикл
		ПараметрСхемы = СхемаКомпоновки.Параметры.Добавить();
		ПараметрСхемы.Имя = CтрокаПараметра.Имя;
		ПараметрСхемы.ТипЗначения = CтрокаПараметра.ТипЗначения;
	КонецЦикла;
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	Исключение
		ОписаниеОшибки = ОписаниеОшибки(); // Чтобы в отладчике сразу была понятна причина ошибки
	КонецПопытки; 
	ОбновитьКонтекстнуюПодсказку();
	
КонецФункции

Процедура ОбновитьКонтекстнуюПодсказку()
	
	ПодсказкаПоляТекстаВыражения.ОчиститьТаблицуСловЛокальногоКонтекста();
	Для Каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.Элементы Цикл
		НрегПервыйФрагмент = ирОбщий.ПолучитьПервыйФрагментЛкс(НРег(ДоступноеПоле.Поле));
		Если НрегПервыйФрагмент = НРег("ПараметрыДанных") Тогда
			Для Каждого ДоступныйПараметр Из ДоступноеПоле.Элементы Цикл
				ИмяСвойства = ПараметрыДиалектаSQL.ПрефиксПараметра + ирОбщий.ПолучитьПоследнийФрагментЛкс(ДоступныйПараметр.Поле);
				ПодсказкаПоляТекстаВыражения.ДобавитьСловоЛокальногоКонтекста(ИмяСвойства, "Свойство", , ДоступныйПараметр,,,, "СтрокаТаблицы");
			КонецЦикла; 
		Иначе
			ПодсказкаПоляТекстаВыражения.ДобавитьСловоЛокальногоКонтекста("" + ДоступноеПоле.Поле, "Свойство",, ДоступноеПоле,,,, "СтрокаТаблицы");
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	ПодсказкаПоляТекстаВыражения.Уничтожить();
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция СохранитьИзменения()

	Если Не ПодсказкаПоляТекстаВыражения.ПроверитьПрограммныйКод() Тогда 
		Ответ = Вопрос("Выражение содержит ошибки. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли; 
	Текст = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	Если Не МодальныйРежим Тогда
		ирОбщий.ПоместитьТекстВБуферОбменаОСЛкс(Текст);
	КонецЕсли;
	Модифицированность = Ложь;
	Закрыть(Текст);
	Возврат Истина;

КонецФункции // СохранитьИзменения()

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	СохранитьИзменения();
	
КонецПроцедуры

// Выполняет программный код в контексте.
//
// Параметры:
//  ТекстДляВыполнения – Строка;
//  *ЛиСинтаксическийКонтроль - Булево, *Ложь - признак вызова только для синтаксического контроля.
//
Функция ПроверитьВыражение(ТекстДляПроверки, ЛиСинтаксическийКонтроль = Ложь) Экспорт
	
	Если мДиалектSQL = "1С" Тогда
		ПроверочныйЗапрос = Новый Запрос;
		ПроверочныйЗапрос.Текст = ПолучитьТекстПроверочногоЗапроса(ТекстДляПроверки);
		ПроверочныйЗапрос.НайтиПараметры(); // Здесь будет возникать ошибка
	КонецЕсли; 
	КоманднаяПанельТекстаОбновитьЗапросы();

КонецФункции // ВычислитьВФорме()

Функция ПолучитьТекстПроверочногоЗапроса(Знач ТекстДляПроверки = "", ДляСхемы = Ложь)
	
	Если Истина
		И ДляСхемы
		И КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.Элементы.Количество() > 0
	Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(ТекстДляПроверки) Тогда
		ТекстДляПроверки = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	КонецЕсли; 

	Если ТипВыражения = "ПараметрВиртуальнойТаблицы" Тогда
		Если Не ЗначениеЗаполнено(ШаблонПолноеИмяТаблицы) Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонПолноеИмяТаблицы""";
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(ШаблонНомерПараметра) Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонНомерПараметра""";
		КонецЕсли; 
		Запятые = ирОбщий.ПолучитьСтрокуПовторомЛкс(",", ШаблонНомерПараметра - 1);
		ТекстЗапроса = "ВЫБРАТЬ 1 КАК " + мИмяСлужебногоПоля + " ИЗ " + ШаблонПолноеИмяТаблицы + "(" + Запятые + "
		|" + ТекстДляПроверки + "
		|) КАК Т";
	ИначеЕсли ТипВыражения = "УсловиеОтбора" Тогда
		Если ШаблонТекстИЗ = Неопределено Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонТекстИЗ""";
		КонецЕсли; 
		Если Истина
			И ДляСхемы
			И Не ЗначениеЗаполнено(ТекстДляПроверки) 
		Тогда
			ТекстДляПроверки = "1=1";
		КонецЕсли; 
		ТекстЗапроса = "ВЫБРАТЬ * ";
		Если ЗначениеЗаполнено(ШаблонТекстИЗ) Тогда
			ТекстЗапроса = ТекстЗапроса + "ИЗ " + ШаблонТекстИЗ;
		КонецЕсли; 
		ТекстЗапроса = ТекстЗапроса + " ГДЕ 
		|(" + ТекстДляПроверки + ")";
	ИначеЕсли ТипВыражения = "ВыбранноеПоле" Тогда
		Если ШаблонТекстИЗ = Неопределено Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонТекстИЗ""";
		КонецЕсли; 
		Если Истина
			И ДляСхемы
			И Не ЗначениеЗаполнено(ТекстДляПроверки) 
		Тогда
			ТекстДляПроверки = "1";
		КонецЕсли; 
		ТекстЗапроса = "ВЫБРАТЬ 
		|(" + ТекстДляПроверки + ") 
		|КАК " + мИмяСлужебногоПоля + " ";
		Если ЗначениеЗаполнено(ШаблонТекстИЗ) Тогда
			ТекстЗапроса = ТекстЗапроса + "ИЗ " + ШаблонТекстИЗ;
		КонецЕсли; 
	ИначеЕсли ТипВыражения = "ПолеИтога" Тогда
		//Если Не ЗначениеЗаполнено(ШаблонТекстЗапроса) Тогда
		//	ВызватьИсключение "Не задан параметр ""ШаблонТекстЗапроса""";
		//КонецЕсли; 
		//ТекстЗапроса = ШаблонТекстЗапроса + " ИТОГИ
		ТекстЗапроса = "ВЫБРАТЬ 1 КАК " + мИмяСлужебногоПоля + " ИТОГИ
		|(" + ТекстДляПроверки + ")
		| КАК " + мИмяСлужебногоПоля + " ПО ОБЩИЕ";
	Иначе
		ТекстЗапроса = "";
	КонецЕсли; 
	Возврат ТекстЗапроса;

КонецФункции

Процедура ДоступныеПоляНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	НрегПервыйФрагмент = ирОбщий.ПолучитьПервыйФрагментЛкс(НРег(Элемент.ТекущаяСтрока.Поле));
	Если НрегПервыйФрагмент = НРег("ПараметрыДанных") Тогда
		ПараметрыПеретаскивания.Значение = ПараметрыДиалектаSQL.ПрефиксПараметра + ирОбщий.ПолучитьПоследнийФрагментЛкс(Элемент.ТекущаяСтрока.Поле);
	ИначеЕсли Истина
		И ТипВыражения <> "ПолеИтога"
		И НрегПервыйФрагмент = НРег("СистемныеПоля") 
	Тогда
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.НеОбрабатывать;
	Иначе
		ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Поле;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТекстаСсылкаНаОбъектБД(Кнопка)
	
	//ПолеВстроенногоЯзыка.ВставитьСсылкуНаОбъектБД(СхемаКомпоновки, "");
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Ответ = Вопрос("Выражение было изменено. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Отказ = Не СохранитьИзменения();
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КонтекстноеМенюФункцийСинтаксПомощник(Кнопка)
	
	ТекущаяСтрокаФункций = ЭлементыФормы.ТаблицаФункций.ТекущаяСтрока;
	Если ТекущаяСтрокаФункций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтруктураТипа = ТекущаяСтрокаФункций.СтруктураТипа;
	Если СтруктураТипа <> Неопределено Тогда
		СтрокаОписания = СтруктураТипа.СтрокаОписания;
		Если СтрокаОписания <> Неопределено Тогда
			ирОбщий.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОписания.ПутьКОписанию, , ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаФункцийНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Функция + "()";
	
КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ирОбщий.ПриПолученииДанныхДоступныхПолейКомпоновкиЛкс(ОформленияСтрок);

КонецПроцедуры // ПриПолученииДанныхДоступныхПолей()

Процедура КоманднаяПанельТекстаОбновитьЗапросы(Кнопка = Неопределено)
	
	//ТекстПроверочногоЗапроса = ПолучитьТекстПроверочногоЗапроса();
	ТекстВыражения = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	Если ПустаяСтрока(ТекстВыражения) Тогда
		ТекстВыражения = "1";
	КонецЕсли; 
	ТекстПроверочногоЗапроса = "ВЫБРАТЬ 
	|" + ТекстВыражения;
	СлужебноеПолеТекстовогоДокумента.УстановитьТекст(ТекстПроверочногоЗапроса);
	НачальныйТокен = РазобратьТекстЗапроса(ТекстПроверочногоЗапроса, Истина); // Возможно здесь тоже придется включить полное, а не сокращенное дерево
	Запросы.Очистить();
	Если НачальныйТокен <> Неопределено Тогда
		ЗаполнитьСписокЗапросовПоТокену(НачальныйТокен);
	КонецЕсли; 
	
КонецПроцедуры

Функция ЗаполнитьСписокЗапросовПоТокену(Знач Токен) Экспорт
	
	Данные = Токен.Data;
	Если Данные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ИмяПравила = Данные.ParentRule.RuleNonterminal.Text;
	Если ИмяПравила = "<EmbeddedRoot>" Тогда
		CтрокаЗапроса = Запросы.Добавить();
		CтрокаЗапроса.Номер = Запросы.Количество();
		CтрокаЗапроса.Текст = ПолучитьТекстИзТокена(Токен, CтрокаЗапроса.НачальнаяСтрока, CтрокаЗапроса.НачальнаяКолонка,
			CтрокаЗапроса.КонечнаяСтрока, CтрокаЗапроса.КонечнаяКолонка);
	Иначе
		Для ИндексТокена = 0 По Данные.TokenCount - 1 Цикл
			ТокенВниз = Данные.Tokens(Данные.TokenCount - 1 - ИндексТокена);
			Если ТокенВниз.Kind = 0 Тогда
				ПсевдонимСнизу = ЗаполнитьСписокЗапросовПоТокену(ТокенВниз);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	
КонецФункции

Процедура ЗапросыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	КонструкторВложенногоЗапроса = ПолучитьКонструкторВложенногоЗапроса(ВыбраннаяСтрока);
	РезультатФормы = КонструкторВложенногоЗапроса.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		ЭлементыФормы.ПолеТекстаВыражения.УстановитьГраницыВыделения(ВыбраннаяСтрока.НачальнаяСтрока - 1, ВыбраннаяСтрока.НачальнаяКолонка,
			ВыбраннаяСтрока.КонечнаяСтрока - 1, ВыбраннаяСтрока.КонечнаяКолонка);
		ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст = КонструкторВложенногоЗапроса.Текст;
		КоманднаяПанельТекстаОбновитьЗапросы();
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьКонструкторВложенногоЗапроса(Знач ВыбраннаяСтрока)
	
	КонструкторВложенногоЗапроса = ПолучитьФорму("КонструкторЗапроса");
	ЗагрузитьТекстВКонструктор(ВыбраннаяСтрока.Текст, КонструкторВложенногоЗапроса);
	Если КонструкторЗапроса <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(КонструкторВложенногоЗапроса, КонструкторЗапроса, "РасширеннаяПроверка, Английский1С, ТабличноеПолеКорневогоПакета, ПоказыватьИндексы");
	КонецЕсли;
	Возврат КонструкторВложенногоЗапроса;

КонецФункции

Процедура КПЗапросыПеренестиВоВременнуюТаблицу(Кнопка)

	ВыбраннаяСтрока = ЭлементыФормы.Запросы.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КонструкторВложенногоЗапроса = ПолучитьКонструкторВложенногоЗапроса(ВыбраннаяСтрока);
	Если Не КонструкторЗапроса.ЛиПакетныйЗапрос Тогда
		КонструкторЗапроса.ЛиПакетныйЗапрос = Истина;
		КонструкторЗапроса.ЛиПакетныйЗапросПриИзменении();
	КонецЕсли; 
	ЗапросПакета = КонструкторЗапроса.ЗапросыПакета.Вставить(КонструкторЗапроса.ЗапросыПакета.Индекс(КонструкторЗапроса.ЭлементыФормы.ЗапросыПакета.ТекущаяСтрока));
	ЗаполнитьЗначенияСвойств(ЗапросПакета, КонструкторВложенногоЗапроса.ЗапросыПакета[0]);
	КонструкторЗапроса.ОбновитьНаименованиеЗапроса(ЗапросПакета);
	ЗапросПакета.ТипЗапроса = 1;
	ЗапросПакета.ИмяОсновнойТаблицы = мПлатформа.ПолучитьИдентификаторИзПредставления(ЗапросПакета.Имя);
	КонструкторЗапроса.ОбновитьДоступныеВременныеТаблицы();
	ТекстВыбор = "";
	Для Каждого ВыбранноеПоле Из ЗапросПакета.ЧастиОбъединения[0].ВыбранныеПоля Цикл
		Если ТекстВыбор <> "" Тогда
			ТекстВыбор = ТекстВыбор + ", ";
		КонецЕсли; 
		ТекстВыбор = ТекстВыбор + ЗапросПакета.ИмяОсновнойТаблицы + "." + ВыбранноеПоле.Имя;
	КонецЦикла; 
	ЭлементыФормы.ПолеТекстаВыражения.УстановитьГраницыВыделения(ВыбраннаяСтрока.НачальнаяСтрока - 1, ВыбраннаяСтрока.НачальнаяКолонка,
		ВыбраннаяСтрока.КонечнаяСтрока - 1, ВыбраннаяСтрока.КонечнаяКолонка);
	ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст = 
		КонструкторЗапроса.ПолучитьСловоЯзыкаЗапросов("SELECT") + " " + ТекстВыбор + " " + КонструкторЗапроса.ПолучитьСловоЯзыкаЗапросов("FROM") + " " 
		+ ЗапросПакета.ИмяОсновнойТаблицы + " " + КонструкторЗапроса.ПолучитьСловоЯзыкаЗапросов("AS") + " " + ЗапросПакета.ИмяОсновнойТаблицы;
	КоманднаяПанельТекстаОбновитьЗапросы();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

ирОбщий.ПодключитьОбработчикиСобытийДоступныхПолейКомпоновкиЛкс(ЭлементыФормы.ДоступныеПоля);

Запросы.Колонки.Добавить("НачальнаяКолонка", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("НачальнаяСтрока", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("КонечнаяКолонка", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("КонечнаяСтрока", Новый ОписаниеТипов("Число"));
ЭтаФорма.ТипВыражения = "Параметр";
мПредставленияТиповВыражений = Новый СписокЗначений;
мПредставленияТиповВыражений.Добавить("УсловиеОтбора", "Отбор");
мПредставленияТиповВыражений.Добавить("ПараметрВиртуальнойТаблицы", "Параметр таблицы");
мПредставленияТиповВыражений.Добавить("УсловиеСвязи", "Связь таблиц");
мПредставленияТиповВыражений.Добавить("ВыбранноеПоле", "Выбранное поле");
мПредставленияТиповВыражений.Добавить("Группировка", "Группировка");
мПредставленияТиповВыражений.Добавить("ПолеИтога", "Итоги");

ТаблицаФункций.Колонки.Добавить("СтруктураТипа");
мИмяСлужебногоПоля = "_СлужебноеПоле48198";

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Форма.КонструкторВыраженияЗапроса");
