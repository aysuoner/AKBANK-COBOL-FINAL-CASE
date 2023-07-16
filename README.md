## AKBANK COBOL BOOTCAMP - Final Case
### _PROJENIN İÇERİĞİ_
---
AKBANK COBOL bootcamp'i kapsamında yapmış olduğum bu proje, basit bir  
`file handling` çalışmasıdır. Bu projede aşağıdaki dosyalar üzerinde READ, WRITE, UPDATE, DELETE gibi çeşitli işlemler gerçekleştirmektedir.

| SOURCE | TYPE |
| --- | --- |
| **Z95610.QSAM.INP** | INPUT FILE |
| **Z95610.VSAM.AA** | INPUT FILE |
| **Z95610.QSAM.ZZ** | OUTPUT FILE |

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
