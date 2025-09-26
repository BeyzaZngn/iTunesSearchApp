//
//  SongViewModel.swift
//  iTunesSearchApp
//
//  Created by Beyza Zengin on 26.09.2025.
//

import Foundation

protocol SongViewModelDelegate: AnyObject { // AnyObject → Bu protokol sadece class’lar tarafından uygulanabilir (struct değil).
                                            // Amacı: ViewModel, ViewController’a haber gönderebilsin.
    
    func didUpdateSongs() // Eğer şarkılar başarıyla bulunduysa ViewController’a “güncelledim” mesajı gönderilecek.
    func didFailWithError(_ error: Error) // Eğer hata olduysa ViewController’a “hata oluştu” mesajı gönderilecek.
}

final class SongViewModel {
    
    private let apiService = APIService()
    
    /*
     •    private let → Bu özellik sadece bu sınıf içinde kullanılabilir.
     •    apiService → Daha önce yazdığımız APIService sınıfının bir örneği.
     •    Bu sayede internet isteklerini ViewModel üzerinden yöneteceğiz.
     */
    
    private(set) var songs: [Song] = []
    
    /*
     •    songs: [Song] → ViewModel’in tuttuğu şarkı listesi.
     •    private(set) → Dışarıdan bu listeye erişilebilir ama değiştirilemez.
     •    Yani ViewController viewModel.songs’u okuyabilir ama yeni değer atayamaz.
     •    Sadece ViewModel içinden güncellenebilir.
     */
    
    weak var delegate: SongViewModelDelegate?
    
    /*    delegate → Bu, ViewController olacak.
     •    SongViewModelDelegate? → Opsiyonel; eğer atanmazsa boş olabilir.
     •    weak → zayıf referans.
     •    Bu çok önemli çünkü ViewModel ile ViewController birbirine referans tutarsa “retain cycle” (bellek kaçağı) olur.
     •    weak sayesinde ViewController silindiğinde burası da otomatik nil olur.
     */
    
    func searchSongs(with query: String) { // Bu fonksiyonun amacı: Kullanıcı arama yaptığında API’den şarkı aratmak.
        
        apiService.searchSongs(query: query) { [weak self] result in
            
            /*    Burada daha önce yazdığımız APIService’in searchSongs fonksiyonunu çağırıyoruz.
             •    result → Result<[Song], Error> tipinde dönecek.
             •    Yani başarılı olursa [Song], hata olursa Error.
             •    [weak self] → Closure içinde self (yani ViewModel) kullanılacak.
             •    Eğer ViewModel silinirse (örneğin ekran kapanırsa), closure içinde hala güçlü bir referans kalmasın diye weak kullanıyoruz.
             */
            
            DispatchQueue.main.async {
                
            /*    Networking işlemleri arka planda (background thread) çalışır.
             •    Ama UI güncellemeleri (tableView.reloadData gibi) her zaman ana thread’de yapılmalı.
             •    O yüzden “sonuçları main queue’ya gönder” diyoruz.
             */
                
                switch result {
                    
                case .success(let songs):
                    
                    self?.songs = songs // self?.songs = songs → Gelen şarkı listesini ViewModel’de saklıyoruz.
                    self?.delegate?.didUpdateSongs() // Delegate’e haber veriyoruz → ViewController UI’yi günceller.
                    
                case .failure(let error):
                    
                    self?.delegate?.didFailWithError(error) // Delegate’e hata bilgisini iletiyoruz.
                }
                
            }
        }
    }
}
