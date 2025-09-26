//
//  Song.swift
//  iTunesSearchApp
//
//  Created by Beyza Zengin on 26.09.2025.
//

import Foundation

struct SongResponse: Codable { // API’den gelen cevabın tamamı. İçinde “results” diye bir liste var.
    let results: [Song]
}

struct Song: Codable { // O listedeki bir şarkının detayları (id, isim, sanatçı, albüm kapağı).
    let trackId: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String? // Opsiyonel yapmamızın sebebi: API bazı şarkılar için görsel göndermeyebilir.
}
// Codable bir struct, gelen JSON verisini kolayca structa çevirebilmemizi sağlar.
