//
//  MockImagesListService.swift
//  ImageFeedTests
//
//  Created by Maksim  on 25.07.2024.
//
import UIKit
import XCTest
@testable import ImageFeed



class ImagesListViewControllerTests: XCTestCase {
    var viewController: ImagesListViewController!
    var mockService: MockImagesListService!
    var dateFormatter: DateFormatter!
    
    override func setUp() {
        super.setUp()
        
        // Инициализация из Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        
        mockService = MockImagesListService()
        dateFormatter = DateFormatter()
        viewController.imagesListService = mockService
        viewController.dateFormatter = dateFormatter
        
        // Загружаем view
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockService = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    func testViewControllerLoadsPhotos() {
        // Создайте мок-данные
        let mockPhotos = [
            Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: Date(), description: "Test Photo 1", thumbImageURL: "", largeImageURL: "", isLiked: false, fullImageUrl: ""),
            Photo(id: "2", size: CGSize(width: 200, height: 200), createdAt: Date(), description: "Test Photo 2", thumbImageURL: "", largeImageURL: "", isLiked: true, fullImageUrl: "")
        ]
        mockService.mockPhotos = mockPhotos
        
        // Вызовите метод, чтобы обновить таблицу
        viewController.updateTableViewAnimated()
    }
    
    func testChangeLikeStatus() {
        // Создайте мок-данные
        let mockPhotos = [
            Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: Date(), description: "Test Photo 1", thumbImageURL: "", largeImageURL: "", isLiked: false, fullImageUrl: "")
        ]
        mockService.mockPhotos = mockPhotos
        
        // Измените статус лайка
        let cell = ImagesListCell()
        cell.delegate = viewController
        viewController.photos = mockPhotos
        viewController.imageListCellDidTapLike(cell)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        }
        
    }
}
