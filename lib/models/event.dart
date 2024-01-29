class EventInfo{

  EventInfo({
    required this.clubName,
    required this.eventName,
    required this.location,
    required this.dateTime,
    required this.minAge,
    required this.pictureUrl,

});


  final String clubName;
  final String eventName;
  final String location;
  final DateTime dateTime;
  final int minAge;
  final String pictureUrl;
 


  Map<String,dynamic> getEventDataMap(){
    return {
      "clubName":clubName,
      "eventName":eventName,
      "location":location,
      "dateTime":dateTime,
      "minAge":minAge,
      "pictureUrl":pictureUrl,
    };
  }

}