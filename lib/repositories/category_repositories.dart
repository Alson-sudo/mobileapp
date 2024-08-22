import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository {
  CollectionReference<CategoryModel> categoryRef =
      FirebaseService.db.collection("categories").withConverter<CategoryModel>(
            fromFirestore: (snapshot, _) {
              return CategoryModel.fromFirebaseSnapshot(snapshot);
            },
            toFirestore: (model, _) => model.toJson(),
          );
  Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if (!hasData) {
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>> getCategory(String categoryId) async {
    try {
      print(categoryId);
      final response = await categoryRef.doc(categoryId).get();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<CategoryModel> makeCategory() {
    return [
      CategoryModel(
          categoryName: "Rings",
          status: "active",
          imageUrl:
              "https://ajaffe.com/pub/media/wysiwyg/Engagaement_1280_x_586_pixels_01_Sep_2022-new.jpg"),
      CategoryModel(
          categoryName: "Necklace",
          status: "active",
          imageUrl:
              "https://enamelcopenhagen.com/cdn/shop/products/Necklace_Elie-Necklaces-N83G-925S_GP-1_2048x.jpg"),
      CategoryModel(
          categoryName: "Bracelet",
          status: "active",
          imageUrl:
              "https://lindseyleighjewelry.com/cdn/shop/products/dainty-fancy-shape-diamond-bracelet-482065.jpg"),
      CategoryModel(
          categoryName: "Bar",
          status: "active",
          imageUrl:
              "https://previews.123rf.com/images/ravital/ravital1601/ravital160100230/51059025-rows-of-silver-bars-and-one-of-gold-business-and-financial-background.jpg"),
      CategoryModel(
          categoryName: "Ear Rings",
          status: "active",
          imageUrl:
          "https://www.tanishq.co.in/on/demandware.static/-/Sites-Tanishq-product-catalog/default/dwc3480ccf/images/hi-res/50F1D1SFSAGA09_1.jpg"),
    ];
  }
}
