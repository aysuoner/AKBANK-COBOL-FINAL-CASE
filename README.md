## AKBANK COBOL BOOTCAMP - Final Case
---


_**AKBANK COBOL bootcamp'i kapsamında yapmış olduğum bu proje, basit bir \`file handling\` çalışmasıdır.**_   
 

## _PROJENIN ICERIGI_

---

##### INPUT && I- O && OUTPUT FILES

| SOURCE | TYPE |
| --- | --- |
| Z95610.QSAM.INP | _input file_ |
| Z95610.VSAM.AA | _i-o file_ |
| Z95610.QSAM.ZZ | _output file_ |

##### COBOL FILES

<table><tbody><tr><td><strong>COBOL FILE</strong></td><td><strong>&nbsp; &nbsp;FEATURE</strong></td></tr><tr><td>MAINPRG.cbl</td><td><i>&nbsp;Main cobol program=&gt;. Z95610.QSAM.INP &nbsp;dosyası burada okunur.</i><br><i>.Vsam dosyasında istenilen processin gerceklesmesi icin sub-program cagilir. Vsam dosyalarının islenmesinden dogan mesajlar &nbsp;Z95610.QSAM.ZZ dosyasına yazdırılır.</i></td></tr><tr><td>SUBPRG.cbl</td><td><i>Sub cobol program=&gt; .VSAM dosyası lie ilgili tum processler bu alt-programda gerceklesir.</i></td></tr></tbody></table>

##### JCL-FILES

| JCL-FILE | FEATURE |
| --- | --- |
| CRTINPID | Creates input for process type |
| CRTINFO | Creates input for VSAM file |
| CRTVSAM | Creates Vsam file and indexed records |
| CRTMAIN | JCL for main cobol pgm |





## _PROJE HAKKINDA_

---

AKBANK COBOL bootcamp'i kapsamında yapmış olduğum bu proje, basit bir `file handling` çalışmasıdır. Bu projede aşağıdaki dosyalar üzerinde READ, WRITE, UPDATE, DELETE gibi çeşitli işlemler gerçekleştirmektedir.

Öncelikte QSAM.INP dosyası aşağıdaki gibi gözükmektedir.

```plaintext
R63441834
W63441834
R20002949
D20002949
R20002949
U20002949
W20002949
```

Bu dosyadaki ilk karakter .VSAM dosyasına uygulanacak `process-type`

sonrasında gelen rakamlar ise uygulanacak olan processin VSAM dosyasındaki hangi record'a uygulanacağını belirten `RECORD-KEY` 'dir.

.INP dosyasındaki veriler kullanılarak VSAM dosyasındaki kayıtlar için belirtilen process türlerinden biri `'R' ‘W’ ‘U’ ‘D’` .VSAM'daki record'a uygulanır.


## _Projede Istenilen Ozellikler_

---

**R63441834** \==> `-R-` ise belirtilen record .VSAM'dan okumaya calis. Output file'a okundu/okunmadı bilgisini yaz.

**W63441834** \=> `-W-` ise belirtilen keyde bir record bulunmuyorsa Write lie buraya yeni bir kayıt ekle. Eger bu record key dol ise output file'a \`DUPLICATE RECORD\` mesajını ver.  

**D20002949** => `-D-` ise belirtilen keyde bir record bulunuyorsa bu recordu sil aksi halde   

