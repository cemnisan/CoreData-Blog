//
//  SearchTableViewCell.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 9.03.2022.
//

import UIKit

protocol ISearchTableViewCell: AnyObject
{
    func bookMarkButtonWillPressed(on cell: SearchTableViewCell,
                                   with id: UUID)
}

// MARK: - Initialize
final class SearchTableViewCell: UITableViewCell
{
    // MARK: - IBOutlets
    @IBOutlet private weak var userProfilePhoto: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var articleTitleLabel: UILabel!
    @IBOutlet private weak var bookMarkButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: ISearchTableViewCell?
    var isFavorite: Bool?
    var id: UUID?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        userProfilePhoto.makeRoundedCircle()
    }
}

// MARK: - Configure
extension SearchTableViewCell
{
    func configureCell(with article: Article)
    {
        userNameLabel.text     = article.author?.userName
        articleTitleLabel.text = article.title
        
        configureBookMark(with: article.isFavorite)
    }
    
    private func configureBookMark(with isFavorited: Bool)
    {
        isFavorited ?
            bookMarkButton.setBookMark(bookMark: .bookMarkFill) :
            bookMarkButton.setBookMark(bookMark: .bookMark)
    }
}

// MARK: - IBActions
extension SearchTableViewCell
{
    @IBAction func bookMarkButtonPressed(_ sender: Any)
    {
        isFavorite = !isFavorite!
        configureBookMark(with: isFavorite!)
        delegate?.bookMarkButtonWillPressed(on: self, with: id!)
    }
}
