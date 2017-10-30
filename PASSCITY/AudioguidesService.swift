//
//  AudioguidesService.swift
//  PASSCITY
//
//  Created by Алексей on 20.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import Moya
import CoreLocation
import ObjectMapper
import AVFoundation
import SwiftyJSON

private let defLanLon = "55.7520263,37.6153107"
private let apiKey = "608f70b0-1eaf-45c7-959e-d5be6a328f64"

enum DownloadingStatus {
  case downloading
  case downloaded
  case notDownloaded
}

enum AudioguidesTarget: TargetType {
  case searchTours
  case getObject(String)
  case downloadAudio(CONTENT_PROVIDER_UUID: String, AUDIO_UUID: String, playData: NowPlayingData)
  case downloadImage(CONTENT_PROVIDER_UUID: String, IMAGE_UUID: String)

  var baseURL: URL {
    switch self {
    case .downloadAudio, .downloadImage(_, _):
      return URL(string: "https://media.izi.travel/")!
    default:
      return URL(string: "https://api.izi.travel/")!
    }
  }

  var path: String {
    switch self {
    case .searchTours:
      return "mtg/objects/search"
    case .getObject(let objectId):
      return "/mtgobjects/\(objectId)"
    case .downloadAudio(let CONTENT_PROVIDER_UUID, let AUDIO_UUID, _):
      return "\(CONTENT_PROVIDER_UUID)/\(AUDIO_UUID).m4a"
    case .downloadImage(let CONTENT_PROVIDER_UUID, let IMAGE_UUID):
      return "\(CONTENT_PROVIDER_UUID)/\(IMAGE_UUID)_800x600.jpg"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var parameters: [String : Any]? {
    switch self {
    case .searchTours:
      var lan_lon = defLanLon
      if let location = LocationService.instance.currentLocation {
        lan_lon = "\(location.latitude),\(location.longitude)"
      }
      return [
        "radius": 20000,
        "lat_lon": lan_lon,
        "languages": (ProfileService.instance.currentSettings?.language ?? .ru).rawValue,
        "audio_duration": "true",
        "type": "tour,museum"
      ]
    case .getObject(_), .downloadImage(_, _):
      return [
        "languages": (ProfileService.instance.currentSettings?.language ?? .ru).rawValue,
        "audio_duration": "true",
        "lat_lon": defLanLon,
      ]
    case .downloadAudio(_, _, _):
      return nil
    }
  }
  

  var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case .downloadAudio(_, _, let playData):
      let destination: DownloadDestination = { _, _ in
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        documentsURL.appendPathComponent("\(playData.audioguideId ?? "")/\(playData.itemId ?? "").m4a")
        return (documentsURL, [.removePreviousFile])
      }
      return .download(DownloadType.request(destination))
    default:
      return .request
    }
  }
}

extension Notification.Name {
  static let playerHeightChanged = Notification.Name("playerWillHide")
  static let playerStateUpdated = Notification.Name("playerStartedPlaying")
}


class AudioguidesService {
  static let endpointClosure = { (target: AudioguidesTarget) -> Endpoint<AudioguidesTarget> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    return defaultEndpoint.adding(newHTTPHeaderFields: ["X-IZI-API-KEY": apiKey])
  }

  static let instande = AudioguidesService()

  var tours: [MTGChildObject] = []
  var fullTours = Set<MTGFullObject>()

  var sortedTours: [MTGChildObject] {
    return tours.sorted { first, second in
      if first.recent && !second.recent {
        return true
      } else if !first.recent && second.recent {
        return false
      } else {
        return first.distance < second.distance
      }
    }
  }

  private init() {
    if let toursJSON: String = StorageHelper.loadObjectForKey(.tours) {
      self.tours = Mapper<MTGChildObject>().mapArray(JSONString: toursJSON) ?? []
    }
    if let fullToursJSON: String = StorageHelper.loadObjectForKey(.fullTours) {
      self.fullTours = Set(Mapper<MTGFullObject>().mapArray(JSONString: fullToursJSON) ?? [])
    }
  }

