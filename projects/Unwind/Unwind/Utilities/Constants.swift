//
//  Constants.swift
//  Unwind
//
//  Created by Alan Cao on 5/13/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import Firebase
import FirebaseDatabase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_ARTICLE_IMAGES = STORAGE_REF.child("article-images")

let DB_REF = Database.database().reference()

let REF_USERS = DB_REF.child("users")
let REF_ARTICLES = DB_REF.child("articles")
let REF_USER_ARTICLES = DB_REF.child("user-articles")
let REF_USER_FAVORITES = DB_REF.child("user-favorites")
let REF_ARTICLE_FAVORITES = DB_REF.child("article-favorites")
