﻿Перем мТелоПозиционногоМетода;
Перем мТелоПоименногоМетода;
Перем ДатаИзмененияКонтекста Экспорт;
Перем мСтруктураВнешнейОбработки Экспорт;
Перем ИндивидуальнаяВнешняяОбработка Экспорт;

Функция ПолучитьСтартовуюСтрокуАлгоритмаВТексте() Экспорт 

	Возврат Параметры.Количество();

КонецФункции // ПолучитьСтартовуюСтрокуАлгоритмаВМодуле()

Функция ПолучитьСтартовуюСтрокуМетодаВМодуле() Экспорт 

	Результат = 1 + СтрЧислоСтрок(ПолучитьШапкуОпределенияМетода() + ПолучитьШапкуТелаМетода());
	Возврат Результат;

КонецФункции // ПолучитьСтартовуюСтрокуАлгоритмаВМодуле()

Функция ПолучитьОбъявлениеСлужебныхПеременных()

	МассивСлужебныхПеременных = Новый Массив;
	МассивСлужебныхПеременных.Добавить("ЭтотОбъект");
	МассивСлужебныхПеременных.Добавить("ИспользуемоеИмяФайла");
	МассивСлужебныхПеременных.Добавить("Результат");
	Разделитель = ", ";
	Результат = "";
	Для Каждого СлужебнаяПеременная Из МассивСлужебныхПеременных Цикл
		Результат = Результат + Разделитель + СлужебнаяПеременная;
	КонецЦикла;
	Результат = Сред(Результат, СтрДлина(Разделитель) + 1);
	Результат = "Перем " + Результат + ";";
	Возврат Результат;

КонецФункции // ПолучитьОбъявлениеСлужебныхПеременных()

Функция ПолучитьТекстМодуляОбработки() Экспорт 

	Результат = "";
	Результат = Результат + ПолучитьОпределениеМетода();
	Возврат Результат;

КонецФункции // ПолучитьТекстМодуляОбработки()

Функция ПолучитьОпределениеМетода(УниверсальныеИменаПараметров = Ложь) Экспорт 

	Результат = ПолучитьШапкуОпределенияМетода();
	Результат = Результат + ПолучитьТелоМетода() + Символы.ПС;
	Результат = Результат + Символы.Таб + "Возврат Результат;" + Символы.ПС;
	Результат = Результат + "КонецФункции" + Символы.ПС;
	Возврат Результат;

КонецФункции // ПолучитьОпределениеМетода()

Функция ПолучитьШапкуОпределенияМетода()

	Результат = "Функция мМетод(_АлгоритмОбъект, _Режим";
	Для Счетчик = 0 По 9 Цикл
		ИмяПараметра = "_П" + Счетчик;
		Результат = Результат + ", " + ИмяПараметра;
	КонецЦикла;
	Результат = Результат + ") Экспорт" + Символы.ПС;
	Результат = Результат + Символы.Таб + ПолучитьОбъявлениеСлужебныхПеременных();
	Возврат Результат;

КонецФункции // ПолучитьШапкуОпределенияМетода()

