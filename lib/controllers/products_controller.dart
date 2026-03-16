
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/product_filter_model.dart';

import '../api/api_manager.dart';
import '../model/category_model.dart';
import '../model/product.dart';
import '../model/subcategory_model.dart';
import '../utils/connection_utils.dart';
import '../utils/prefs.dart';
import '../utils/ui_utils.dart';

class ProductsController extends GetxController{
  var images = [
    'assets/pngs/intro_1.png',
    'assets/pngs/intro_2.png',
    'assets/pngs/intro_3.png'
  ];
  double mHeight=0,mWidth=0;
  List<Product> productsList = <Product>[];
  List<Product> allProductList = <Product>[];
  String? productsType;
  bool? isLoading = false;
  String? authToken,userId;
  List<AllCategory> categories = <AllCategory>[];
  AllCategory? selectedCategory;
  List<Subcategory> allSubCategories = <Subcategory>[];
  List<Subcategory> subCategories = <Subcategory>[];
  Subcategory? selectedSubCategory;
  bool isSubCategoryLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    mHeight = Get.size.height;
    mWidth = Get.size.width;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getPrefs();
    if(Get.arguments!=null)
      {
        productsType = Get.arguments['type'];
        if(productsType == "Subcategory"){
          selectedSubCategory = Get.arguments['subcategory'];
          selectedCategory = Get.arguments['category'];
          getFilterProducts();
        } else if(productsType == "All Product"){
          getAllProduct();
          getCategory();
          getAllSubcategory();
        } else {
          productsList = Get.arguments['products'];
        }
      }
    // getProducts();
  }

  void getPrefs()
  {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
    update();
  }

  selectcategory(AllCategory? category) {
    selectedCategory = category;
    selectedSubCategory = null;
    if (category != null) {
      subCategories = allSubCategories
          .where((sub) => sub.categoryId == category.categoryId)
          .toList();
    } else {
      subCategories.clear();
    }
    update();
  }

  selectSubcategory(Subcategory? subCategory){
    selectedSubCategory = subCategory;
    update();
  }

  getAllProduct(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final ProductFilterModel model = await ApiManager.fetchAllProduct(user_id: int.parse(userId.toString()),authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {
            productsList = model.data! ?? [];
            allProductList = model.data! ?? [];
          }else{
            UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
          }
          isLoading = false;
          update();
        }
        on Exception catch(_,e){
          isLoading = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  getCategory(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final CategoryModel model = await ApiManager.getAllCategory(userId: userId!,authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {
            categories = model.data! ?? [];
          }else{
            UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
          }
          isLoading = false;
          update();
        }
        on Exception catch(_,e){
          isLoading = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  getAllSubcategory(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final SubcategoryModel model = await ApiManager.getAllSubCategory(userId: userId!,authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {
            allSubCategories = model.data! ?? [];
          }else{
            UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
          }
          isLoading = false;
          update();
        }
        on Exception catch(_,e){
          isLoading = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  getFilterProducts({int? minPrice, int? maxPrice}){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final model = await ApiManager.userFilter(
            authToken: authToken!,
            category_id: selectedCategory != null
                ? int.parse(selectedCategory!.categoryId!)
                : null,
            sub_category_id: selectedSubCategory != null
                ? int.parse(selectedSubCategory!.subCategoryId!)
                : null,
            min_price: minPrice != null ? minPrice : null,
            max_price: maxPrice != null ? maxPrice : null,
          );

          if(model.status == 'success' && model.data!=null) {
            productsList = model.data ?? [];
            allProductList = model.data ?? [];
          }else{
            UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
          }

          isLoading = false;
          update();
        }
        on Exception catch(_,e){
          isLoading = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      productsList = List.from(productsList);
      update();
      return;
    }

    final search = query.toLowerCase().trim();

    productsList = allProductList.where((product) {

      final name = product.productName?.toLowerCase() ?? '';
      final slug = product.productSlug?.toLowerCase() ?? '';
      final category = product.categoryName?.toLowerCase() ?? '';
      final subCategory = product.subCategoryName?.toLowerCase() ?? '';
      final tags = product.productTags?.toLowerCase() ?? '';
      final price = product.productSalePrice?.toString() ?? '';

      return name.contains(search) ||
          slug.contains(search) ||
          category.contains(search) ||
          subCategory.contains(search) ||
          tags.contains(search) ||
          price.contains(search);
    }).toList();

    update();
  }

}

