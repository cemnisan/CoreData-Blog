//
//  HomeTableViewCell.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import UIKit

protocol IHomeTableViewCell: AnyObject
{
    func bookMarkButtonWillPressed(on cell: HomeTableViewCell,
                                   with isFavorite: Bool,
                                   _ id: UUID)
}

final class HomeTableViewCell: UITableViewCell
{
    // MARK: - IBOutlet
    @IBOutlet private weak var userProfilePic: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var articleContentPic: UIImageView!
    @IBOutlet private weak var articleContentLabel: UILabel!
    @IBOutlet private weak var articleDateTextField: UILabel!
    @IBOutlet private weak var articleTitleTextField: UILabel!
    @IBOutlet private weak var bookMarkButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: IHomeTableViewCell?
    var isFavorite: Bool?
    var id: UUID?
    
    // MARK: - Lifecycles
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        userProfilePic.makeRoundedCircle()
        articleContentPic.makeRounded()
    }
}

// MARK: - Configure
extension HomeTableViewCell
{
    func configureCell(with article: Article)
    {
        userNameLabel.text         = article.author?.userName
        articleTitleTextField.text = article.title
        articleContentLabel.text   = article.content
        articleDateTextField.text  = article.createdDate?.getFormattedDate(format: "MMM d, yyyy")
        
        configureBookMark(isFavorited: article.isFavorite)
    }
    
    private func configureBookMark(isFavorited: Bool)
    {
        isFavorited ?
            bookMarkButton.setBookMark(bookMark: .bookMarkFill) :
            bookMarkButton.setBookMark(bookMark: .bookMark)
    }
}

// MARK: - IBActions
extension HomeTableViewCell
{
    @IBAction func bookMarkButtonPressed(_ sender: UIButton)
    {
        isFavorite = !isFavorite!
        configureBookMark(isFavorited: isFavorite!)
        delegate?.bookMarkButtonWillPressed(on: self, with: isFavorite!, id!)
    }
}
