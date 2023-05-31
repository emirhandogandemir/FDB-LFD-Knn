function [ hata_orani ] = knn( egitim_seti,test_seti,k ,nitelik_degeri)

   hata=0;
   for i=1:length(test_seti)
       %
       for j=1:length(egitim_seti)
           %
           toplam=0;
           %özelliklerin(niteliklerin) indeksi 3'ten başlayarak özellik
           %degerleri arasında dolaşır. Id ve sınıf etiketi 1 ve 2. alır
           %çünkü
           for k=3:(nitelik_degeri+2)
               % toplam değişkenine her bir özelliğin ağırlıkla çarpılmış
               % öklid uzaklık hesaplama yöntemi eklenir
               toplam=toplam + (test_seti(i,k)-egitim_seti(j,k))^2;
           end
           % öklidyen uzaklıgı temsil eden arraydir.Test veri seti ile
           % egitim seti arasındaki farkı tutar.
           uzunluk_dizisi(j) = sqrt(toplam);
       end
       %uzunluk dizisini sıralamış oluruz,
       [~,indeksler] = sort(uzunluk_dizisi);
       %
       M_sayisi=0;
       % indeksler dizisindeki en küçük 5 degeri dolaşırım
       for k=1:5
           %eger egitim örneği M sınıfına aitse M_sayisini 1 artırırım. M
           %ye 1 B ye 0 verildi
           if egitim_seti((indeksler(k)),2)==1
               %
               M_sayisi=M_sayisi+1;
           end
       end
       %M_sayisi k'nın yarısından fazla ise eger hata değişkeni bir
       %artırılır
       if M_sayisi>=ceil(k/2)
           %
           if test_seti(i,2)==0
               hata = hata+1;
           end
       else
           %
            if test_seti(i,2)==1
                %
                hata = hata+1;
            end
       end
       %
       clear uzunluk_dizisi;
       %
       clear indeksler;
       %
   end
   hata_orani = hata/length(test_seti);
end

