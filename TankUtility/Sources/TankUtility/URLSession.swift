import Foundation

extension URLSession {
    func devices(completion: @escaping ([Device]?, Error?) -> Void) {
        token { token, error in
            guard let token: Token = token else {
                completion(nil, error)
                return
            }
            self.dataTask(with: URLRequest.devices(token: token.description)) { data, response, error in
                do {
                    guard let data: Data = data,
                        let ids: [String] = (try? JSONDecoder().decode(JSON.self, from: data).value) as? [String] else {
                        throw TankUtility.Error(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0) ?? .notAcceptable
                    }
                    guard !ids.isEmpty else {
                        completion([], nil)
                        return
                    }
                    var devices: [Device] = []
                    var queue: Int = ids.count
                    for id in ids {
                        self.device(id: id) { device, error in
                            if let device: Device = device {
                                devices.append(device)
                            }
                            queue -= 1
                            if queue < 1 {
                                completion(devices, nil)
                            }
                        }
                    }
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }
    }
    
    func device(id: String, completion: @escaping (Device?, Error?) -> Void) {
        token { token, error in
            guard let token: Token = token else {
                completion(nil, error)
                return
            }
            self.dataTask(with: URLRequest.devices(token: token.description, device: id)) { data, response, error in
                do {
                    guard let data: Data = data,
                        let device: Device = (try? JSONDecoder(device: id).decode(JSON.self, from: data).value) as? Device else {
                        throw TankUtility.Error(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0) ?? .notAcceptable
                    }
                    completion(device, nil)
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }
    }
    
    func token(completion: @escaping (Token?, Error?) -> Void) {
        if let token: Token = Token.current {
            completion(token, nil)
            return
        }
        dataTask(with: URLRequest.token) { data, response, error in
            guard let data: Data = data,
                let token: Token = (try? JSONDecoder().decode(JSON.self, from: data))?.value as? Token else {
                completion(nil, TankUtility.Error(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0) ?? .notAcceptable)
                return
            }
            completion(token, nil)
        }.resume()
    }
}
