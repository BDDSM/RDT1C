﻿
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ВыбранныеУзлыПриемники = УзлыПриемники.Скопировать(Новый Структура("Пометка", Истина)).ВыгрузитьКолонку("Ссылка");
	ирОбщий.СкопироватьРаспределитьРегистрациюИзмененийПоУзламЛкс(УзелИсточник, ВыбранныеУзлыПриемники, ВариантКопирования = 1, , ОбъектыМД);
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	Закрыть();
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(Узлы, УзлыПриемники, , Новый Структура("Пометка", Ложь));
	
КонецПроцедуры

Процедура КоманднаяПанель1ДобавитьНесуществующийУзел(Кнопка)
	
	СтрокаУзла = УзлыПриемники.Добавить();
	СтрокаУзла.Ссылка = ПланыОбмена[ИмяПланОбмена].ПолучитьСсылку();
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторИзмененийПоПлануОбмена.Форма.ФормаВыбораОбъектовДляРегистрации");
