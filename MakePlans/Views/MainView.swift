//
//  MainView.swift
//  MakePlans
//
//  Created by Julian Riemersma on 27/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI
import Firebase
import Resolver

struct MainView: View {    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        LoadingView(isShowing: $session.isLoading) {
            Group {
                if (self.session.user != nil) {
                    Group {
                        if (self.session.user?.displayName) == nil {
                            RegisterView().transition(.opacity)
                        } else {
                            GroupListView().transition(.opacity)
                        }
                    }
                } else {
                    LoginView().transition(.opacity)
                }
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(SessionStore())
    }
}
