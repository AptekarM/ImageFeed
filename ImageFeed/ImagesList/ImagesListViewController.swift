//
//  ViewController.swift
//  ImageFeed
//
//  Created by Maksim  on 02.05.2024.
//

import UIKit
import Kingfisher



final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    
    var imagesListService: ImagesListService!
        var dateFormatter: DateFormatter!

        var photos: [Photo] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewAnimated), name: ImagesListService.didChangeNotification, object: nil)
            
            imagesListService.fetchPhotosNextPage()
            
            DispatchQueue.main.async {
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.estimatedRowHeight = 200
                self.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
            }
        }
        
        @objc func updateTableViewAnimated() {
            let startIndex = photos.count
            let newPhotos = imagesListService.photos
            let endIndex = newPhotos.count
            
            guard endIndex > startIndex else { return }
            
            let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
            
            // Обновляем массив фотографий
            photos = newPhotos
            
            // Анимированное обновление таблицы
            tableView.performBatchUpdates({
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == showSingleImageSegueIdentifier {
                guard let viewController = segue.destination as? SingleImageViewController,
                      let indexPath = sender as? IndexPath else {
                    assertionFailure("Invalid segue destination")
                    return
                }
                
                let photo = photos[indexPath.row]
                viewController.fullImageUrl = photo.fullImageUrl
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }

    extension ImagesListViewController: ImagesListCellDelegate {
        func imageListCellDidTapLike(_ cell: ImagesListCell) {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let photo = photos[indexPath.row]
            
            // Покажем лоадер
            UIBlockingProgressHUD.show()
            
            imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    switch result {
                    case .success:
                        // Синхронизируем массив картинок с сервисом
                        self?.photos = self?.imagesListService.photos ?? []
                        // Изменим индикацию лайка картинки
                        cell.setIsLiked(self?.photos[indexPath.row].isLiked ?? false)
                    case .failure(let error):
                        print("Failed to change like status: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return photos.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell {
                let photo = photos[indexPath.row]
                cell.delegate = self
                cell.configure(with: photo, dateFormatter: dateFormatter)
                
                return cell
            } else {
                fatalError("Could not dequeue cell with identifier: \(ImagesListCell.reuseIdentifier)")
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let photo = photos[indexPath.row]
            let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
            let imageWidth = photo.size.width
            let scale = imageViewWidth / imageWidth
            let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
            return cellHeight
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == photos.count - 1 {
                imagesListService.fetchPhotosNextPage()
            }
        }
    }
