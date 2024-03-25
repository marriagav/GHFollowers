//
//  FollowerView.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 25/03/24.
//

import SwiftUI

struct FollowerView: View {
    var follower: Follower
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: follower.avatarUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(.avatarPlaceholder)
                    .resizable()
                    .scaledToFit()
            }
            .clipShape(Circle())

            Text(follower.login)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
    }
}

#Preview {
    FollowerView(follower: Follower(login: "marriagav", avatarUrl: ""))
}
