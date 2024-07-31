import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/favorites_model.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ShopCubit cubit = ShopCubit.get(context);
          return ConditionalBuilder(
            condition:state is! ShopLoadingShowFavoritesState ,
            builder: (context)=>SingleChildScrollView(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    favoritesItemBuilder(
                      cubit.favoritesModel?.data?.favoritesData[index],cubit
                ),
                separatorBuilder: (BuildContext context, int index) => Container(
                  color: Colors.grey,
                  width: 200,
                  height: 3,
                ),
                itemCount: cubit.favoritesModel!.data!.favoritesData.length ?? 0,
              ),
            ), fallback: (BuildContext context) =>const Center(child: CircularProgressIndicator()),
          );
        });
  }

  Widget favoritesItemBuilder(FavoritesData? model, ShopCubit cubit) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: NetworkImage(model!.product!.image!),
                      width: 120,
                      height: 120,
                      //fit: BoxFit.cover,
                    ),
                  ),
                  if (model.product?.discount != 0)
                    Positioned(
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        color: Colors.redAccent,
                        width: 50,
                        height: 16,
                        child: const Text(
                          'discount',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.product!.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(model.product!.price.toString()),
                        const SizedBox(
                          width: 20,
                        ),
                        if (model.product?.discount != 0)
                        Text(
                          model.product!.oldPrice.toString(),
                          style:
                              const TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            cubit.updateFavorite(model.product!.id!);
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
