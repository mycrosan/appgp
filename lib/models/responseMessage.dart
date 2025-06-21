class responseMessage {
  String status;
  String timestamp;
  String message;
  String error;
  String debugMessage;
  String subErrors;

  responseMessage(
      {this.status,
        this.timestamp,
        this.message,
        this.error,
        this.debugMessage,
        this.subErrors});

  responseMessage.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    timestamp = json['timestamp'];
    message = json['message'];
    error = json['error'];
    debugMessage = json['debugMessage'];
    subErrors = json['subErrors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['message'] = this.message;
    data['error'] = this.error;
    data['debugMessage'] = this.debugMessage;
    data['subErrors'] = this.subErrors;
    return data;
  }
}
