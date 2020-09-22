FailSafe UBUNTU 20.04

Всё делаем на обоих серверах:
1) Настраиваем netlan, hosts, sysctl, hostname(nodeN.storm.un); # все настройки лежат в папке network;

2) Настраиваем resolv.conf, для этого apt install resolvconf, vim /etc/resolvconf/resolv.conf.d/head в этот файл вписываем нужные параметры и перезапускаемся;

3) Устанавливаем bind9, в /etc/bind/ копируем конфиги из папки dns и перезапускаем службу;

4) Устанавливаем isc-dhcp-server, меняем в /etc/default/isc-dhcp-server `INTERFACESv4="ens33"`, и в папку /etc/dhcp/ помещаем файлы из папки dhcp, перезапускаем service isc-dhcp-server restart;

5) Устанавливаем ucarp и fake(apt install ucarp fake) берем скрипты из ucarp и помещаем в /etc/. Так же меняем конфиг в /etc/rc.local на обоих серверах(Проверяем наличие флага х у файла) и перезагружаемся;

6) Скачиваем скрипты из папки isp selection scripts в папку /root/ и прописываем в crontab `* * * * * /root/select_isp.sh >/dev/null 2>&1`;

7) Устанавливаем proftpd сервер на оба сервера и останавливаем службу. Также выводим из автозапуска.
7) Настраиваем синхронизацию папки /home: crontab `* * * * * root ps ax | grep -v grep | grep -q 'proftpd: (accepting connections)' && /usr/bin/rsync -az --delete /home/ slave:/home/`;

8) Устанавливаем corosync, настраиваем конфиг на основе файла из папки corosync, перезапускаем службу;

9) Устанавливаем pacemaker, проверям состояние с помощью `crm_mon -1`, оба сервера должны быть online;

10) Устанавливаем пакет управления конфигурацией pacemaker `apt install crmsh`. Выполняем следующие команды(В зависимости от нужной утилиты):
    ```sh
    crm status - статус
    crm configure show - просмотр конфигурации
    crm configure - начать конфигурирование:
        st-ssh
            property no-quorum-policy=ignore
            primitive st-ssh stonith:external/ssh params hostlist="node1.storm.un node2.storm.un"
            clone fencing st-ssh
        ftp
            primitive pr_ftp lsb:proftpd
            primitive pr_ip ocf:heartbeat:IPaddr2 params ip=192.168.X.10 cidr_netmask=32 nic=eth0
            group gr_ftp_ip pr_ftp pr_ip
        ISCSI
            primitive pr_srv_istgt lsb:istgt
            primitive pr_ip_istgt ocf:heartbeat:IPaddr2 params ip=192.168.X.15 cidr_netmask=32 nic=eth0
            group gr_ip_fs pr_fs_r0 pr_ip_istgt pr_srv_istgt

            show
            commit
            exit
    ```
11) Перед конфигурировнаием pacemaker для iscsi установим пакет `apt install istgt` и сконфигурируем файл /etc/istgt.conf который исходно лежит по пути /usr/share/doc/istgt/examples/istgt.conf.gz и изменим конфигурацию на основе файла в репозитории




