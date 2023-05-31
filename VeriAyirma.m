function [egitim_seti, test_seti] = VeriAyirma();

    veriler = readmatrix('dataset.csv','Range','A:XFD'); % Excel verilerini hücre dizisi olarak oku

    [m, ~] = size(veriler); % Veri boyutunu al
    ornek_sayisi = floor(0.7 * m); % Eğitim veri seti oranını belirleyin (örneğin %70)

    % Rastgele sıralanmış indekslerle veri setini karıştırın
    indeksler = randperm(m);
    veriler = veriler(indeksler, :);

    % Veri setini eğitim ve test setlerine ayırın
    egitim_seti = veriler(1:ornek_sayisi, :);
    test_seti = veriler(ornek_sayisi+1:end, :);
end