//
//  NotificationBannerManager.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 15.03.2022.
//

import NotificationBannerSwift

final class NotificationBannerManager
{
    static let shared = NotificationBannerManager()
    
    private init() {}
}

extension NotificationBannerManager
{
    func createNotification(with isFavorite: Bool,
                            selectedArticle: Article)
    {
        let notificationStyle = FavoriteStatus.selectStatus(with: isFavorite)
        let notificationBanner: GrowingNotificationBanner
        
        switch notificationStyle {
        case .success:
            notificationBanner = GrowingNotificationBanner(
                title: "Başarılı",
                subtitle: "Seçmiş olduğunuz \(selectedArticle.title!) isimli makale, başarıyla favorilerinize eklendi!",
                leftView: nil,
                rightView: nil,
                style: .danger,
                colors: nil
            )
        case .info:
            notificationBanner = GrowingNotificationBanner(
                title: "Başarılı",
                subtitle: "Seçmiş olduğunuz \(selectedArticle.title!) isimi makale, başarıyla favorilerinizden kaldırıldı!",
                leftView: nil,
                rightView: nil,
                style: .info,
                colors: nil
            )
        }
        notificationBanner.show()
    }
}
