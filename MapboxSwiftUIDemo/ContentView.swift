import SwiftUI
import Mapbox

struct ContentView: View {
  @EnvironmentObject var annotationModel: AnnotationModel
  
  @State var annotations: [MGLPointAnnotation] = [
    MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 37.791434, longitude: -122.396267))
  ]
  
  @State private var selectedAnnotaion: String = ""
  
  var body: some View {
    VStack{
      MapView(annotations: $annotations).centerCoordinate(.init(latitude: 37.791293, longitude: -122.396324)).zoomLevel(16).environmentObject(annotationModel)
      
      VStack{
        Button(action: {
          self.addNextAnnotation(address: "Location: \(Int.random(in: 1..<1000))")
        }) {
          Text("Add Location")
        }.frame(width: 200, height: 50)
        
        Text("Selected: \(annotationModel.selectedAnnotaion)")
        
        Spacer().frame(height: 50)
      }
    }
  }
  
  /// add a random annotion to the map
  /// - Parameter address: address description
  func addNextAnnotation(address: String) {
    let randomLatitude = Double.random(in: 37.7912434..<37.7918434)
    let randomLongitude = Double.random(in: 122.396267..<122.396867) * -1
    let newAnnotation = MGLPointAnnotation(title: address, coordinate: .init(latitude: randomLatitude, longitude: randomLongitude))
    
    annotations.append(newAnnotation)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(AnnotationModel())
  }
}