\`RECORD NOT FOUND\` mesajını ver.  

**U20002949** => `-U-` ise belirtilen keyde bir record bulunuyorsa bu recordu bu recordun

> 1.  First-name'deki boslukları kaldir. Eger bosluk yoksa `ALREADY UPDATED` mesajını ver.
> 2.  Lastname'de vara ‘E’ harflerini ‘I’ harfine ve 'A' harflerini ‘e’ harfine cevir.

---

.VSAM dosyasındaki kayıtların işleme alınmasından sonra ise bu işlemlerin başarılı / başarsız olduğu bilgilerinin yazıldığı bir .QSAM.ZZ adında output file oluşturulur.  
output file'a çıktılar aşağıdaki gibi yazdırılmaktadır.

```plaintext
63441834-READ-RC:00 RECORD READ
63441834-WRIT-RC:22 DUPLICATE RECORD
20002949-READ-RC:00 RECORD READ
20002949-DELT-RC:00 RECORD DELETED
20002949-READ-RC:23 RECORD NOT FOUND
20002949-UPDT-RC:23 RECORD NOT FOUND
```

## _PROJENIN CALISTIRILMASI_

---

_Projenin başarılı bir şekilde çalıştırılması için yapılması gerekenler:_  
_aşağıdaki dosyalara verilen sıra ile_ `SUBMIT JOB` _uygulanmalıdır._

1.  CRTINFO.jcl
2.  CRTINPID.jcl
3.  CRTVSAM.jcl
4.  CRTMAIN.jcl  
     

## _KULLANILAN BAZI COBOL TERIMLERI_

---

![](https://33333.cdn.cke-cs.com/kSW7V9NHUXugvhoQeFaf/images/b66be986527b77e089e2d7c974e2df9deb91ccf0adb957ae.png)

`INPUT-OUTPUT SECTION.`  
  _Harici ortam ile cobol programi arasindaki veri iletimi burada yapilir. input-ouptut dosyalar cobol programi ile burada iliskilendirilir._

`SELECT statement`  
_Harici data-set ile iliskilendirilecek ve program icinde kullanilacak dahili dosyayi tanimlar (IDX-FILE)_

`ASSING TO clause`   
_JCL'de DD DSN= olarak dizini verilen //DD-name (IDXFILE) dosya icinde cagirilir. Boylelikle fiziksel data-set name, dosya icinde kullanilacak adiyla iliskilendirilir._

`ORGANIZATION clause`   
_Data-set icindeki recordlarin dosya icinde tutulma seklini belirler.\[INDEXED, SEQUENTIAL,RELATIVE\]. ORGANIZATION belirtilmezse default SEQUENTIAL'dir._

`ORGANIZATION INDEXED`  
_Bu organization'a gore dosyadaki her record bir record-key ile iliskilendirilecek sekilde tutulur. Bu INDEXED belirlenmis ORGANIZATION'larda record'lara anahtar degerler uzerinden erisilebilir._

`ACCESS clause`  
_ACCESS MODE ile dosyadan nasil record cekilecegini yani recordlara erisim seklini belirleriz. INDEXED tutulan verilere ACCESS MODE'un3 yontemi ile de erisilebilir. \[SEQUENTIAL, RANDOM, RELATIVE\]_

`ACCESS RANDOM`  
_Recordlarin kullanicinin belirttigi sekilde okunmasini ve yazilmasini saglar. Boylelikle kullanici tanimli keyler uretilir ve kayitlara bu keyler uzerinden erisilir._

`RECORD KEY clause`  
_Burada belirtilen key-name bir dosyadaki her bir recordu benzersiz sekilde tanimlayan bir kombinasyondur. RECORD KEY clause'da tanimlanan key-name ile kayitlara dogrudan erismek mumkun hale gelir._

> Sonuc olarak indexed tutulan verileri keyler araciligiyla bulmak, yeni kayitlar eklemek, silmek ve guncellemek mumkundur.

`STATUS`  
_Dosya islemlerinde dosyanin ne sekilde acildigina dair return-code'lari tutar._

>.

![](https://33333.cdn.cke-cs.com/kSW7V9NHUXugvhoQeFaf/images/cbab44b5529a9b8c9981951448826193bfd7958d41f0963b.png)

`DATA DIVISION.`  
_Program tarafindan islenecek tum verileri tanimlamak icin kullanilan divisiondir._  

`FILE SECTION.`  
_Harici olarak depolanan verilerin tanimlandigi sectiondur._

`_WORKING-STORAGE SECTION._`  
_Dahili verilen tanimlandigi section. Harici bir dosyanin parcasi olmayan, programin isleyisinde kullanilan gecici tüm degiskenlerin tanimlandigi yerdir._

`FD file-name clause`  
_Belirtilen file-name'in ozelliklerinin tanimlanmaya baslanacagi belirtir._

RECORDING MODE      Dosyadaki kayitlarin uzunluk tipini belirtir.  
`RECORDING MODE F`   Sabit uzunlukta kayit dosyalari icin  
`RECORDING MODE V`   Degisken uzunlukta kayit dosyalari icin kullanılır.

> VSAM dosyalarinda  RECORDING MODE belirtilmez.

`COMP-3`  
_numeric verileri Binary-Coded-Decimal formatinda_  
_depolar.Ondalikli sayilar bu formatta yapisi bozulmadan saklanir. Bu formatta her rakam yarim byte(4 bit) seklinde depolanir. Bu yuzden 1 byte'a 1 degil 2 rakam depolanir._  
_orn: 126 sayisi comp-3 formatinda su sekilde tutulur._

`0001  0010  0110    1111`  
`(1)   (2)   (6)  (fill area)`

\_Boylelikle degiskenin size'i azalmis olur. Size'i isle (len + 1) / 2 seklinde hesaplanir.

`COMP`  
_numaric veriler COMP. formatinda bellekte pure-binary seklinde depolanir. Degiskendeki basamak sayisina gore depolama alani degisir. onegin:_

> _4 basamak 2byte yer kaplarken_  
> _5 basamak 4byte yer kaplar_

_Ondalikli sayilari tutabilir ama binary seklinde tutugu icin yazdirilirken tamsayi haline gelir._  

![](https://33333.cdn.cke-cs.com/kSW7V9NHUXugvhoQeFaf/images/bc1efb97bbe6a365687d06e87d6febf0fca2dd3ed1ecb33e.png)

  
 

`ENTRY point`  
_Sub-programda alternatif bir giris noktasi olusturur. Ust-programda bu ENTRY point belirtilirse alt-program direkt bu ENRTY noktasindan baslar. Boylelikle alt programa belirli bir .Vsam isi icin gelinir ve tekrar ust-programa donulur._


`INVALID KEY - NOT INVALID KEY`  
_READ,WRITE, REWRITE, DELETE yapilan recordların durumunu kontrol etmek icin kullanilir.  Belirtilen key'e sahip bir record bulunamazsa veya islem sirasinda bir hata gerceklesirse INVALID KEY'de belirtilen durum gerceklesir. Aksi halde NOT INVALID KEY DURUMU gerceklesir._

`PROGRAM-ID. SUBPRG IS INITIAL`  
_Bir alt-programın initial olarak belirlenmesi, sub-programdan cikilirken acilan tum dahili dosyalarin otomatik olarak kapatilmasini ve program her çağırıldığında kullanılan değerlerin başlangıç durumuna getirilmesini sağlar. Boylelikle alt-programdan çıkarken açtığım dosyaları CLOSE lie kapatmaya gerek kalmamaktadir._
