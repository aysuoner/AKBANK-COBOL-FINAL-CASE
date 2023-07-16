# AKBANK COBOL BOOTCAMP - Final Case
### PROJENIN İÇERİĞİ

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

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

*   Bu dosyadaki ilk karakter .VSAM dosyasına uygulanacak `process-type`
*   sonrasında gelen rakamlar ise uygulanacak olan processin VSAM dosyasındaki hangi record'a uygulanacağını belirten `RECORD-KEY` 'dir.
*   .INP dosyasındaki veriler kullanılarak VSAM dosyasındaki kayıtlar için belirtilen process türlerinden biri `'R' ‘W’ ‘U’ ‘D’` .VSAM'daki kayda uygulanır.
*   .VSAM dosyasındaki kayıtların işleme alınmasından sonra ise bu işlemlerin başarılı / başarsız olduğu bilgilerinin yazıldığı bir .QSAM.ZZ adında output file oluşturulur.
output file'a çıktılar aşağıdaki gibi yazdırılmaktadır.
```plaintext
63441834-READ-RC:00 RECORD READ
63441834-WRIT-RC:22 DUPLICATE RECORD
20002949-READ-RC:00 RECORD READ
20002949-DELT-RC:00 RECORD DELETED
20002949-READ-RC:23 RECORD NOT FOUND
20002949-UPDT-RC:23 RECORD NOT FOUND
20002949-WRIT-RC:00 NEW RECORD ADDED
```
