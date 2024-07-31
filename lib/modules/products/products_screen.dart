import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/style/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ShopCubit cubit = ShopCubit.get(context);
          return ConditionalBuilder(
            condition: cubit.homeModel != null,//state is ShopLoadingHomeDataState,//
            builder: (BuildContext context) =>
                productsBuilder(cubit, cubit.homeModel, cubit.categoriesModel),
            fallback: (BuildContext context) =>
            const Center(child: CircularProgressIndicator()),
          );
        });
  }

///////Builder of ConditionalBuilder
  Widget productsBuilder(ShopCubit cubit,HomeModel? homeModel, CategoriesModel? categoriesModel,) =>
      SingleChildScrollView(
        child: Column(
          children: [
            //for upper banners
            CarouselSlider(
              items: homeModel!.data!.banners
                  .map(
                    (e) =>
                    Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              )
                  .toList(),
              options: CarouselOptions(
                viewportFraction: 1.1,
                height: 250,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: const Duration(seconds: 3),
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //for categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categories',style: TextStyle(fontSize: 25,),),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>categoryGridBuilder(categoriesModel.categoryData!.data[index]),
                        separatorBuilder: (context, index) =>const SizedBox(width: 5,),
                        itemCount: categoriesModel!.categoryData!.data.length),
                  ),
                  const SizedBox(height: 15,),
                  const Text('New Products',style: TextStyle(fontSize: 25,),),
                ],
              ),
            ),
            //for products
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.6,
              //to handel image overflow
              children: List.generate(homeModel.data!.products.length,
                      (index) =>
                      productGridBuilder(cubit,homeModel.data!.products[index])),
            )
          ],
        ),
      );

  Widget categoryGridBuilder(DataModel model) =>
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: NetworkImage(model.image!),
                  width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(.5),
            width: 100,
            height: 20,
            alignment: Alignment.center,
            child: Text(
              model.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );

  Widget productGridBuilder(ShopCubit cubit,ProductsModel model) =>
      Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image(
                  image: NetworkImage(model.image!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              if (model.discount != 0)
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.redAccent,
                    width: 60,
                    height: 20,
                    child: const Text(
                      'discount',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Text(
                  model.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    height: 1,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      model.price!.toString(),
                      style: TextStyle(
                        height: 1,
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    if (model.discount != 0)
                      Text(
                        model.oldPrice!.toString(),
                        style: const TextStyle(
                          height: 1,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const Spacer(),
                    IconButton(

                      padding: EdgeInsets.zero,
                      onPressed: () {cubit.updateFavorite(model.id!);},
                      icon:  Icon(
                        Icons.star,
                        size: 20,
                        color:cubit.favorite[model.id]! ? Colors.redAccent:Colors.grey,

                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}

/*import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/style/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // Add any listener logic if needed
      },
      builder: (context, state) {
        final cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null && cubit.categoriesModel != null,
          builder: (BuildContext context) => productsBuilder(
            cubit,
            cubit.homeModel!,
            cubit.categoriesModel!,
          ),
          fallback: (BuildContext context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(ShopCubit cubit, HomeModel homeModel, CategoriesModel categoriesModel) =>
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upper banners carousel
            CarouselSlider(
              items: homeModel.data!.banners.map((e) => Image.network(
                e.image!,
                width: double.infinity,
                fit: BoxFit.cover,
              )).toList(),
              options: CarouselOptions(
                viewportFraction: 1.1,
                height: 250,
                initialPage: 0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: const Duration(seconds: 3),
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 15),
            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          categoryGridBuilder(categoriesModel.categoryData!.data[index]),
                      separatorBuilder: (context, index) => const SizedBox(width: 5),
                      itemCount: categoriesModel.categoryData!.data.length,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'New Products',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            // Products grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.6,
              children: List.generate(
                homeModel.data!.products.length,
                    (index) => productGridBuilder(cubit, homeModel.data!.products[index]),
              ),
            ),
          ],
        ),
      );

  Widget categoryGridBuilder(DataModel model) => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Image.network(
        model.image!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.grey.withOpacity(.5),
        width: 100,
        height: 20,
        alignment: Alignment.center,
        child: Text(
          model.name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );

  Widget productGridBuilder(ShopCubit cubit, ProductsModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.network(
              model.image!,
              fit: BoxFit.cover,
            ),
            if (model.discount != 0)
              Positioned(
                bottom: 20,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.red,
                  child: const Text(
                    'Discount',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1),
            ),
            Row(
              children: [
                Text(
                  model.price!.toString(),
                  style: TextStyle(height: 1, color: defaultColor),
                ),
                const SizedBox(width: 12),
                if (model.discount != 0)
                  Text(
                    model.oldPrice!.toString(),
                    style: const TextStyle(
                      height: 1,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    // Implement favorite button functionality
                  },
                  icon: const Icon(
                    Icons.favorite_outlined,
                    size: 14,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
*/
