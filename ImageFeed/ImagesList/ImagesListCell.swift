//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Maksim  on 11.05.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}
