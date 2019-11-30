# FunCorpSteamApp
Приложение разработано для выполнения задания от FunCorp.
Приложение позволяет просматривать, и накапливать информацию о своем аккаунте в стим, и аккаунте друзей.

# Архитектура
Архитектура построена на основании опыта разворачивания модульных приложений, с учетом современных тенденций.
Разворачивал архитектуру не с нуля - существует мой проект, в котором выстроена таже архитектура, но почти была не протестировано. Поэтому время на поддержку некоторых архитектурных вещей всеравно пришлось потратить.
Архитектура построена с использованием SwiftPM, по этой причине при запуске проекта, будут закачены все внешние зависимости, что может потребовать некоторого времени.

### По слоям
Архитектура имеет деление на слои, где каждый слой подчиняется следующим правилам:
* модули одного слоя не имеют прямых ссылок друг на друга
* модуль из слоя N ничего не знает о выше стоящем модуле, то есть о модулях слоёв [1...N)
* модуль из слоя N может использовать любой нижлежащий слой, то есть модули слоёв (N...∞)
* Все модули могут использовать Common. Common не может использовать никого

0 слой - App
1 слой - Infrastructure/Network
1 слой - Infrastructure/Storage
1 слой - Infrastructure/ServicesImpl
1 слой - UIS/Modules
1.5 слой - UIS/UIComponents и UIS/Design
2 слой - Domain/Services.
3 слой - Core

### По модулям
* App - центральное приложение. В нем происходят индивидуальные настройки под каждое приложение, и проброска необходимых методов. Также в нем находится AppRouter который разруливает все переходы между экранами, и создает начальный экран.

* Infrastructure/Network - в этом модуле находится реализация всех сетевых методов приложения.
* Infrastructure/Storage - в этом модуле находится реализация всех запросов к хранилищу данных
* Infrastructure/ServiceImpl - В этом слое находится реализация бизнес логики.

* UIS/Modules - в папке хранятся индивидуальный модули, которые отвечают за UI. Все UI модули внутри соответствуют одной UI архитектуре, о которой чуть ниже.
* UIS/UIComponents - общие UI компоненты. Просто набор всяких вьюшек, и вью контроллеров.
* UIS/Design - хранятся базовые вещи необходимы для дизайна. И самое важное это стиль, который позволяет легко менять внешний вид приложения.

* Domain/Services - Содержит набор протоколов и данных. В идеале надо делить по функционалу и отдельно еще выделить Entities, но размеры приложения пока не те.

* Core - Содержит все основные возможности, необходимые для поддержания работы архитектуры - то есть на том что тут, строится архитектура.
* Common - Всяки прикладные классы (логи, локализация), различные расширения, и вспомогательные классы.

### Общее для каждого модуля

## Архитектура внутри UI модуля

# Зависимости
### DITranquillity
Библиотека для внедрения зависимостей. Я её автор, и я жить без нее не могу (на самом деле могу). Но без внедрения зависимостей сложнее придерживаться принципа DIP, особенно в модульном приложении.

### SwitLazy
Нужна для DITranquillity и позволяет легко отложить моменты создания того или иного экземпляра класса

# Steam API

# Планы

### Время
58 часа
