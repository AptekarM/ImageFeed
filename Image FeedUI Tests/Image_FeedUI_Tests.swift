//
//  Image_FeedUI_Tests.swift
//  Image FeedUI Tests
//
//  Created by Maksim  on 27.07.2024.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments.append("testMode")
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Войти"].tap()
        
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        
        loginTextField.tap()
        loginTextField.typeText("sportekar@gmail.com")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        sleep(2)
        passwordTextField.tap()
        
        passwordTextField.typeText("Aptekar1814!")
        app.otherElements["Login"].tap()
        
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables

        // Используем `descendants` для поиска ячеек
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)

        // Ожидаем существования первой ячейки
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        
        // Ожидаем появления кнопки "like button off" и кликаем
        XCTAssertTrue(cellToLike.buttons["like button off"].waitForExistence(timeout: 5))
        cellToLike.buttons["like button off"].tap()
        
        // Ожидаем появления кнопки "like button on" и кликаем
        XCTAssertTrue(cellToLike.buttons["like button on"].waitForExistence(timeout: 5))
        cellToLike.buttons["like button on"].tap()
        
        sleep(2)
        
        // Кликаем по ячейке
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        // Ожидаем появления изображения
        XCTAssertTrue(image.waitForExistence(timeout: 15))
        // Увеличение
        image.pinch(withScale: 3, velocity: 1)
        // Уменьшение
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Maksim Aptekar"].exists)
        XCTAssertTrue(app.staticTexts["@m_aptekar"].exists)
        
        app.buttons["logout button"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
        
        XCTAssertTrue(app.buttons["Войти"].exists)
    }
}
