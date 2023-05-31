function[test_veri,egitim_veri,silinen_sayi]= nitelik_azalt(egitim_veri,test_veri,agirliklar,hedef)
[~,genislik]=size(agirliklar);
silinen_sayi=0;
egitim_hedef= egitim_veri;
test_hedef=test_veri;
for i=1:genislik
    if agirliklar(i)<hedef
        egitim_hedef(:,i+2)=0;
        test_hedef(:,i+2)=0;
        silinen_sayi=silinen_sayi+1;
    end
end
end