  let provider = MoyaProvider<AudioguidesTarget>(endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true)])

  func fetchAudioguidesList(_ completion: @escaping ServiceCompletion<[MTGChildObject]>) {
    provider.request(.searchTours) { result in
      switch result {
      case .success(let response):
        guard let json = JSON(response.data).rawString(), let tours: [MTGChildObject] = Mapper<MTGChildObject>().mapArray(JSONString: json) else {
          completion(.failure(DataError.serializationError(response.data)))
          return
        }

        for newTour in tours {
          if let index = self.tours.index(of: newTour) {
            self.tours[index] = newTour
          } else {
            self.tours.append(newTour)
          }
        }

        for deletedTour in self.tours.filter({ tours.index(of: $0) == nil }) {
          if deletedTour.isDownloaded {
            deletedTour.distance = 0
            deletedTour.recent = false
          } else {
            if let index = self.tours.index(of: deletedTour) {
              self.tours.remove(at: index)
            } else {
              deletedTour.recent = false
            }
          }
        }

        completion(.success(self.tours))
        try? StorageHelper.save(self.tours.toJSONString(), forKey: .tours)
      case .failure(_):
        completion(.failure(DataError.noData))
      }
      return
    }
  }

  func fetchAudioguide(id: String, _ completion: @escaping ServiceCompletion<MTGFullObject>) -> Cancellable {
    return provider.request(.getObject(id)) { result in
      switch result {
      case .success(let response):
        guard let json = JSON(response.data).rawString(), let tours: [MTGFullObject] = Mapper<MTGFullObject>().mapArray(JSONString: json), let tour = tours.first else {
          completion(.failure(DataError.serializationError(response.data)))
          return
        }
        if !self.fullTours.contains(tour) {
          self.fullTours.insert(tour)
        } else {
          self.fullTours.remove(tour)
          self.fullTours.insert(tour)
        }
        try? StorageHelper.save(Array(self.fullTours).toJSONString(), forKey: .fullTours)
        completion(.success(tour))
      case .failure(_):
        completion(.failure(DataError.noData))
      }
      return
    }
  }

  func fetchAudioguideItem(id: String, _ completion: @escaping ServiceCompletion<MTGFullObject>) -> Cancellable {
    return provider.request(.getObject(id)) { result in
      switch result {
      case .success(let response):
        guard let json = JSON(response.data).rawString(), let tours: [MTGFullObject] = Mapper<MTGFullObject>().mapArray(JSONString: json), let tour = tours.first else {
          completion(.failure(DataError.serializationError(response.data)))
          return
        }
        completion(.success(tour))
      case .failure(_):
        completion(.failure(DataError.noData))
      }
      return
    }
  }

}

typealias NowPlayingData = (audioguideId: String?, itemId: String?)

class AudioguidesPlayer: NSObject, AVAudioPlayerDelegate {
  var observer: Any? = nil

