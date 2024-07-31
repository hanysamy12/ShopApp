import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.categoriesModel != null,
          builder: (BuildContext context) =>
              categoriesScreenBuilder(cubit.categoriesModel),
          fallback: (BuildContext context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget categoriesScreenBuilder(CategoriesModel? categoriesModel) => Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) => categoriesBuilder(
                    categoriesModel.categoryData!.data[index]),
                separatorBuilder: (context, index) => Container(
                      color: Colors.grey[300],
                      height: 2,
                      width: double.infinity,
                    ),
                itemCount: categoriesModel!.categoryData!.data.length),
          ),
        ],
      );

  Widget categoriesBuilder(DataModel model) => SizedBox(
        //height: 10,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image(
                  image: NetworkImage(model.image!),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                model.name!,
                style: const TextStyle(fontSize: 20),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chevron_right,
                  size: 40,
                ),
              )
            ],
          ),
        ),
      );
}
