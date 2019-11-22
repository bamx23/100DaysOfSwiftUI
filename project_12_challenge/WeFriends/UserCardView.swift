//
//  UserCardView.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct UserCardView: View {
    @EnvironmentObject var storage: Storage

    let user: User

    var avatar: Image {
        if let avatar = storage.avatars[user.id] {
            return Image(uiImage: avatar)
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
                    Text("\(user.age)")
                        .font(.subheadline)
                        .padding(3)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text(user.name)
                        .font(.headline)
                }
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "briefcase.fill")
                        .padding(3)
                    Text(user.company)
                }
                .font(.footnote)
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "envelope.fill")
                        .padding(3)
                    Text(user.email)
                }
                .font(.footnote)
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "tag.fill")
                        .padding(3)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(user.tags, id: \.self) { tag in
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
        UserCardView(user: User.sample)
            .environmentObject(Storage())
    }
}
