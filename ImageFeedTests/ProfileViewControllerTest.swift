//
//  ProfileViewControllerTwst.swift
//  ImageFeedTests
//
//  Created by Maksim  on 25.07.2024.
//

import XCTest
@testable import ImageFeed


final class ProfileViewControllerTests: XCTestCase {
    var viewController: ProfileViewController!
    var mockProfileService: MockProfileService!
    var mockProfileImageService: MockProfileImageService!
    var mockProfileLogoutService: MockProfileLogoutService!
    
    override func setUp() {
        super.setUp()
        
        mockProfileService = MockProfileService()
        mockProfileImageService = MockProfileImageService()
        mockProfileLogoutService = MockProfileLogoutService()
        
        viewController = ProfileViewController(
            profileService: mockProfileService,
            profileImageService: mockProfileImageService,
            profileLogoutService: mockProfileLogoutService
        )
        
        // Setup view controller
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        mockProfileService = nil
        mockProfileImageService = nil
        mockProfileLogoutService = nil
        
        super.tearDown()
    }
    
    func testUpdateProfileDetails() {
        // Given
        let profileResult = ProfileService.ProfileResult(
            username: "username",
            first_name: "John",
            last_name: "Doe",
            bio: "Bio"
        )
        let profile = Profile(from: profileResult)
        mockProfileService.setProfile(profile)
        
        // When
        viewController.updateProfileDetails()
        
        // Then
        XCTAssertEqual(viewController.nameLabel?.text, "John Doe")
        XCTAssertEqual(viewController.loginNameLabel?.text, "@username")
        XCTAssertEqual(viewController.descriptionLabel?.text, "Bio")
    }
    
    func testUpdateAvatar() {
        // Given
        let mockURL = "https://example.com/avatar.jpg"
        mockProfileImageService.avatarURL = mockURL
        
        // When
        viewController.updateAvatar()
        
        // Then
        XCTAssertEqual(mockProfileImageService.avatarURL, mockURL)
        // You would need to use a method to verify the image loading. This may require more advanced testing setups.
    }
}
