/// Class: Album
///
/// Description: Stores JSON response data for routes.
class Album {
  final List<String> m_routes;

  Album({this.m_routes, });

  /// Function: Album (Constructor)
  ///
  /// Description: Return a data type containing the JSON routes.
  factory Album.fromJson(Map<String, dynamic> json) {

    return Album(
      m_routes: json['routes'],
    );
  }
}