class Model_JobAlert {
  final String deliveryDate;
  final String empNo;
  final int empId;
  final int sumTrip;

  Model_JobAlert._({this.deliveryDate, this.empNo, this.empId, this.sumTrip});

  factory Model_JobAlert.fromJson(Map<String, dynamic> json) {
    return new Model_JobAlert._(
      deliveryDate: json['deliveryDate'],
      empNo: json['empNo'],
      empId: json['empId'],
      sumTrip: json['sumTrip'],

    );
  }
}