FailSafe UBUNTU 20.04

Всё делаем на обоих серверах:
1) Настраиваем netlan, hosts, sysctl, hostname(nodeN.storm.un); # все настройки лежат в папке network
2) Настраиваем resolv.conf, для этого apt install resolvconf, vim /etc/resolvconf/resolv.conf.d/head в этот файл вписываем нужные параметры и перезапускаемся;
3) Устанавливаем bind9, в /etc/bind/ копируем конфиги из папки dns и перезапускаем службу;
4) Устанавливаем isc-dhcp-server, меняем в /etc/default/isc-dhcp-server INTERFACESv4="ens33", и в папку /etc/dhcp/ помещаем файлы из папки dhcp, перезапускаем service isc-dhcp-server restart;
5) Устанавливаем ucarp и fake(apt install ucarp fake) берем скрипты из ucarp и помещаем в /etc/. Так же меняем конфиг в /etc/rc.local на обоих серверах(Проверяем наличие флага х у файла) и перезагружаемся
6) Скачиваем скрипты из папки isp selection scripts в папку /root/ и прописываем в crontab * * * * * /root/select_isp.sh >/dev/null 2>&1
