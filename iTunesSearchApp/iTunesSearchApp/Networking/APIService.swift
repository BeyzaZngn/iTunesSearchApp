//
//  APIService.swift
//  iTunesSearchApp
//
//  Created by Beyza Zengin on 26.09.2025.
//

import Foundation

final class APIService { // Bu sınıftan başka sınıf miras (inheritance) alamaz.
                        // Yani bu sınıf son haliyle kullanılacak. Bu yüzden final class.
    func searchSongs(query: String, completion: @escaping (Result<[Song], Error>) -> Void) {
        
        /*
         •    query: String → Kullanıcının arama girdiği kelime. Örn: "Taylor Swift"
         
         •    completion: ... → Asenkron işlemler (internet çağrıları gibi) bittiğinde çalışacak bir geri çağırma (callback).
         
         •    @escaping → Normalde Swift’te fonksiyon bitince parametreler kaybolur.
         •    Ama biz bu completion’ı fonksiyon bittikten sonra (örneğin 2 saniye sonra internetten cevap geldiğinde) çağıracağız.
         •    O yüzden “bu closure fonksiyonun ömründen daha uzun yaşayabilir” diyoruz → @escaping.
         
         •    Result<[Song], Error> → Bu completion’ın döndüreceği değer.
         •    Başarılı olursa: [Song] (yani şarkılar listesi).
         •    Başarısız olursa: Error (hata).
         */
        
        let baseURL = "https://itunes.apple.com/search" // iTunes Search API’nin temel URL’si.
        guard let url = URL(string: "\(baseURL)?term=\(query)&entity=song") else { return }
        
        /*
         •    guard let → Güvenli bir şekilde opsiyonel değer açmak için kullanılır.
         •    URL(string: ...) → String’i URL tipine çevirmeye çalışır. Eğer çevirilemezse nil döner.
         •    Burada query → kullanıcının aradığı kelime.
         •    &entity=song → API’ye sadece şarkı aradığımızı söylüyor.
         •    Eğer URL oluşmazsa → else { return } diyerek fonksiyonu bitiriyoruz.
         */
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            /*
             •    { data, response, error in ... } → Bir closure (tamamlanınca çalışacak blok).
             •    data → İnternetten gelen ham veri (JSON formatında).
             •    response → HTTP cevabı (200 OK, 404 Not Found gibi).
             •    error → Bir hata olduysa bu dolu olur.
             */
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            /*
             •    Eğer error boş değilse (yani hata varsa):
             •    completion(.failure(error)) diyerek ViewModel’e hatayı iletiyoruz.
             •    return → Fonksiyondan çıkıyoruz.
             */
            
            guard let data = data else { return }
            
            /*
             •    Eğer hiç veri gelmemişse (data == nil) → fonksiyonu bitiriyoruz.
             •    Eğer veri varsa → data değişkenine güvenle erişebiliriz.
             */
            
            do {
                let result = try JSONDecoder().decode(SongResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
            
            /*    JSONDecoder().decode(...) → Gelen JSON verisini (data) bizim SongResponse struct’ına çevirmeye çalışır.
             •    SongResponse.self → Swift’e “bunu SongResponse tipine çevir” diyoruz.
             •    Eğer başarılı olursa:
             •    completion(.success(result.results)) → ViewModel’e şarkı listesini gönderiyoruz.
             •    Eğer hata olursa:
             •    completion(.failure(error)) → Hata bilgisini gönderiyoruz.
             */
            
        }.resume() // .dataTask oluşturmak yetmez, çalıştırmak için .resume() demek gerekir.
    }
}
