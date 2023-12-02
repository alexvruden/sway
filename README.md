# sway
Мой sway config.
<br>
<b>~/.bash_login</b>
<code>
export XDG_RUNTIME_DIR=/tmp/1000-runtime-dir
if ! test -d "${XDG_RUNTIME_DIR}"; then
mkdir "${XDG_RUNTIME_DIR}"
chmod 700 "${XDG_RUNTIME_DIR}"
fi
export $(dbus-launch)
sway --unsupported-gpu 2>/tmp/sway.log 1>&2
clear
exit
</code>
<br>
Попытка реализации рабочего стола как в винде.
<br>
1. Кнопка пуск: нажатие открывает меню приложений, прокрутка перечисляет все воркспасы
<br>
- в меню приложений запуск левой кнопкой мыши, остановка - правой , но не для всех пунктов
<br>
- иконки , цвет, текст, команды на ЛКМ или ПКМ можно менять "на лету" в директориях "баров" /tmp/swaybar/bar-*
<br>
2. Корзинка это скрачпад: помещает окно с фокусом в скрачпад
<br>
3. Если есть окно в скрачпаде рядом с корзинкой будет укузано количество: нажатие возвращает окно из скрачпада (всплывающее меню со списком)
<br>
4. На панели задач отображаются наименования окон с текущего воркспаса
<br>
5. Значок скрытых утилит (звук, цпу, память и раскладка): нажатие открывается/закрывается, нажатие на пунктах меню запускает доп. программы
<br>
6. Значок сети (вифи, впн, шнурок): нажатие открывается/закрывается, нажатие на пунктах меню запускает/останавливает сервисы
<br>
7. Значок раскладки клавы: нажатие меняет раскладку
<br>
8. Значок время: нажатие показывает расширенное время в отдельном окне
<br>
9. Значок монитор: прокрутка показывает воркспасы на которых есть открытые приложения.
<br>
Скрытые окна управления:
<br>
10. Слева вдоль экрана прозрачное окно шириной 5 пикселей: нажатие открывает предыдущий воркспас на котором есть открытые окна (как в п.9)
<br>
11. Справа вдоль экрана прозрачное окно шириной 5 пикселей: нажатие открывает следующий воркспас на котором есть открытые окна (как в п.9)
<br>
12. Левый верхний угол экрана прозрачное окно 5х5 пикселей: нажатие переключает все воркспасы в конфиге (как в п.1 прокрутка)
<br>
Переключить воркспасы с клавы нельзя.
<br>
Перекинуть окно с одного воркспаса на другой можно через скрач (спрятать и потом достать где нужно).
<br>
Воркспасов может быть много, у воркспаса должно быть уникальное имя типа "dsgjoi-agr34fg-sagawerwqf-vagvbwer".
<br>
Имена воркспасов лежат тут: 
<br>
<code>
~/.config/sway/workspaces.d/
</code>
<br>
Скрипты активно работают с диском в папке /tmp, поэтому лучше эту папку монтировать в память:
<br>
<b>/etc/fstab</b>
<br>
<code>tmpfs /tmp tmpfs rw,nosuid,noatime,nodev,size=40G,mode=1777 0 0</code>
<br>
