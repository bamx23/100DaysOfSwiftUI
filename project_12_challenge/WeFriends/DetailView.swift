//
//  DetailView.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc

    let user: User
    var showFriends = true

    @State private var showFriendPopup = false
    @State private var friendToShow: User!

    func mailTo() {
        let url = URL(string: "mailto:\(user.wrappedEmail)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func avatar(geometry: GeometryProxy) -> some View {
        let size = min(geometry.size.width, geometry.size.height) * 0.8
        let view: Image!
        if let imageData = user.avatar {
            view = Image(uiImage: UIImage(data: imageData)!)
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
                        Text("Age: \(self.user.wrappedAge)")
                    }
                    Text(self.user.wrappedAbout)
                }
                .padding(.leading, 20)
            }
            Group {
                Text("Tags")
                    .font(.headline)
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "tag.fill")
                        .padding(3)
                    Text(self.user.tagsArray.joined(separator: ", "))
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
                            Text(self.user.wrappedEmail)
                        }
                    }
                    HStack(alignment: .center, spacing: 2) {
                        Image(systemName: "house.fill")
                            .padding(3)
                        Text(self.user.wrappedAddress)
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
                    Text("Registered: \(self.user.formattedRegistered)")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    if (self.showFriends) {
                        Divider()
                        Text("Friends")
                            .font(.headline)
                        VStack(spacing: 0) {
                            ForEach(self.user.friendsArray) { friend in
                                UserCardView(user: friend)
                                    .onTapGesture {
                                        self.friendToShow = friend
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
        .navigationBarTitle(Text(user.wrappedName), displayMode: .inline)
        .sheet(isPresented: $showFriendPopup) {
            DetailView(user: self.friendToShow!, showFriends: false)
                .environment(\.managedObjectContext, self.moc)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(user: User(context: NSPersistentContainer(name: "WeFriends").viewContext))
        }
    }
}
