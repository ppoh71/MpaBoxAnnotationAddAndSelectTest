import SwiftUI
import Mapbox

struct ContentView: View {
  @EnvironmentObject var annotationModel: AnnotationModel
  
  @State var annotations: [MGLPointAnnotation] = [MGLPointAnnotation]()
  @State private var showAnnotation: Bool = false
  @State private var nextAnnotation: Int = 0
  
  var body: some View {
    GeometryReader{ g in
      VStack{
        ZStack(alignment: .top){
          MapView(annotations: self.$annotations).centerCoordinate(.init(latitude: 37.791293, longitude: -122.396324)).zoomLevel(16).environmentObject(self.annotationModel)
          
          if self.annotationModel.showCustomCallout {
            VStack{
              
              HStack{
                Spacer()
                Button(action: {
                  self.annotationModel.showCustomCallout = false
                }) {
                  Image(systemName: "xmark")
                    .foregroundColor(Color.black)
                    .font(Font.system(size: 12, weight: .regular))
                }.offset(x: -5, y: 5)
                
              }
              
              HStack{
                Text("Custom Callout")
                  .font(Font.system(size: 12, weight: .regular))
                  .foregroundColor(Color.black)
              }
              
              Spacer()
              
              Text("Selected: \(self.annotationModel.selectedAnnotation.title ?? "No Tiltle")")
                .font(Font.system(size: 16, weight: .regular))
                .foregroundColor(Color.black)
                
              Text("Count same Spot: \(self.annotationModel.locationsAtSameSpot.count) ")
                .font(Font.system(size: 16, weight: .regular))
                .foregroundColor(Color.black)
              
               Spacer()
              
              Button(action: {
                let gotNextSpot = self.annotationModel.getNextAnnotation(index: self.nextAnnotation)
                if gotNextSpot {
                  self.nextAnnotation += 1
                } else {
                  self.nextAnnotation = -1 // a bit dirty...
                }
                
              }) {
                Text("Get Next Spot >")
              }
              
            }.background(Color.white)
              .frame(width: 200, height: 250, alignment: .center)
              .cornerRadius(10)
              .offset(x: 0, y: 0)
          }
        }
        
        VStack{
          HStack{
          Button(action: {
            self.addNextAnnotation(address: "Spot \(Int.random(in: 1..<1000))", isSpotA: true)
          }) {
            Text("Add to Spot A")
          }.frame(width: 200, height: 50)
          
         Button(action: {
          self.addNextAnnotation(address: "Spot \(Int.random(in: 1..<1000))", isSpotA: false)
         }) {
           Text("Add to Spot B")
         }.frame(width: 200, height: 50)
        }
           Spacer().frame(height: 50)
        }
      }
    }
  }
  
  /// add a random annotion to the map
  /// - Parameter address: address description
  func addNextAnnotation(address: String, isSpotA: Bool) {
    print("add location")
    var newAnnotation = MGLPointAnnotation(title: address, coordinate: .init(latitude:  37.7912434, longitude: -122.396267))
    
    if !isSpotA {
      newAnnotation = MGLPointAnnotation(title: address, coordinate: .init(latitude:  37.7914434, longitude: -122.396467))
    }
    
    
    /// append to @State var which is used in teh mapview
    annotations.append(newAnnotation)
    
    /// also add location to model for calculations
    /// would need refactoring since this is redundant
    /// i leave it like that since it is more a prove of concept
    annotationModel.addLocationInModel(annotation: newAnnotation)
  
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(AnnotationModel())
  }
}


