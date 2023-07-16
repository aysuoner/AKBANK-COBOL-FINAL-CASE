## AKBANK COBOL BOOTCAMP - Final Case

### _PROJENIN İÇERİĞİ_

---

AKBANK COBOL bootcamp'i kapsamında yapmış olduğum bu proje, basit bir  
`file handling` çalışmasıdır. Bu projede aşağıdaki dosyalar üzerinde READ, WRITE, UPDATE, DELETE gibi çeşitli işlemler gerçekleştirmektedir.

| SOURCE | TYPE |
| --- | --- |
| Z95610.QSAM.INP | _input file_ |
| Z95610.VSAM.AA | _i-o file_ |
| Z95610.QSAM.ZZ | _output file_ |

<table><tbody><tr><td><strong>COBOL FILE</strong></td><td><strong>&nbsp; &nbsp;FEATURE</strong></td></tr><tr><td>MAINPRG.cbl</td><td><i>&nbsp;Main cobol program</i></td></tr><tr><td>SUBPRG.cbl</td><td><i>Sub cobol program</i></td></tr></tbody></table>

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

.INP dosyasındaki veriler kullanılarak VSAM dosyasındaki kayıtlar için belirtilen process türlerinden biri `'R' ‘W’ ‘U’ ‘D’` .VSAM'daki kayda uygulanır.

.VSAM dosyasındaki kayıtların işleme alınmasından sonra ise bu işlemlerin başarılı / başarsız olduğu bilgilerinin yazıldığı bir .QSAM.ZZ adında output file oluşturulur.  
output file'a çıktılar aşağıdaki gibi yazdırılmaktadır.

### PROJENIN ÇALIŞTIRILMASI

---

_Projenin başarılı bir şekilde çalıştırılması için yapılması gerekenler:_  
_aşağıdaki dosyalara verilen sıra ile_ `SUBMIT JOB` _uygulanmalıdır._

> 1.  CRTINFO.jcl
> 2.  CRTINPID.jcl
> 3.  CRTVSAM.jcl
> 4.  CRTMAIN.jcl

### PROJEDE KULLANILAN BAZI TERİMLER

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
 

![valid-invalid-key](https://33333.cdn.cke-cs.com/kSW7V9NHUXugvhoQeFaf/images/909cb72a2271c75ed1b2ff703753044c8606080e56837240.png)

  
`ENTRY point`  
_Sub-programda alternatif bir giris noktasi olusturur. Ust-programda bu ENTRY point belirtilirse alt-program direkt bu ENRTY noktasindan baslar. Boylelikle alt programa belirli bir .Vsam isi icin gelinir ve tekrar ust-programa donulur._ 

`INVALID KEY - NOT INVALID KEY`  
_READ,WRITE, REWRITE, DELETE yapilan recordların durumunu kontrol etmek icin kullanilir.  Belirtilen key'e sahip bir record bulunamazsa veya islem sirasinda bir hata gerceklesirse INVALID KEY'de belirtilen durum gerceklesir. Aksi halde NOT INVALID KEY DURUMU gerceklesir._  
  
`PROGRAM-ID. SUBPRG IS INITIAL`  
 _Bir alt-programın initial olarak belirlenmesi, sub-programdan cikilirken acilan tum dahili dosyalarin otomatik olarak kapatilmasini ve program her çağırıldığında kullanılan değerlerin başlangıç durumuna getirilmesini sağlar. Boylelikle alt-programdan çıkarken açtığım dosyaları CLOSE lie kapatmaya gerek kalmamaktadir._  
