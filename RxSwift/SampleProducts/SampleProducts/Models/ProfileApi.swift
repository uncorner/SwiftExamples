//
//  ProfileApi.swift
//  SampleProducts
//
//  Created by denis on 20.04.2022.
//

import Foundation
import RxSwift

struct File {
    let id: UUID
    let data: String
}

struct UploadResponse {
    let fileId: UUID
}

struct Profile {
    let avatars: [UUID]
}

struct SaveProfileResponse {
    let result: String = "OK"
}

protocol ProfileApi {
    func uploadFile(file: File) -> Observable<UploadResponse>
    func saveProfile(profile: Profile) -> Single<SaveProfileResponse>
}

class GoodProfileApi: ProfileApi {
    var files = [File]()
    var avatars = [UUID]()
    
    func uploadFile(file: File) -> Observable<UploadResponse> {
        //file.id = UUID()
        files.append(file)
        print("uploadFile \(file.id), \(file.data)")
        return Observable.just(UploadResponse(fileId: file.id))
    }
    
    func saveProfile(profile: Profile) -> Single<SaveProfileResponse> {
        avatars = profile.avatars
        print("saveProfile \(avatars)")
        return Single.just(SaveProfileResponse())
    }
}

class Manager {
    
    var disposeBag = DisposeBag()
    
    func run() {
        let api: ProfileApi = GoodProfileApi()
        
        let file1 = File(id: UUID(), data: "File 1")
        let file2 = File(id: UUID(), data: "File 2")
        let file3 = File(id: UUID(), data: "File 3")
        
//        let obs1 = api.uploadFile(file: file1).map { item in
//            Observable.just([item])
//        }
        
        let obs1 = api.uploadFile(file: file1)
        let obs2 = api.uploadFile(file: file2)
        let obs3 = api.uploadFile(file: file3)
        
        let conObs = obs1.concat(obs2).concat(obs3)
        let conSingle = conObs.toArray()
        
        let resSingle = conSingle.flatMap { uploadResponses -> Single<SaveProfileResponse> in
            let fileIds = uploadResponses.map { $0.fileId }
            let profile = Profile(avatars: fileIds)
            return api.saveProfile(profile: profile)
        }
        
        _ = resSingle.subscribe { saveProfileResponse in
            print("Success \(saveProfileResponse.result)")
        } onFailure: { error in
            print(error.localizedDescription)
        } onDisposed: {
            print("onDisposed")
        }
        .disposed(by: disposeBag)
        
    }
    
}
