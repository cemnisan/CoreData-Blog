//
//  ValidateError+Ex.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 7.03.2022.
//

import Foundation

extension ValidateError: LocalizedError
{
    var errorDescription: String? {
        switch self {
        case .isTitleEmpty:
            return "Yeni oluşturulacak makalenin başlığı boş bırakılamaz, lütfen doldurup tekrar deneyiniz."
        case .titleTooShort:
            return "Yeni oluşturulacak makalenin başlığı en az 3 harften oluşmak zorundadır, lütfen tekrar deneyiniz."
        case .isContentEmpty:
            return "Yeni oluşturulacak makalenin içerik kısmı boş bırakılamaz, lütfen doldurup tekrar deneyiniz."
        case .contentTooShort:
            return "Yeni oluşturulacak makalenin content kısmı en az 3 harften oluşmak zorundadır, lütfen tekrar deneyiniz."
        }
    }
}
