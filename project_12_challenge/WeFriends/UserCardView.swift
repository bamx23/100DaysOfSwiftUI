//
//  UserCardView.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import CoreData

struct UserCardView: View {
    @EnvironmentObject var storage: Storage

    let user: User

    var avatar: Image {
        if let avatar = user.avatar {
            return Image(uiImage: UIImage(data: avatar)!)
        } else {
            return Image(systemName: "person.crop.circle.fill")
        }
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .bottomTrailing) {
                self.avatar
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(user.isActive ? Color.blue : Color.gray, lineWidth: 3))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(user.isActive ? .blue : .gray)
                    .offset(x: -2, y: -2)
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .center) {
                    Text("\(user.wrappedAge)")
                        .font(.subheadline)
                        .padding(3)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text(user.wrappedName)
                        .font(.headline)
                }
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "briefcase.fill")
                        .padding(3)
                    Text(user.wrappedCompany)
                }
                .font(.footnote)
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "envelope.fill")
                        .padding(3)
                    Text(user.wrappedEmail)
                }
                .font(.footnote)
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "tag.fill")
                        .padding(3)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(user.tagsArray, id: \.self) { tag in
                                Text(tag)
                                    .padding(3)
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                    }
                }
                .font(.footnote)
                Spacer()
            }
        }
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSPersistentContainer(name: "WeFriends").viewContext
        return UserCardView(user: User(context: context))
            .environmentObject(Storage(context: context))
    }
}
