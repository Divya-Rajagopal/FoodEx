//
//  Cart.swift
//  FoodEx
//
//  Created by Nana on 3/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

struct Cart {

    var title: String?
    var items: Array<OrderItem>

    var subTotal: Double {
        return items.reduce(0, {$0 + $1.totalPrice})
    }

    var formattedSubTotal: String {
        return String(format: "$%.2f", subTotal)
    }

    var grandTotal: Double {
        return (subTotal * 1.085)
    }

    var formattedGrandTotal: String {
        return String(format: "$%.2f", grandTotal)
    }

    init(title: String?, items: Array<OrderItem>) {

        self.title = title
        self.items = items
    }

    init(dictionary source: Dictionary<String, Any>) {

        var cartItems = Array<OrderItem>()

        if let cartItemList = source["Items"] as? [Dictionary<String, Any>] {

            for cartItem in cartItemList {

                if let element = OrderItem(dictionary: cartItem) {
                    cartItems.append(element)
                }
            }
        }

        self.init(title: source["Title"] as? String, items: cartItems)
    }


    func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dict = Dictionary<String, Any>()

        if let title = self.title {
            dict.updateValue(title, forKey: "Title")
        }

        var itemDicts = [Dictionary<String, Any>]()

        for item in items {
            itemDicts.append(item.dictionaryRepresentation())
        }

        dict.updateValue(itemDicts, forKey: "Items")
        
        return dict
    }

    mutating func add(item: OrderItem) -> Void {

        items.append(item)
    }

    mutating func removeItem(at index: Int) -> Void {

        if index < items.count {
            items.remove(at: index)
        }
    }

    mutating func remove(item: OrderItem) -> Void {

        if let existingIndex = items.index(where: { (element) -> Bool in
            return (element.name == item.name) && (element.restaurantName == item.restaurantName)
        }) {
            items.remove(at: existingIndex)
        }
    }

}
