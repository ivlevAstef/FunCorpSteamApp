# FunCorpSteamApp
Приложение разработано для выполнения задания от FunCorp.
Приложение позволяет просматривать, и накапливать информацию о своем аккаунте в стим, и аккаунте друзей.

В задании требовалось сделать детализацию для одной из игр - в качестве этой игры выбрана Dota2.
Экран статистики (4 пункт) также сделан только для Dota2, но общая статистика накапливается и хранится история, и в будущем никто не мешает добавить визуализацию, для общей статистики - данные уже собираются.

Для ios13 поддержана белая и темная тема. При этом поддержка кастомной цветой/шрифтовой схемы не составляет труда.

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
1.5 слой - можно объединить в одно название UICore: UIS/AppUIComponents -> UIS/UIComponents -> UIS/Design
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

* Domain/Services - Содержит набор протоколов и данных. В идеале надо делить по функционалу (AuthServices, ProfileService...) и отдельно выделить Entities, но размеры приложения пока не те.

* Core - Содержит все основные возможности, необходимые для поддержания работы архитектуры - то есть на том что тут, строится архитектура.
* Common - Всяки прикладные классы (логи, локализация), различные расширения, и вспомогательные классы.

### UI модули
* Menu - В данном случае это TabBar. Но при желании может легко заменится, на любой другой способ, без необходимости правки других модулей.
* Auth - Модуль в котором находится все что нужно для авторизации.
* Profile - Модуль в котором находится работа с профилями. Это как сам экран профиля, так и список друзей.
* Sessions - Модуль в котором находится список последних игр.
* GameInformation - Самый большой модуль - тут экран Информации по игре, и экран статистики (пока только по игре Dota2). Также есть кастомизация для игры Dota2.
* News - просто модуль с пустым экраном. Вначале планировал сделать вкладку с новостями. Не убрал просто, из-за того что две вкладки ну совсем уныло выглядят :D

### Общее для каждого модуля
Все модули имеют StartPoint - точка запуска. В этой точке обязательно есть правила для внедрения зависимостей, и возможность какой либо конфигурации каждого модуля.
Для UI модулей, также есть StartPoint, но она более сложная, и в нее дополнительно входят правила для переходов (в том числе потенциально возможно поддержка deeplinks, без танцев с бубнами), и инициализация начального роутера, для возможности дальнейшей навигации внутри модуля.

## Архитектура внутри UI модуля
Внутри UI модуля, используются следующие общие имена:
Router - класс отвечающий за навигирование между экранами. Этот класс знает обо всех экранах внутри модуля, но экраны о нем ничего не знают.
Screen - простой Generic класс, позволяющий убрать явную зависимость view на presenter, оставив только ссылку из presenter на view.
ScreenView - правила визуальной работы с экраном. Является наследником UIViewController. Внутри обычно содержит ссылку на какую-то конкретную view. 
ScreenPresenter - отвечает за преобразование данных от сервисов, к ViewModel-ям (ничего общего с MVVM не имеют), и реализует логику реагирования на нажатия.

Вся бизнес логика уходит уже в Services.
Для взаимосвязи между классами используется базовый механизм: Notifier. По факту это closure/observer с небольшими наворотами.

# Зависимости
### Realm и RealmCore
Используется для хранения данных. Выбрал эту так как с ней проще всего работать, и она по заданию разрешена

### Charts
Для отображения графиков. Просто самая популярная, и то, что мне нужно умеет.
Возможно в дальнейшем, можно будет использовать гораздо больше её возможностей, но в рамках задачи используется малая часть.


### DITranquillity
Библиотека для внедрения зависимостей. Я её автор, и я жить без нее не могу (на самом деле могу). Но без внедрения зависимостей сложнее придерживаться принципа DIP, особенно в модульном приложении.

### SwitLazy
Нужна для DITranquillity. Позволяет легко отложить моменты создания того или иного экземпляра класса

# Steam API
Детально его можно легко посмотреть в модуле Network:
* https://steamcommunity.com/openid/login - авторизация реализована с помощью webview, и openid.
* ISteamUser/GetPlayerSummaries/v2 - подробная информации о профиле по steamid.
* ISteamUser/GetFriendList/v1 - информация о друзья профиля по steamid. Логика когда сервер их отдает или нет, до конца не ясна - но видимость профиля не влияет...
* IPlayerService/GetOwnedGames/v1 - список всех/купленных игр, и некоторую небольшую информацию об игре для данного профиля.
* ISteamUserStats/GetSchemaForGame/v2 - информация по игре. В нее входит список ачивок, список показателей, и локализация.
* ISteamUserStats/GetUserStatsForGame/v2 - статистика по игре для профиля. Можно узнать выполнена ачивка или нет, и значение показателя.

* IDOTA2Match_570/GetMatchHistory/v1 - история игр. Имеет много фильтров - можно получить все игры, или по профилю, или по игроку. Но информация по игре скудная - во сколько началась, сколько было игроков, и на каких героях.
* IDOTA2Match_570/GetMatchDetails/v1 - детализация по игре. Дает очень подробную информацию, но позволяет получить одновременно детализацию, только по одной игре.
* IEconDOTA2_570/GetHeroes/v1 - информация о героях. Имя героя, и возможность получения url-ов для загрузки аватарок героев.

# Планы
* По коду есть TODO - это в основном технический долг, который желательно поправить
* Настройки - как миниум можно сделать переключение на цветовую гамму "steam" - чтобы было их три, а не две (черная, белая). В этом же экране нужна кнопка разлогинится.
* Сделать отображение универсальной статистики. Основная проблема - отсутствие перевода. Поэтому все ключи придется локализировать ручками.
* Сделать отображение ачивок. Сейчас есть только суммарная статистика по ачивкам, но хочется Сделать отдельный экран - для этого у steamAPI есть метод.
* Кастомизация других популярных игр (архитектура позволяет это легко сделать)
* Улучшение статистики по игре Dota2 - и превьюшка не красивая, и статистику с графиками можно намного более прикольную сделать.
* Для Dota2 добавить в информации по игре секцию "популярный герой".
* Для Dota2 добавить возможность просмотра статистики, по герою. Для начала "популярный" и "последний", с дальнейшей возможность выбора.
* (Опционально) Для Dota2 сделать экран истории матчей, с возможностью перейти к подробной статистике по матчу.
* На экране информации по игре добавить список первых 3 новостей, по нажатию на more переходишь к полному списку, с возможностью посмотреть новость.
* Экран профиля я бы сделал чуть другим - вначале список первыз 3 друзей, потом список первых 3 игр. С кнопками more. Соответственно нажатие на профиль, ничего не делает.
* Объект для аватарки профиля уже есть, но в нем надо добавить отображение статуса (как в самом steam, полоска с цветом)
* (Опционально) На экране сессий, для некоторых игр (аля Dota2), сделать вложенные ячейки, которые будут кратко показывать последние игры.
* Я не люблю alert - но искать/писать другой способ вывода ошибок нужно время. Но это надо сделать.
* Много где результаты от сервера не до отработаны - например у приватного пользователя, смысл показывать список игр - туда нужна заглушка. Для доты также не повредила бы заглушка, а не ошибка.

### Потраченное время
77 часа
