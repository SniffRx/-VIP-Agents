# [VIP] Agents - Модуль [VIP] Агенты из CSGO для вип меню R1KO

## Описание:
Хотели добавить что-то новое на сервер. Встречаем агентов с операций для плагина [VIP] CORE от R1KO.

## Функционал:
- Смена агентов через VIP меню
- Смена нашивок через VIP меню
- Вывод выбора нашивки или агентов (Показывает внизу по центру экрана картинку агента или нашивки)

## Требования

- <a href="https://hlmod.ru/resources/vip-core.245/">Ядро плагина - [VIP] Core версии не ниже 3.0 R</a>
- <a href="https://www.sourcemod.net/">Sourcemod 1.10+</a>
- Clientprefs (Имеется в папке scripting)
- <a href="https://github.com/SAZONISCHE/modelch">modelch</a>
- <a href="https://github.com/bcserv/smlib/tree/transitional_syntax">smlib</a>
- <a href="https://hlmod.ru/resources/fix-hint-color-messages.1416/">Fix Hint Color Messages</a>
- Для правильной работы плагина, рекомендуется скачать файлы перевода <a href="https://hlmod.ru/resources/vip-translations-vip-module.938/">[VIP] Translations Vip Module</a>
## Переменные
```
agents_time_view "0.3" - The time it takes to show the material to the player / Задержка показа картинки (агента | нашивки) для игрока
```
## Обязательные параметры в файл groups.ini

```
"Agents"          "1" | Разрешение на меню для агентов
"VIP_Agents_M"    "1" | Разрешение на вход в меню для вип агентов
(P.S) в конфигурационный файл вписываем только наименование и значения, коментарии (символ |) вписывать нельзя!!!
```

## Команды	

- !agents - открыть меню агентов
- В консоль agents или sm_agents - открыть меню агентов
- !vip - зайти в вип меню и выбрать пункт Меню Агентов
## Установка	

1. Установить все необходимые плагины и библиотеки для работоспособности плагина.
2. Скачать и раскинуть файлы по папкам.
3. FastDL загрузить на свой хостинг.
4. Перезапустить сервер.

## Примечание:

Файлы, которые нужно перекинуть в FastDL, должны иметь такой путь:
- (Для обычной загрузки)
 _`[папка с сервером/materials/panorama/images/icons/]`_
- (Для FastDL)
 _`[папка FastDL/materials/panorama/images/icons]`_
_`agents`_ - папка с агентами
_`patches`_ - папка с нашивками
_`patches/position`_ - папка с позицией нашивки игрока (NEW) Добавится в обновлении 2.0.2
Вы можете экспериментировать с файлами (менять можете всё что угодно, кроме названия и расширение файлов!!!)  

__Пример:__  
_`ctm_diver_varianta.png`_ - файл агента
_`4550.png`_ - файл нашивки

- Если у вас установлен "n_arms_fix.smx", то плагин не будет работать корректно! Если он вам необходим, то ставим этот! <a href="https://hlmod.ru/resources/linux-customplayerarms.2012/">[LINUX] CustomPlayerArms</a>
- Если у вас хостинг Myarena, то зайдите в (Discord -> Free Projects -> csgo_vip-agents) Там находится инструкция + файл для вас.

Ведётся разработка платного модуля [VIP] Agents+. (Discord -> http://discord.gg/gFnZ6u7Jpq)
