import Foundation

extension URLSession {
    func devices(completion: @escaping ([String], Error?) -> Void) {
        token { token, error in
            guard let token: Token = token else {
                completion([], error)
                return
            }
            self.dataTask(with: URLRequest.devices(token: token.description)) { data, response, error in
                do {
                    guard let devices: [String] = try JSONDecoder().decode(JSON.self, from: data ?? Data()).value as? [String] else {
                        throw TankUtility.Error(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0) ?? .notAcceptable
                    }
                    completion(devices, nil)
                } catch {
                    completion([], error)
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
                    guard var device: Device = try JSONDecoder().decode(JSON.self, from: data ?? Data()).value as? Device else {
                        throw TankUtility.Error(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0) ?? .notAcceptable
                    }
                    device.id = id
                    completion(device, nil)
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }
    }
    
    func alerting(completion: @escaping ([Device], Error?) -> Void) {
        devices { ids, error in
            guard !ids.isEmpty else {
                completion([], error)
                return
            }
            var queue: [String] = []
            var devices: [Device] = []
            for id in ids {
                queue.append(id)
                self.device(id: id) { device, error in
                    if let device: Device = device, device.isAlerting {
                        devices.append(device)
                    }
                    queue = queue.filter { $0 != id }
                    if queue.isEmpty {
                        completion(devices, nil)
                    }
                }
            }
        }
    }
    
    func token(completion: @escaping (Token?, Error?) -> Void) {
        if let token: Token = Token.current {
            completion(token, nil)
            return
        }
        dataTask(with: URLRequest.token) { data, response, error in
            guard let token: Token = (try? JSONDecoder().decode(JSON.self, from: data ?? Data()))?.value as? Token else {
                completion(nil, TankUtility.Error(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0) ?? .notAcceptable)
                return
            }
            completion(token, nil)
        }.resume()
    }
}
