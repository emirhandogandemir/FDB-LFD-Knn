function [] = main()

knn_sonucu=(5);
 silinen_sayi_azalt=zeros(1,8);
 azalmis_fitness=zeros(1,8);
 knn_azalmis=zeros(1,8);
 iterationCount=5;
 en_iyi_fitness=zeros(iterationCount, 1);
 total_best_fitness=0;
 total_hata=0;
 %Emirhan Doğandemir
for i=1:iterationCount
     fprintf("%d . aşama \n",i);
 [egitim_seti,test_seti] = VeriAyirma();
 [best_fitness,best_solution] = FDB_LFD_Case_1(egitim_seti,test_seti,5);
 hata=knn(egitim_seti,test_seti,5,30);
 en_iyi_fitness(i)=best_fitness *100;
 knn_sonucu(i)=hata*100;
 total_hata=total_hata+hata;
 total_best_fitness=total_best_fitness+best_fitness;
 sinir=0.1;
 kontrol=1;
 while sinir<0.8
     fprintf("Sinir degeri: "+sinir+"\n");
     [egitim_azalt,test_azalt,silinen_sayi_azalt(1,kontrol)]=nitelik_azalt(egitim_seti,test_seti,best_solution,sinir);
     [azalmis_fitness(1,kontrol),~]=FDB_LFD_Case_1(egitim_azalt,test_azalt,5);
     knn_azalmis(1,kontrol)=knn(egitim_azalt,test_azalt,5,30);
      
     fprintf("Sezgisel   %d:%f\n",kontrol,azalmis_fitness(1,kontrol)*100)
     fprintf("Knn   %d:%f\n",kontrol,knn_azalmis(1,kontrol)*100);
     fprintf("Silinen Sayi toplami %d:%d\n",kontrol,silinen_sayi_azalt(1,kontrol));
sinir=sinir+0.1;
kontrol = kontrol +1;
 end

end


max_best_fitness=max(en_iyi_fitness);
min_best_fitness=min(en_iyi_fitness);

avg_best_fitness= total_best_fitness/iterationCount;
avg_hata=total_hata/iterationCount;

 fprintf('\nAverage Best Fitness: %f\n', avg_best_fitness)
 fprintf('Average Hata: %f\n', avg_hata)
 fprintf('Max Best Fitness: %f\n', max_best_fitness)
 fprintf('Min Best Fitness: %f\n', min_best_fitness)









end

