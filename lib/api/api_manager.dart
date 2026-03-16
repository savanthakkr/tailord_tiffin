import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tailoredtiffin/model/add_cart_model.dart';
import 'package:tailoredtiffin/model/address_model.dart';
import 'package:tailoredtiffin/model/address_resp_model.dart';
import 'package:tailoredtiffin/model/all_bread_model.dart';
import 'package:tailoredtiffin/model/all_meals_model.dart';
import 'package:tailoredtiffin/model/all_subji_model.dart';
import 'package:tailoredtiffin/model/cart_model.dart';
import 'package:tailoredtiffin/model/cart_total_model.dart';
import 'package:tailoredtiffin/model/category_model.dart';
import 'package:tailoredtiffin/model/create_payment_model.dart';
import 'package:tailoredtiffin/model/home_model.dart';
import 'package:tailoredtiffin/model/order_detail_model.dart';
import 'package:tailoredtiffin/model/order_model.dart';
import 'package:tailoredtiffin/model/order_resp_model.dart';
import 'package:tailoredtiffin/model/pay_wallet_model.dart';
import 'package:tailoredtiffin/model/profile_model.dart';
import 'package:tailoredtiffin/model/reg_model.dart';
import 'package:tailoredtiffin/model/response_model.dart';
import 'package:tailoredtiffin/model/subcategory_model.dart';
import 'package:tailoredtiffin/model/wallet_model.dart';
import 'package:tailoredtiffin/model/wish_list_model.dart';
import 'package:tailoredtiffin/model/wish_response_model.dart';

import '../model/delivery_boy_order_details_model.dart';
import '../model/login_model.dart';
import '../model/product_filter_model.dart';
import '../model/special_item_model.dart';
import '../model/verify_payment_model.dart';
import '../screens/auth/login_screen.dart';
import '../utils/prefs.dart';

class ApiManager{
  static String baseUrl = "https://api.tailoredtiffin.com";
  static String imgUrl = "https://api.tailoredtiffin.com/Assets/meals/image/";
  // static String baseUrl = "http://192.168.1.3:5000";
  // static String imgUrl = "http://192.168.1.3:5000/productImages/image/";

  static Future<T> safeRequest<T>({
    required Future<http.Response> Function() request,
    required T Function(String body) parser,
  }) async {
    final response = await request();

    debugPrint(
      "API => ${response.request?.url}\n"
          "STATUS => ${response.statusCode}\n"
          "BODY => ${response.body}",
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      await Prefs.shared.clearUserSession();
      Get.offAll(() => LoginScreen());
      throw Exception("Unauthorized");
    }

    return parser(response.body);
  }

