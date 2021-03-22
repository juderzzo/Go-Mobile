class GoCheckListItem {
  String id;
  String causeID;
  String header;
  String subHeader;
  double lat;
  double lon;
  String address;
  List checkedOffBy;
  int dateTimePublished;
  int points;

  GoCheckListItem(
      {this.id,
      this.causeID,
      this.header,
      this.subHeader,
      this.lat,
      this.lon,
      this.address,
      this.checkedOffBy,
      this.dateTimePublished,
      this.points});

  GoCheckListItem.fromMap(Map<String, dynamic> data)
      : this(
            id: data['id'],
            causeID: data['causeID'],
            header: data['header'],
            subHeader: data['subHeader'],
            lat: data['lat'],
            lon: data['lon'],
            address: data['address'],
            checkedOffBy: data['checkedOffBy'],
            dateTimePublished: data['dateTimePublished'],
            points: data['points']);

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'causeID': this.causeID,
        'header': this.header,
        'subHeader': this.subHeader,
        'lat': this.lat,
        'lon': this.lon,
        'address': this.address,
        'checkedOffBy': this.checkedOffBy,
        'dateTimePublished': this.dateTimePublished,
        'points': this.points
      };
}
