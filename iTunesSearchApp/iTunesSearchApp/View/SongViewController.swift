//
//  SongViewController.swift
//  iTunesSearchApp
//
//  Created by Beyza Zengin on 26.09.2025.
//

import UIKit

final class SongViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = SongViewModel()
    
    /*    ViewModel’den bir nesne oluşturduk.
     •    private → Sadece bu sınıf içinde kullanılabilir.
     •    Bu sayede Controller (UI) → ViewModel (iş mantığı) bağlantısı kurulmuş oldu.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iTunes Search"
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        viewModel.delegate = self
    }
}

// UITableViewDataSource
extension SongViewController: UITableViewDataSource {
    // UITableViewDataSource → TableView’e kaç satır olacak, hücrelerde ne görünecek bilgisini veren protokol.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songs.count
    }
    
    /*    numberOfRowsInSection → Tablo kaç satır gösterecek?
          Cevap: viewModel.songs.count yani şarkı listemizin eleman sayısı kadar.
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ??
            UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let song = viewModel.songs[indexPath.row]
        cell.textLabel?.text = song.trackName
        cell.detailTextLabel?.text = song.artistName
        return cell
    }
    
    /*    cellForRowAt → Her satırda hangi içerik gösterilecek?
     •    dequeueReusableCell → TableView hücrelerini tekrar kullanır, bellek tasarrufu sağlar.
     •    Eğer önceden oluşturulmuş bir hücre yoksa yeni bir tane yaratıyoruz.
     •    indexPath.row → O anki satırın sıra numarası.
     •    song.trackName → Şarkının adı.
     •    song.artistName → Şarkıcının adı.
     •    Hücrenin textLabel ve detailTextLabel alanlarına bunları yazdırıyoruz.
     */
}

// UISearchBarDelegate
extension SongViewController: UISearchBarDelegate {
    // UISearchBarDelegate → Arama çubuğunda olan olayları yakalamamızı sağlar.
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.searchSongs(with: text)
        searchBar.resignFirstResponder()
    }
    
    /*    searchBarSearchButtonClicked → Kullanıcı klavyedeki Search tuşuna bastığında çalışır.
     •    guard let text = searchBar.text, !text.isEmpty → Arama çubuğu boş mu kontrol ediyoruz.
     •    viewModel.searchSongs(with: text) → ViewModel’e “şu kelimeyle arama yap” diyoruz.
     •    resignFirstResponder() → Klavyeyi kapatıyoruz.
     */
}

// SongViewModelDelegate
extension SongViewController: SongViewModelDelegate {
    
    /*  SongViewModelDelegate → Daha önce ViewModel’de tanımladığımız protokol.
        Yani ViewModel bize haber gönderdiğinde bu fonksiyonlar çalışacak.
    */
    
    func didUpdateSongs() { // ViewModel şarkılar güncellendi derse yeni şarkılar listelenir, tablo baştan yapılır.
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) { // ViewModel bir hata gönderirse konsola yazıdırıyoruz.
        print("Error: \(error.localizedDescription)")
    }
}
