class ReviewBody {
  String _productId;
  String _deliveryManId;
  String _comment;
  String _rating;
  List<String> _fileUpload;
  String _orderId;
  double _orderTip;

  ReviewBody(
      {String productId,
        String deliveryManId,
        String comment,
        String rating,
        String orderId,
        double orderTip,
        List<String> fileUpload}) {
    this._productId = productId;
    this._deliveryManId = deliveryManId;
    this._comment = comment;
    this._rating = rating;
    this._orderId = orderId;
    this._fileUpload = fileUpload;
    this._orderTip = orderTip;
  }

  String get productId => _productId;
  String get deliveryManId => _deliveryManId;
  String get comment => _comment;
  String get orderId => _orderId;
  String get rating => _rating;
  double get orderTip => _orderTip;
  List<String> get fileUpload => _fileUpload;

  ReviewBody.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _deliveryManId = json['delivery_man_id'];
    _comment = json['comment'];
    _orderId = json['order_id'];
    _rating = json['rating'];
    _orderTip = json['delivery_tip_amount'];
    _fileUpload = json['attachment'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['delivery_man_id'] = this._deliveryManId;
    data['comment'] = this._comment;
    data['order_id'] = this._orderId;
    data['rating'] = this._rating;
    data['delivery_tip_amount'] = this._orderTip;
    data['attachment'] = this._fileUpload;
    return data;
  }
}
