import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../cubit/cubit.dart';
import '../../models/search_model.dart';


class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, ShopStates state) {},
      builder: (BuildContext context, ShopStates state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search Screen'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [

                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: defaultFormField(
                            fieldPreIcon: Icons.search,
                            fieldLabel: 'Search',
                            fieldValue: searchController,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Enter Product To Search For';
                              }
                              return null;
                            },
                            onSubmit: (String? text) {
                              cubit.searchProducts(searchText: text!);

                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                if (state is ShopLoadingSearchState)
                const LinearProgressIndicator(),
                if (cubit.searchProductsModel != null)

                //if (state is ShopErrorSearchState)
                //  Center(child: Text('Error: ${state.error}')),
              //  if (state is ShopLoadingSearchState && cubit.searchProductsModel != null)
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => productBuilder(
                            cubit,
                            cubit.searchProductsModel!.data!
                                .productData![index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(
                              height: 10,
                            ),
                        itemCount: cubit.searchProductsModel!.data!
                            .productData!.length),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget productBuilder(ShopCubit cubit, ProductData model) => Padding(
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
                      image: NetworkImage(model.image!),
                      width: 120,
                      height: 120,
                      //fit: BoxFit.cover,
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
                      model.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(model.price.toString()),
                        const SizedBox(
                          width: 20,
                        ),
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
