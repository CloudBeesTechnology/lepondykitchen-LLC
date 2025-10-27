import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/order_model.dart';
part 'orders_list_provider.g.dart';

@riverpod
class OrdersListNotifier extends _$OrdersListNotifier {
  @override
  Future<List<OrderModel2>> build() async {
    return fetchOrders();
  }

  Future<List<OrderModel2>> fetchOrders() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    final snapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .where('userID', isEqualTo: user!.uid)
        .get();

    final orders = snapshot.docs
        .map((doc) => OrderModel2(
              scheduleDate: doc.data()['scheduleDate'],
              scheduleTime: doc.data()['scheduleTime'],
              vendorId: doc.data()['vendorId'],
              senderName: doc.data()['senderName'],
              receiverName: doc.data()['receiverName'],
              parcelCategory: doc.data()['parcelCategory'],
              senderEmail: doc.data()['senderEmail'],
              senderPhone: doc.data()['senderPhone'],
              senderAddress: doc.data()['senderAddress'],
              senderHouseNumber: doc.data()['senderHouseNumber'],
              senderStreetNumber: doc.data()['senderStreetNumber'],
              senderFloorNumber: doc.data()['senderFloorNumber'],
              receiverPhone: doc.data()['receiverPhone'],
              receiverEmail: doc.data()['receiverEmail'],
              receiverAddress: doc.data()['receiverAddress'],
              receiverHouseNumber: doc.data()['receiverHouseNumber'],
              receiverStreetNumber: doc.data()['receiverStreetNumber'],
              receiverFloorNumber: doc.data()['receiverFloorNumber'],
              parcelAdminCommission: doc.data()['parcelAdminCommission'],
              parcelPayer: doc.data()['parcelPayer'],
              prescription: doc.data()['prescription'],
              prescriptionPic: doc.data()['prescriptionPic'],
              module: doc.data()['module'],
              orders: [
                ...(doc.data()['orders']).map((items) {
                  return OrdersList.fromMap(items);
                })
              ],
              pickupStorename: doc.data()['pickupStorename'],
              pickupPhone: doc.data()['pickupPhone'],
              pickupAddress: doc.data()['pickupAddress'],
              instruction: doc.data()['instruction'],
              couponPercentage: doc.data()['couponPercentage'],
              couponTitle: doc.data()['couponTitle'],
              useCoupon: doc.data()['useCoupon'],
              confirmationStatus: doc.data()['confirmationStatus'],
              uid: doc.data()['uid'],
              // marketID: doc.data()['marketID'],
              vendorIDs: [
                ...(doc.data()['vendorIDs']).map((items) {
                  return items;
                })
              ],
              userID: doc.data()['userID'],
              deliveryAddress: doc.data()['deliveryAddress'],
              houseNumber: doc.data()['houseNumber'],
              closesBusStop: doc.data()['closesBusStop'],
              deliveryBoyID: doc.data()['deliveryBoyID'],
              status: doc.data()['status'],
              accept: doc.data()['accept'],
              orderID: doc.data()['orderID'],
              timeCreated: doc.data()['timeCreated'].toDate(),
              total: doc.data()['total'],
              deliveryFee: doc.data()['deliveryFee'],
              acceptDelivery: doc.data()['acceptDelivery'],
              paymentType: doc.data()['paymentType'],
            ))
        .toList();

    orders.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
    return orders;
  }

  Future<void> filterOrders(String status) async {
    state = const AsyncValue.loading();

    // Fetch all orders first
    final orders = await fetchOrders();

    // Apply the filter on the fetched orders
    final filteredOrders = orders.where((order) {
      if (status == 'All') return true;
      if (status == 'Scheduled') {
        return order.scheduleDate!.isNotEmpty && order.scheduleDate != null;
      }
      if (status == 'Parcel Delivery') {
        return order.module == 'Parcel Delivery';
      }
      if (status == 'Pickup') return order.deliveryAddress!.isEmpty;
      return order.status == status;
    }).toList();

    // Update the state with the filtered orders
    state = AsyncValue.data(filteredOrders);
  }
}