  static Future<LoginModel> login({required String mobileNo, required String firebasetoken}) async {
    final body = {
      "inputdata": {
        "mobile_no": mobileNo,
        "firebasetoken": firebasetoken,
      }
    };


    final response = await http.post(Uri.parse("$baseUrl/user/user_login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body)
    );

    print(response.body);


    debugPrint("RESPONSE : ${response.body}");
    return loginModelFromJson(response.body);
  }

  static Future<ResponseModel> updateOrderStatus({
    required String orderId,
    required String deliveryDate,
    required String slot,
    required String deliveryStatus,
    required String paymentStatus,
  }) async {

    final body = {
      "inputdata": {
        "order_id": orderId,
        "delivery_date": deliveryDate,
        "slot": slot,
        "delivery_status": deliveryStatus,
        "payment_status": paymentStatus
      }
    };

    final response = await http.post(
      Uri.parse("$baseUrl/delivery/update_order_status"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Prefs.shared.getString(Prefs.authToken) ?? "",
      },
      body: jsonEncode(body),
    );

    debugPrint("UPDATE ORDER STATUS => ${response.body}");

    return responseModelFromJson(response.body);
  }

  static Future<ResponseModel> checkMobileExist({required String mobileNo}) async {
    final body = {
      "inputdata": {
        "mobile_no": mobileNo,
      }
    };
    final response = await http.post(Uri.parse("$baseUrl/user/forgot_password_send_otp"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body)
    );

    debugPrint("RESPONSE : ${response.body}");
    return responseModelFromJson(response.body);
  }

  static Future<ResponseModel> resetPassword({required String mobileNo,required String password}) async {
    final body = {
      "inputdata": {
        "mobile_no": mobileNo,
        "new_password": password,
      }
    };
    final response = await http.post(Uri.parse("$baseUrl/user/forgot_password_reset"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body)
    );

    debugPrint("RESPONSE : ${response.body}");
    return responseModelFromJson(response.body);
  }

  static Future<LoginModel> verifyOtp({required int userId,required String otp}) async {
    final body = {
      "inputdata": {
        "user_id": userId,
        "otp": otp,
      }
    };

    final response = await http.post(Uri.parse("$baseUrl/user/verify_otp"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body)
    );

    debugPrint("verify_otp : ${response.body}");
    return loginModelFromJson(response.body);
  }

  static Future<RegisterModel> signUp({required String name,required String email, required String mobileNo,
    required String password,required String firebaseToken}) async
  {
    final body = {
      "inputdata": {
        "name": name,
        "email": email,
        "mobile_no": mobileNo,
        "password": password,
        "user_Firebase_Token": firebaseToken
      }
    };

    final response = await http.post(Uri.parse("$baseUrl/user/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

      debugPrint("register : ${response.body}");
      return registerModelFromJson(response.body);
  }

  static Future<AllMealsModel> getAllMeals({
    required String userId,
    required String authToken,
  }) {
    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/get_meals"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode({
          "inputdata": {"user_id": int.parse(userId)}
        }),
      ),
      parser: allMealsModelFromJson,
    );
  }

  static Future<SpecialItemModel> getAllSpecialItems({required String userId,required String authToken}) async {
    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/get_special_items"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode({
          "inputdata": {
            "user_id": int.parse(userId),
          }
        }),
      ),
      parser: specialItemModelFromJson,
    );
  }

  static Future<AllSubjiModel> getAllSubji({
    required String userId,
    required String authToken,
  }) {
    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/get_subji_list"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode({
          "inputdata": {"user_id": int.parse(userId)}
        }),
      ),
      parser: allSubjiModelFromJson,
    );
  }

  static Future<AllBreadModel> getAllBread({
    required String userId,
    required String authToken,
  }) {
    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/get_bread_list"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode({
          "inputdata": {"user_id": int.parse(userId)}
        }),
      ),
      parser: allBreadModelFromJson,
    );
  }

  static Future<ProfileModel> getUserProfile({required String authToken}) async {
    return safeRequest(
      request: () => http.get(
        Uri.parse("$baseUrl/user/get_user_profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
      ),
      parser: profileModelFromJson,
    );
  }

  static Future<ResponseModel> updateUserProfile({required String authToken,required String name,
    required String email}) async {
    final body = {
      "inputdata": {
        "name": name,
        "email": email,
      }
    };

    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/update_user_profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode(body),
      ),
      parser: responseModelFromJson,
    );
  }

  static Future<CategoryModel> getAllCategory({required String userId,required String authToken}) async {
    final body = {
      "inputdata": {
        "user_id": int.parse(userId),
      }
    };

    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/list_category"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode(body),
      ),
      parser: categoryModelFromJson,
    );
  }

  static Future<SubcategoryModel> getSubCategory({required String catId,required String authToken}) async {
    final body = {
      "inputdata": {
        "category_Id": int.parse(catId),
      }
    };

    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/list_sub_category_by_category_id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode(body),
      ),
      parser: subcategoryModelFromJson,
    );
  }

  static Future<SubcategoryModel> getAllSubCategory({required String userId,required String authToken}) async {
    final body = {
      "inputdata": {
        "user_id": int.parse(userId),
      }
    };

    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/list_sub_category"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode(body),
      ),
      parser: subcategoryModelFromJson,
    );
  }

  static Future<AddCartModel> addToCart({required String authToken,required Map<String, dynamic> mealPayload}) async {
    final body = {
      "inputdata": mealPayload
    };

    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/add_cart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode(body),
      ),
      parser: addCartModelFromJson,
    );
  }

  static Future<AddCartModel> updateCart({required String authToken,required Map<String, dynamic> mealPayload}) async {
    final body = {
      "inputdata": mealPayload
    };

    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/update_cart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode(body),
      ),
      parser: addCartModelFromJson,
    );
  }

  static Future<CartModel> getCart({required String authToken}) async {
    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/get_cart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode({
          "inputdata": {}
        })
      ),
      parser: cartModelFromJson,
    );
  }

  static Future<CartTotalModel> getCartTotal({required String authToken}) async {

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/get_cart_total"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode({
            "inputdata": {}
          })
      ),
      parser: cartTotalModelFromJson,
    );
  }

  static Future<ResponseModel> removeCart({required String authToken,required int cartId}) async {
    final body = {
      "inputdata": {
        "cart_id": cartId
      }
    };

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/delete_cart"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode(body)
      ),
      parser: responseModelFromJson,
    );
  }

  static Future<WishResponseModel> addToWishlist({required String authToken,required int productId,
    required int userId}) async {
    final body = {
      "inputdata": {
        "user_id": userId,
        "product_id": productId,
      }
    };

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/add_wishlist"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode(body)
      ),
      parser: wishResponseModelFromJson,
    );
  }

  static Future<WishListModel> getWishList({required String authToken}) async {

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/get_wishlist"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode({
            "inputdata": {}
          })
      ),
      parser: wishListModelFromJson,
    );
  }

  static Future<ResponseModel> removeFromWishlist({required String authToken,required int wishId}) async {
    final body = {
      "inputdata": {
        "wishlist_id": wishId
      }
    };

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/remove_wishlist"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode(body)
      ),
      parser: responseModelFromJson,
    );
  }

  static Future<ResponseModel> addAddress({required String authToken,required String title,
    required String address,required String landmark,required String state, required String city,
    required String pincode,required double latitude,required double longitude,required int isDefault,}) async
  {

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/add_address"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode({
            "inputdata": {
              "address_title": title,
              "full_address": address,
              "landmark": landmark,
              "city": city,
              "state": state,
              "pincode": pincode,
              "latitude": latitude.toString(),
              "longitude": longitude.toString(),
              "is_default": isDefault
            }
          })
      ),
      parser: responseModelFromJson,
    );
  }

  static Future<AddressModel> getAddressList({required String authToken}) async {

    return safeRequest(
      request: () => http.get(
          Uri.parse("$baseUrl/user/list_address"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
      ),
      parser: addressModelFromJson,
    );
  }

  static Future<ResponseModel> removeAddress({required String authToken,required int addressId}) async {
    final body = {
      "inputdata": {
        "address_id": addressId
      }
    };

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/delete_address"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode(body)
      ),
      parser: responseModelFromJson,
    );
  }

  static Future<ResponseModel> updateAddress({required String authToken,required String title,
    required String address,required String landmark,required String state, required String city,
    required String pincode,required int isDefault,required int addressId}) async
  {

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/edit_address"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode({
            "inputdata": {
              "address_id": addressId,
              "address_title": title,
              "full_address": address,
              "landmark": landmark,
              "city": city,
              "state": state,
              "pincode": pincode,
              "is_default": isDefault
            }
          })
      ),
      parser: responseModelFromJson,
    );
  }

  static Future<OrderRespModel> placeOrder({required String authToken,required int addressId,
    required String slot,required  List<String> delivery_dates,required String payment_type,required String selection_mode}) async
  {

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/create_order"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode({
            "inputdata": {
              "address_id": addressId,
              "slot": slot,
              "delivery_dates": delivery_dates,
              "payment_type": payment_type,
              "selection_mode": selection_mode
            }
          })
      ),
      parser: orderRespModelFromJson,
    );
  }

  static Future<PayWalletModel> payWallet({required String authToken,required double amount}) async
  {
    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/pay_wallet"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode({
            "inputdata": {
              "amount": amount,
            }
          })
      ),
      parser: payWalletModelFromJson,
    );
  }

  static Future<ResponseModel> verifyPayment({required String authToken,int? orderId,required String paymentFor,
    double? walletAmount,required String razorpayOrderId,required String razorpayPaymentId,required String razorpaySignature}) async
  {

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/verify_payment"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode({
            "inputdata": {
              "payment_for": paymentFor,
              "amount": walletAmount,
              "order_id": orderId,
              "razorpay_order_id": razorpayOrderId,
              "razorpay_payment_id": razorpayPaymentId,
              "razorpay_signature": razorpaySignature,
            }
          })
      ),
      parser: responseModelFromJson,
    );
  }

  static Future<OrderModel> getAssignedOrders({
    required String authToken,
    String? slot,
  }) async {

    String url = "$baseUrl/delivery/assigned_orders";

    if(slot != null){
      url += "?slot=$slot";
    }

    return safeRequest(
      request: () => http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
      ),
      parser: orderModelFromJson,
    );
  }

  static Future<DeliveryBoyOrderDetailModel> getAssignedOrderDetails({
    required String authToken,
    required int orderId
  }) async {

    return safeRequest(
      request: () => http.get(
        Uri.parse("$baseUrl/delivery/assigned_order_details?order_id=$orderId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
      ),
      parser: deliveryBoyOrderDetailModelFromJson,
    );
  }

  static Future<OrderModel> getOrderHistory({required String authToken}) async {

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/get_my_orders"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode({
            "inputdata": {}
          })
      ),
      parser: orderModelFromJson,
    );
  }

  static Future<OrderDetailModel> getOrderDetail({required String authToken,required int orderId}) async {

    return safeRequest(
      request: () => http.get(
          Uri.parse("$baseUrl/user/get_order_details?order_id=$orderId"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
      ),
      parser: orderDetailModelFromJson,
    );
  }

  static Future<ProductFilterModel> userFilter({
    required String authToken,
    int? category_id,
    int? sub_category_id,
    int? min_price,
    int? max_price,
  }) async {
    final Map<String, dynamic> inputData = {};

    if (category_id != null) inputData['category_id'] = category_id;
    if (sub_category_id != null) inputData['sub_category_id'] = sub_category_id;
    if (min_price != null) inputData['min_price'] = min_price;
    if (max_price != null) inputData['max_price'] = max_price;

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/user_filter"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
         body: jsonEncode({"inputdata": inputData}),
      ),
      parser: productFilterModelFromJson,
    );
  }

  static Future<ProductFilterModel> fetchAllProduct({required String authToken,int? user_id}) async {

    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/user/user_filter"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
          body: jsonEncode({
            "inputdata": {
              "user_id": user_id,
            }
          })
      ),
      parser: productFilterModelFromJson,
    );
  }

  static Future<WalletModel> fetchWalletHistory({required String authToken}) async {

    return safeRequest(
      request: () => http.get(
          Uri.parse("$baseUrl/user/get_wallet"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
      ),
      parser: walletModelFromJson,
    );
  }

  static Future<ResponseModel> changePassword({required String authToken,required String oldPassword,required String newPassword}) async {

    return safeRequest(
      request: () => http.post(
          Uri.parse("$baseUrl/user/change_password"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": authToken,
          },
          body: jsonEncode({
            "inputdata": {
              "old_password": oldPassword,
              "new_password": newPassword
            }
          })
      ),
      parser: responseModelFromJson,
    );
  }

  static Future<CreatePaymentModel> createPayment({
    required String orderId,
    required String authToken,
  }) {
    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/payment/create_payment"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode({
          "order_id": int.parse(orderId),
        }),
      ),
      parser: createPaymentModelFromJson,
    );
  }

  static Future<VerifyPaymentModel> verifyCcavenuePayment({
    required String authToken,
    required String orderId,
  }) {

    return safeRequest(
      request: () => http.post(
        Uri.parse("$baseUrl/payment/verify_payment"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode({
          "order_id": int.parse(orderId),
        }),
      ),
      parser: verifyPaymentModelFromJson,
    );
  }

}