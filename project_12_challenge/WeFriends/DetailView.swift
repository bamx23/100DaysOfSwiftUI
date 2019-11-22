//
//  DetailView.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

extension User {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: registered)
    }
}

struct DetailView: View {
    @EnvironmentObject var storage: Storage

    let user: User
    var showFriends = true

    @State private var showFriendPopup = false
    @State private var friendToShow: User!

    func mailTo() {
        let url = URL(string: "mailto:\(user.email)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func avatar(geometry: GeometryProxy) -> some View {
        let size = min(geometry.size.width, geometry.size.height) * 0.8
        let view: Image!
        if let image = storage.avatars[user.id] {
            view = Image(uiImage: image)
        } else {
            view = Image(systemName: "person.crop.circle.fill")
        }
        return view
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }

    func infoView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                Text("Bio")
                    .font(.headline)
                Group {
                    HStack(alignment: .center, spacing: 2) {
                        Image(systemName: "calendar")
                            .padding(3)
                        Text("Age: \(self.user.age)")
                    }
                    Text(self.user.about)
                }
                .padding(.leading, 20)
            }
            Group {
                Text("Tags")
                    .font(.headline)
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "tag.fill")
                        .padding(3)
                    Text(self.user.tags.joined(separator: ", "))
                }
                .padding(.leading, 20)
            }
            Group {
                Text("Contacts")
                    .font(.headline)
                Group {
                    HStack(alignment: .center, spacing: 2) {
                        Image(systemName: "envelope.fill")
                            .padding(3)
                        Button(action: self.mailTo) {
                            Text(self.user.email)
                        }
                    }
                    HStack(alignment: .center, spacing: 2) {
                        Image(systemName: "house.fill")
                            .padding(3)
                        Text(self.user.address)
                    }
                }
                .padding(.leading, 20)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack() {
                    self.avatar(geometry: geometry)
                        .padding(.vertical)
                    Text(self.user.isActive ? "active" : "inactive")
                        .font(Font.headline)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .background(self.user.isActive ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    self.infoView()
                    Text("Registered: \(self.user.formattedDate)")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    if (self.showFriends) {
                        Divider()
                        Text("Friends")
                            .font(.headline)
                        VStack(spacing: 0) {
                            ForEach(self.user.friends) { friend in
                                UserCardView(user: self.storage.users.first(where: { f in f.id == friend.id})!)
                                    .onTapGesture {
                                        self.friendToShow = self.storage.users.first(where: { f in f.id == friend.id})!
                                        self.showFriendPopup = true
                                    }
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitle(Text(user.name), displayMode: .inline)
        .sheet(isPresented: $showFriendPopup) {
            DetailView(user: self.friendToShow!, showFriends: false)
                .environmentObject(self.storage)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static let user = User.sample
    static var previews: some View {
        NavigationView {
            DetailView(user: user)
                .environmentObject(Storage())
        }
    }
}
