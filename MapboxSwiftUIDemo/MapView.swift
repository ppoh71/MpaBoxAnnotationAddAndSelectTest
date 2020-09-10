import SwiftUI
import Mapbox
import Combine

extension MGLPointAnnotation {
  convenience init(title: String, coordinate: CLLocationCoordinate2D) {
    self.init()
    self.title = title
    self.coordinate = coordinate
  }
}

struct MapView: UIViewRepresentable {
  @Binding var annotations: [MGLPointAnnotation]
  @EnvironmentObject var annotationModel: AnnotationModel
  
  let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)
  
  // MARK: - Configuring UIViewRepresentable protocol
  
  func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
    mapView.delegate = context.coordinator
    return mapView
  }
  
  func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
    updateAnnotations()
  }
  
  func makeCoordinator() -> MapView.Coordinator {
    Coordinator(self, annotationModel: _annotationModel)
  }
  
  // MARK: - Configuring MGLMapView
  
  func styleURL(_ styleURL: URL) -> MapView {
    mapView.styleURL = styleURL
    return self
  }
  
  func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapView {
    mapView.centerCoordinate = centerCoordinate
    return self
  }
  
  func zoomLevel(_ zoomLevel: Double) -> MapView {
    mapView.zoomLevel = zoomLevel
    return self
  }
  
  private func updateAnnotations() {
    if let currentAnnotations = mapView.annotations {
      mapView.removeAnnotations(currentAnnotations)
    }
    mapView.addAnnotations(annotations)
  }
  
  // MARK: - Implementing MGLMapViewDelegate
  
  final class Coordinator: NSObject, MGLMapViewDelegate {
    var control: MapView
    @EnvironmentObject var annotationModel: AnnotationModel

    init(_ control: MapView, annotationModel: EnvironmentObject<AnnotationModel>) {
      self.control = control
      self._annotationModel = annotationModel
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
      
      let coordinates = [
        CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
        CLLocationCoordinate2D(latitude: 37.791591, longitude: -122.396566),
        CLLocationCoordinate2D(latitude: 37.791147, longitude: -122.396009),
        CLLocationCoordinate2D(latitude: 37.790883, longitude: -122.396349),
        CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
      ]
      
      let buildingFeature = MGLPolygonFeature(coordinates: coordinates, count: 5)
      let shapeSource = MGLShapeSource(identifier: "buildingSource", features: [buildingFeature], options: nil)
      mapView.style?.addSource(shapeSource)
      
      let fillLayer = MGLFillStyleLayer(identifier: "buildingFillLayer", source: shapeSource)
      fillLayer.fillColor = NSExpression(forConstantValue: UIColor.blue)
      fillLayer.fillOpacity = NSExpression(forConstantValue: 0.5)
      
      mapView.style?.addLayer(fillLayer)
      
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
      return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
      return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
      guard let annotationCollection = mapView.annotations else { return }
      
      /// cycle throu the annotations from the binding
      /// @Binding var annotations: [MGLPointAnnotation]
      for _annotation in annotationCollection {
        print("annotation", annotation)
        
        if annotation.coordinate.latitude == _annotation.coordinate.latitude {
          /// this is the same annotation
          print("*** Selected annoation")
          if let hastTitle = annotation.title {
            annotationModel.selectedAnnotaion = hastTitle ?? "no string in title"
          }
        } else {
          print("--- Not the selected annoation")
        }
      }
      mapView.setCenter(annotation.coordinate, zoomLevel: 17,  animated: true)
    }
  }
}


