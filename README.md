Xgboost ile Anemi Türlerinin Sınıflandırılması

Bu R projesi, CBC (Complete Blood Count) veri seti üzerinde XGBoost algoritmasını kullanarak bir sınıflandırma modeli oluşturmayı amaçlar. Proje, veri setinin analizini yapmak, eksik değerleri incelemek,
görselleştirmek ve son olarak XGBoost modelini eğitmek ve değerlendirmek için adımları içerir.

Proje Açıklaması
Bu proje, CBC veri seti üzerinde yapılan bir sınıflandırma çalışmasını içerir. Veri seti, tam kan sayımı sonuçlarına (WBC, RBC, HGB vb.) ve teşhis bilgilerine sahip hastaların verilerini içerir.
Amaç, bu verileri kullanarak hastalık teşhisi yapmaktır.

Adımlar
*Veri Seti Yükleme ve Ön İnceleme: Veri setini yükleyin ve eksik değerleri inceleyin.
*Veri Görselleştirme: Histogramlar ve korelasyon matrisi gibi görselleştirmeler oluşturun.
*Model Oluşturma: XGBoost algoritması kullanılarak bir sınıflandırma modeli eğitin.
*Model Değerlendirme: Modelin performansını değerlendirin ve sonuçları görselleştirin.

Gereksinimler
Bu projeyi çalıştırmak için aşağıdaki R kütüphanelerine ihtiyacınız olacaktır:

*xgboost
*readr
*ggplot2
*gridExtra
*dplyr
*caret
*corrplot
