class NotificationModel {
  NotificationModel({
    int? id,
    String? title,
    String? image,
    String? description,
    String? status,
    Jobvisit? jobvisit,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _title = title;
    _image = image;
    _description = description;
    _status = status;
    _jobvisit = jobvisit;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  NotificationModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _description = json['description'];
    _status = json['status'];
    _jobvisit =
        json['jobvisit'] != null ? Jobvisit.fromJson(json['jobvisit']) : null;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  String? _title;
  String? _image;
  String? _description;
  String? _status;
  Jobvisit? _jobvisit;
  String? _createdAt;
  String? _updatedAt;
  NotificationModel copyWith({
    int? id,
    String? title,
    String? image,
    String? description,
    String? status,
    Jobvisit? jobvisit,
    String? createdAt,
    String? updatedAt,
  }) =>
      NotificationModel(
        id: id ?? _id,
        title: title ?? _title,
        image: image ?? _image,
        description: description ?? _description,
        status: status ?? _status,
        jobvisit: jobvisit ?? _jobvisit,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  int? get id => _id;
  String? get title => _title;
  String? get image => _image;
  String? get description => _description;
  String? get status => _status;
  Jobvisit? get jobvisit => _jobvisit;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['image'] = _image;
    map['description'] = _description;
    map['status'] = _status;
    if (_jobvisit != null) {
      map['jobvisit'] = _jobvisit?.toJson();
    }
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

class Jobvisit {
  Jobvisit({
    int? id,
    dynamic attachment,
    String? notificationcreatedby,
    dynamic customer,
    String? description,
    String? orderNumber,
    dynamic jobCategory,
    dynamic jobType,
    dynamic site,
    dynamic persons,
    String? refNumber,
    String? bookingDate,
    String? startDate,
    String? endDate,
    dynamic comment,
    int? arrivalTime,
    int? fetchingPartsTime,
    int? workedTime,
    int? engineerId,
    int? status,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _attachment = attachment;
    _notificationcreatedby = notificationcreatedby;
    _customer = customer;
    _description = description;
    _orderNumber = orderNumber;
    _jobCategory = jobCategory;
    _jobType = jobType;
    _site = site;
    _persons = persons;
    _refNumber = refNumber;
    _bookingDate = bookingDate;
    _startDate = startDate;
    _endDate = endDate;
    _comment = comment;
    _arrivalTime = arrivalTime;
    _fetchingPartsTime = fetchingPartsTime;
    _workedTime = workedTime;
    _engineerId = engineerId;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Jobvisit.fromJson(dynamic json) {
    _id = json['id'];
    _attachment = json['attachment'];
    _notificationcreatedby = json['notificationcreatedby'];
    _customer = json['customer'];
    _description = json['description'];
    _orderNumber = json['order_number'];
    _jobCategory = json['job_category'];
    _jobType = json['job_type'];
    _site = json['site'];
    _persons = json['persons'];
    _refNumber = json['ref_number'];
    _bookingDate = json['booking_date'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _comment = json['comment'];
    _arrivalTime = json['arrival_time'];
    _fetchingPartsTime = json['fetching_parts_time'];
    _workedTime = json['worked_time'];
    _engineerId = json['engineer_id'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  dynamic _attachment;
  String? _notificationcreatedby;
  dynamic _customer;
  String? _description;
  String? _orderNumber;
  dynamic _jobCategory;
  dynamic _jobType;
  dynamic _site;
  dynamic _persons;
  String? _refNumber;
  String? _bookingDate;
  String? _startDate;
  String? _endDate;
  dynamic _comment;
  int? _arrivalTime;
  int? _fetchingPartsTime;
  int? _workedTime;
  int? _engineerId;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  Jobvisit copyWith({
    int? id,
    dynamic attachment,
    String? notificationcreatedby,
    dynamic customer,
    String? description,
    String? orderNumber,
    dynamic jobCategory,
    dynamic jobType,
    dynamic site,
    dynamic persons,
    String? refNumber,
    String? bookingDate,
    String? startDate,
    String? endDate,
    dynamic comment,
    int? arrivalTime,
    int? fetchingPartsTime,
    int? workedTime,
    int? engineerId,
    int? status,
    String? createdAt,
    String? updatedAt,
  }) =>
      Jobvisit(
        id: id ?? _id,
        attachment: attachment ?? _attachment,
        notificationcreatedby: notificationcreatedby ?? _notificationcreatedby,
        customer: customer ?? _customer,
        description: description ?? _description,
        orderNumber: orderNumber ?? _orderNumber,
        jobCategory: jobCategory ?? _jobCategory,
        jobType: jobType ?? _jobType,
        site: site ?? _site,
        persons: persons ?? _persons,
        refNumber: refNumber ?? _refNumber,
        bookingDate: bookingDate ?? _bookingDate,
        startDate: startDate ?? _startDate,
        endDate: endDate ?? _endDate,
        comment: comment ?? _comment,
        arrivalTime: arrivalTime ?? _arrivalTime,
        fetchingPartsTime: fetchingPartsTime ?? _fetchingPartsTime,
        workedTime: workedTime ?? _workedTime,
        engineerId: engineerId ?? _engineerId,
        status: status ?? _status,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  int? get id => _id;
  dynamic get attachment => _attachment;
  String? get notificationcreatedby => _notificationcreatedby;
  dynamic get customer => _customer;
  String? get description => _description;
  String? get orderNumber => _orderNumber;
  dynamic get jobCategory => _jobCategory;
  dynamic get jobType => _jobType;
  dynamic get site => _site;
  dynamic get persons => _persons;
  String? get refNumber => _refNumber;
  String? get bookingDate => _bookingDate;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  dynamic get comment => _comment;
  int? get arrivalTime => _arrivalTime;
  int? get fetchingPartsTime => _fetchingPartsTime;
  int? get workedTime => _workedTime;
  int? get engineerId => _engineerId;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['attachment'] = _attachment;
    map['notificationcreatedby'] = _notificationcreatedby;
    map['customer'] = _customer;
    map['description'] = _description;
    map['order_number'] = _orderNumber;
    map['job_category'] = _jobCategory;
    map['job_type'] = _jobType;
    map['site'] = _site;
    map['persons'] = _persons;
    map['ref_number'] = _refNumber;
    map['booking_date'] = _bookingDate;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['comment'] = _comment;
    map['arrival_time'] = _arrivalTime;
    map['fetching_parts_time'] = _fetchingPartsTime;
    map['worked_time'] = _workedTime;
    map['engineer_id'] = _engineerId;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