Функция ПолучитьШапкуТелаМетода()

	Результат = "";
	МассивТаблицПараметров = Новый Массив;
	Результат = Результат + "
	|	_Параметры = _АлгоритмОбъект.Параметры;";
	//Для Индекс = 0 ПО Параметры.Количество() - 1 Цикл
	//	СтрокаПеременной  = Параметры[Индекс];
	//	ИмяПеременной = СтрокаПеременной.Имя;
	//	Результат = Результат + "
	//	|		" + ИмяПеременной + " = ?(_П0.Свойство(""" + ИмяПеременной + """), _П0." + ИмяПеременной + ", _Параметры[" + Индекс + "].Значение);";
	//КонецЦикла;
	Результат = Результат + "
	|	Если _Режим = 0 Тогда";
	Для Индекс = 0 ПО Параметры.Количество() - 1 Цикл
		СтрокаПеременной  = Параметры[Индекс];
		Если Индекс < 10 Тогда
			ИмяПараметра = "_П" + Индекс;
		Иначе
			ИмяПараметра = "Null";
		КонецЕсли; 
		ИмяПеременной = СтрокаПеременной.Имя;
		Результат = Результат + "
		|		" + ИмяПеременной + " = ?(" + ИмяПараметра + " = Null, _Параметры[" + (Индекс) + "].Значение, "
			+ ИмяПараметра + ");";
	КонецЦикла;
	Результат = Результат + "
	|	Иначе";
	Для Индекс = 0 ПО Параметры.Количество() - 1 Цикл
		СтрокаПеременной  = Параметры[Индекс];
		ИмяПеременной = СтрокаПеременной.Имя;
		Результат = Результат + "
		|		" + ИмяПеременной + " = ?(_П0.Свойство(""" + ИмяПеременной + """), _П0." + ИмяПеременной + 
			", _Параметры[" + (Индекс) + "].Значение);";
	КонецЦикла;
	Результат = Результат + "
	|	КонецЕсли;";
		
	Результат = Результат + Символы.ПС + ирКэш.Получить().МаркерНачалаАлгоритма;
	Возврат Результат;

КонецФункции // ПолучитьШапкуТелаМетода()

Функция ПолучитьТелоМетода(Кэшировать = Ложь) Экспорт 

	Результат = ПолучитьШапкуТелаМетода();
	Для Сч1 = 1 По СтрЧислоСтрок(ТекстАлгоритма) Цикл
		Результат = Результат + Символы.Таб + СтрПолучитьСтроку(ТекстАлгоритма, Сч1) + Символы.ПС;
	КонецЦикла;
	Результат = Результат + ирКэш.Получить().МаркерКонцаАлгоритма;
	Результат = Результат + Символы.Таб + "; ~Конец:";
	
	//Для Каждого СтрокаПараметра Из Параметры Цикл
	//	Индекс = Параметры.Индекс(СтрокаПараметра);
	//	ИмяПеременной = СтрокаПараметра.Имя;
	//	Результат = Результат + "
	//	|		_П0." + ИмяПеременной + " = " + ИмяПеременной + ";";
	//КонецЦикла;
	Результат = Результат + "
	|	Если _Режим = 0 Тогда";
	Для Каждого СтрокаПараметра Из Параметры Цикл
		Индекс = Параметры.Индекс(СтрокаПараметра);
		Результат = Результат + "
		|		_П" + Индекс + " = " + СтрокаПараметра.Имя + ";";
	КонецЦикла;
	Результат = Результат + "
	|	Иначе";
	Для Каждого СтрокаПараметра Из Параметры Цикл
		Индекс = Параметры.Индекс(СтрокаПараметра);
		ИмяПеременной = СтрокаПараметра.Имя;
		Результат = Результат + "
		|		_П0.Вставить(""" + ИмяПеременной + """, " + ИмяПеременной + ");";
	КонецЦикла;
	Результат = Результат + "
	|	КонецЕсли;";
	
	Возврат Результат;

КонецФункции // ПолучитьТелоМетода()

Функция ПолучитьТекстМакетаПараметров() Экспорт 

	Возврат "";

КонецФункции // ПолучитьТекстМакетаПараметров()

Функция ВыполнитьЛокально(ТекстДляВыполнения, ЛиСинтаксическийКонтроль = Ложь) Экспорт

	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
	    мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Возврат мПлатформа.ВыполнитьЛокально(ТекстДляВыполнения);

КонецФункции // ВыполнитьЛокально()

Функция ПроверитьДанные() Экспорт 

	ДанныеКорректны = ирОбщий.ЛиПараметрыАлгоритмыКорректныЛкс(Параметры.Выгрузить(, "Имя"));
	Возврат ДанныеКорректны;

КонецФункции // ПроверитьДанные()

Процедура СобратьКонтекст() Экспорт 

	ДатаИзмененияКонтекста = ДатаИзменения;

КонецПроцедуры // ПрочитатьКонтекст()

Процедура ПередЗаписью(Отказ)
	
	Если Не ОбменДанными.Загрузка Тогда
		ДатаИзменения = ТекущаяДата();
		СобратьКонтекст();
		Отказ = Отказ Или Не ПроверитьДанные();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Не ОбменДанными.Загрузка Тогда
		мТекстАлгоритмаСПараметрами = "";
		мПлатформа = ирКэш.Получить();
		Если мПлатформа <> Неопределено Тогда
			#Если Клиент Тогда
			мПлатформа.ОбновитьАлгоритмВКеше(ЭтотОбъект);
			#КонецЕсли 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

ДатаИзмененияКонтекста = ДатаИзменения;
мТекстАлгоритмаСПараметрами = "";
ИндивидуальнаяВнешняяОбработка = Истина;
ОбменДанными = Новый Структура("Загрузка", Ложь);