  var audioPlayer: AVPlayer? = nil {
    didSet {
      if let observer = observer {
        oldValue?.removeTimeObserver(observer)
      }
      guard let audioPlayer = audioPlayer else {
        isNowPlaying = nil
        return
      }
      NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer)
      let interval = CMTime(seconds: 0.01,
                            preferredTimescale: CMTimeScale(NSEC_PER_SEC))
      let mainQueue = DispatchQueue.main
      self.observer = audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { time in
        MainTabBarController.instance.playerView.offset = time.seconds
      }

      //audioPlayer.delegate = self
    }
  }

  var currentTour: MTGFullObject? {
    guard let data = isNowPlaying else {
      return nil
    }
    guard let tour = AudioguidesService.instande.fullTours.first(where: { $0.uuid == data.audioguideId }) else {
      return nil
    }
    return tour
  }

  var currentItemIndex: Int? {
    guard let data = isNowPlaying else {
      return nil
    }
    guard let tour = currentTour else {
      return nil
    }
    guard let items = tour.content.first?.children, let currentItemIndex = items.index(where: { $0.uuid == data.itemId }) else {
      return nil
    }
    return currentItemIndex
  }

  var autoPlay: Bool = true

  func itemDidFinishPlaying() {
    if autoPlay {
      playNextTrackIfPossible()
    }
  }

  func playNextTrackIfPossible() {
    guard let data = isNowPlaying else {
      return
    }
    guard let tour = AudioguidesService.instande.fullTours.first(where: { $0.uuid == data.audioguideId }) else {
      return
    }
    guard let items = tour.content.first?.children, let currentItemIndex = items.index(where: { $0.uuid == data.itemId }) else {
      return
    }
    if currentItemIndex < items.count - 1 {
      playTourGuide(tour: tour, itemId: items[currentItemIndex + 1].uuid)
    } else {
      audioPlayer = nil
    }
  }

  var request: Cancellable? = nil

  var isNowPlaying: NowPlayingData? = nil

  var isPreloading: Bool = false

  static let instance = AudioguidesPlayer()

  func isPlaying(tourId: String? = nil, itemId: String? = nil) -> Bool {
    let guideId = tourId ?? isNowPlaying?.audioguideId
    let itemId = itemId ?? isNowPlaying?.itemId
    return isNowPlaying != nil && isNowPlaying?.audioguideId == guideId
      && itemId == isNowPlaying?.itemId
  }

  var playing: Bool {
    return (audioPlayer != nil && (audioPlayer!.timeControlStatus == .playing || !(audioPlayer!.currentItem?.isPlaybackLikelyToKeepUp ?? true))) || isPreloading
  }

  func downloadingStatus(_ guide: MTGObject) -> DownloadingStatus {
    if guide.isDownloaded {
      return .downloaded
    } else if downloadingToursIds.index(of: guide.uuid) != nil {
      return .downloading
    }
    return .notDownloaded
  }

  var downloadingToursIds = Set<String>()
  var downloadingTourItemsIds = Set<String>()

  private override init() {
    super.init()
  }

  func togglePlay() {
    MainTabBarController.instance.playerIsHidden = false
    if let player = audioPlayer, playing {
      MainTabBarController.instance.playerView.isPlaying = false
      player.pause()
    } else {
      MainTabBarController.instance.playerView.isPlaying = true
      audioPlayer?.play()
    }
    return
  }

  func togglePlayAudioguide(tourId: String, itemId: String? = nil) {
    MainTabBarController.instance.playerIsHidden = false
    guard !isPlaying(tourId: tourId, itemId: itemId) else {
      if let player = audioPlayer, playing {
        MainTabBarController.instance.playerView.isPlaying = false
        player.pause()
      } else {
        MainTabBarController.instance.playerView.isPlaying = true
        audioPlayer?.play()
      }
      return
    }
    if let tour = AudioguidesService.instande.fullTours.first(where: { $0.uuid == tourId }) {
      playTourGuide(tour: tour, itemId: itemId)
    } else {
      audioPlayer = nil
      isPreloading = true
      request = AudioguidesService.instande.fetchAudioguide(id: tourId, { result in
        self.isPreloading = false
        switch result {
        case .success(let tour):
          self.playTourGuide(tour: tour)
        case .failure(_):
          return
        }
      })
    }
  }

  func playTourGuide(tour: MTGFullObject, itemId: String? = nil) {
    MainTabBarController.instance.playerIsHidden = false
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let id = itemId ?? tour.content.first?.children.first?.uuid ?? ""
    guard !isPlaying(tourId: tour.uuid, itemId: id) else {
      if let player = audioPlayer, playing {
        MainTabBarController.instance.playerView.isPlaying = false
        player.pause()
      } else {
        MainTabBarController.instance.playerView.isPlaying = true
        audioPlayer?.play()
      }
      return
    }
    isNowPlaying = NowPlayingData(audioguideId: tour.uuid, itemId: id)
    let firstFileUrl = docsUrl.appendingPathComponent("\(tour.uuid)_\(id).m4a")
    if FileManager.default.fileExists(atPath: firstFileUrl.path) {
      audioPlayer = AVPlayer(url: firstFileUrl)
      audioPlayer?.play()
      if let tourItem = tour.content.first?.children.first(where: { $0.uuid == itemId }) {
        MainTabBarController.instance.playerView.duration = tourItem.duration
        MainTabBarController.instance.playerView.title = tourItem.title
        MainTabBarController.instance.playerView.offset = 0
      }
      MainTabBarController.instance.playerView.isPlaying = true
      return
    } else {
      self.isPreloading = true
      request = AudioguidesService.instande.fetchAudioguideItem(id: id, { result in
        switch result {
        case .success(let tourItem):
          let urlString = "https://media.izi.travel/\(tourItem.contentProviderId)/\(tourItem.audioUrl).m4a?api_key=\(apiKey)"
          let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? urlString)!
          let asset = AVURLAsset(url: url)
          let item = AVPlayerItem(asset: asset)
          MainTabBarController.instance.playerView.index = self.currentItemIndex ?? 0
          MainTabBarController.instance.playerView.duration = tourItem.content.first?.audio.first?.duration ?? 0
          MainTabBarController.instance.playerView.title = tourItem.content.first?.title
          MainTabBarController.instance.playerView.isPlaying = true
          self.audioPlayer = AVPlayer(playerItem: item)
          self.audioPlayer?.play()
          self.isPreloading = false
        case .failure(_):
          return
        }
      })
    }
  }

  func downloadTour(tourId: String) {
    guard downloadingToursIds.index(of: tourId) == nil else { return }
    if let tour = AudioguidesService.instande.fullTours.first(where: { $0.uuid == tourId }) {
      download(tour: tour)
    } else {
      downloadingToursIds.insert(tourId)
      _ = AudioguidesService.instande.fetchAudioguide(id: tourId, { result in
        switch result {
        case .success(let tour):
          self.download(tour: tour)
        case .failure(_):
          return
        }
      })
    }
  }

  func download(tour: MTGFullObject) {
    guard !downloadingToursIds.contains(tour.uuid) else {
      return
    }
    if tour.isDownloaded {
      tour.isDownloaded = false
      for item in (tour.content.first?.children ?? []) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docsUrl.appendingPathComponent("\(tour.uuid)_\(item.uuid).m4a")

        if FileManager.default.fileExists(atPath: url.path) {
          try? FileManager.default.removeItem(atPath: url.path)
        }
      }
    }
    downloadingToursIds.insert(tour.uuid)
    fetchTour(tour: tour, itemIdx: 0)
  }

  private func fetchTour(tour: MTGFullObject, itemIdx: Int) {
    guard let content = tour.content.first else { return }
    if itemIdx == content.children.count {
      tour.isDownloaded = true
      return
    }
    let item = content.children[itemIdx]
    self.downloadingTourItemsIds.insert(item.uuid)
    _ = AudioguidesService.instande.fetchAudioguideItem(id: item.uuid, { result in
      switch result {
      case .success(let tourItem):          AudioguidesService.instande.provider.request(.downloadAudio(CONTENT_PROVIDER_UUID: tourItem.contentProviderId, AUDIO_UUID: tourItem.content.first?.audio.first?.uuid ?? "", playData: (audioguideId: tour.uuid, itemId: item.uuid)), completion: { result in
        self.downloadingTourItemsIds.remove(item.uuid)
        switch result {
        case .success(_):
          self.fetchTour(tour: tour, itemIdx: itemIdx + 1)
        case .failure(_):
          break
          //self.fetchTour(tour: tour, itemIdx: itemIdx)
        }
      })
      case .failure(_):
        self.downloadingTourItemsIds.remove(item.uuid)
        self.fetchTour(tour: tour, itemIdx: itemIdx + 1)
      }
    })

  }
}

extension AVPlayer {
  var isPlaying: Bool {
    return rate != 0 && error == nil
  }
}
