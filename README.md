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

![](https://33333.cdn.cke-cs.com/kSW7V9NHUXugvhoQeFaf/images/7635ddeb94bde8fdae1f33fb10b0192282695babf96773c9.png)

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
