
# Table of Contents

1.  [Installation](#orgc5bd9f6)
2.  [Usage](#org6e474b9)

A simple command-line interface to `ip-api.com`


<a id="orgc5bd9f6"></a>

# Installation

    go get -u github.com/erjoalgo/ip-memcached

-   Optionally install `memcached`, e.g.
    
        $ apt-get install memcached


<a id="org6e474b9"></a>

# Usage

    $ echo 8.8.8.8 | ip-memcached
    (1): { United States US   Mountain View     Level 3 Communications  AS15169 Google LLC }

    $ echo 34.214.135.69 | ip-memcached -verbose
    34.214.135.69 (1): { United States US   Portland     Amazon.com, Inc.  AS16509 Amazon.com, Inc. }

    
    $ cut -f1 -d' ' /var/log/nginx/access.log | sort | uniq | ip-memcached 
    1: { China CN   Guangzhou     China Mobile Communications Corporation  AS56040 China Mobile Communications Corporation }
    1: { Taiwan TW   Fenjihu     HINET  AS3462 Chunghwa Telecom Co., Ltd. }
    1: { Pakistan PK   Rawalpindi     PTCL  AS45595 Pakistan Telecommuication company limited }
    1: { France FR   Gravelines     OVH SAS  AS16276 OVH SAS }
    1: { Taiwan TW   Fenjihu     HINET  AS3462 Chunghwa Telecom Co., Ltd. }
    1: { United Kingdom GB   London (Hammersmith and Fulham)     TalkTalk  AS9105 Tiscali UK Limited }
    1: { China CN   Guangzhou     China Mobile communications corporation  AS9808 China Mobile }
    1: { United States US   Brooklyn     AT&T Services  AS7018 AT&T Services, Inc. }
    1: { France FR   Roubaix     OVH  AS16276 OVH SAS }
    1: { Germany DE   Garching bei München     Leibniz-Rechenzentrum  AS12816 Leibniz-Rechenzentrum }
    1: { Malaysia MY   Kuala Lumpur (Taman Bukit Pantai)     TMnet  AS4788 Tmnet, Telekom Malaysia Bhd. }
    1: { China CN   Huangpu Qu     CNC Group CHINA169 Shanghai Province Network  AS17621 China Unicom Shanghai network }

