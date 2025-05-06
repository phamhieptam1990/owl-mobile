/// This is an example of how to set up the [EventBus] and its events.
import 'package:event_bus/event_bus.dart';

/// The global [EventBus] object.
EventBus eventBus = EventBus();

/// Event A.
class ReloadList {
  String text;
  ReloadList(this.text);
}

/// Event HomeScreen.
class ReloadHomeScreen {
  String text;
  ReloadHomeScreen(this.text);
}

/// Event planned homeScreen.
class ReloadPlannedHomeScreen {
  String text;
  ReloadPlannedHomeScreen(this.text);
}

/// Event B.
class FilterList {
  var data;

  FilterList(this.data);
}

class ReloadNotification {
  var data;

  ReloadNotification(this.data);
}

class TriggerEventOffline {
  bool data;
  TriggerEventOffline(this.data);
}

// Dung cho cap nhat de o man hinh chi tiet
class UpdateDetailCollectionOffline {
  var data;
  UpdateDetailCollectionOffline(this.data);
}

// Dung cho cap nhat de o man hinh danh sach
class UpdateCollectionOffline {
  var data;
  UpdateCollectionOffline(this.data);
}

// Dung cho cap nhat de o man hinh danh sach
class LoadUserProfile {
  var data;
  LoadUserProfile(this.data);
}

// Load lai avatar
class ReloadAvatar {
  var data;
  ReloadAvatar(this.data);
}

class QueryStatusLinkingSMP {}
