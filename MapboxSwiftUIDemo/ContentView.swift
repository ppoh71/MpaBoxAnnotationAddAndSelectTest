import SwiftUI
import Mapbox

struct ContentView: View {
  @State var annotations: [MGLPointAnnotation] = [
      MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 37.791434, longitude: -122.396267))
  ]
  
    var body: some View {
      VStack{
        MapView(annotations: $annotations).centerCoordinate(.init(latitude: 37.791293, longitude: -122.396324)).zoomLevel(16)

        Button(action: {
          /// working
          self.addNextAnnotation(address: "Test")
        }) {
        Text("Add Annotation")
        }.frame(height: 100)
      }
    }
  
  /// add a random annotion to the map
  /// - Parameter address: address description
  func addNextAnnotation(address: String) {
    print("new anno", annotations)
    let randomLatitude = Double.random(in: 37.7912434..<37.7918434)
    let randomLongitude = Double.random(in: 122.396267..<122.396867) * -1
    let newAnnotation = MGLPointAnnotation(title: "Anno \(address)", coordinate: .init(latitude: randomLatitude, longitude: randomLongitude))

    annotations.append(newAnnotation)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}


