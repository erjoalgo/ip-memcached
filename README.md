A self contained cli utility to query api.ipinfodb.com and provide IP info.

$ echo 45.55.140.195 | ./ip-info-persistent.sh

    OK;;45.55.140.195;US;United States;New York;New York City;10013;40.7199;-74.005;-04:00
    
$ grep -Po '^[0-9.]+'  /var/log/nginx/my-site.log | sort | uniq | ip-info-persistent.sh
    
    OK;;1.169.77.189;TW;Taiwan, Province of China;T'ai-wan;Taipei;10048;25.0478;121.532;+08:00
    OK;;1.32.77.43;MY;Malaysia;Selangor;Seri Kembangan;43300;3.03333;101.717;+08:00
    OK;;101.109.151.109;TH;Thailand;Chon Buri;Phatthaya;76130;12.9333;100.883;+07:00
    OK;;101.226.33.205;TW;Taiwan, Province of China;T'ai-wan;Douliu;640;23.7094;120.543;+08:00
    OK;;101.226.51.226;CN;China;Shanghai;Shanghai;100032;31.2222;121.458;+08:00
    OK;;103.250.70.6;BD;Bangladesh;Dhaka;Dhaka;1312;23.7104;90.4074;+07:00
    OK;;103.250.71.207;BD;Bangladesh;Dhaka;Tungi;4212;23.89;90.4058;+07:00
    