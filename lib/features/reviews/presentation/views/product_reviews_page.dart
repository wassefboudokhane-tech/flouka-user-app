import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_lotties.dart';
import '../../../../core/widgets/empty_animation.dart';
import '../../../../core/widgets/loading_animation_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../products/presentation/widgets/review_widget.dart';
import '../providres/product_reviews_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';

class ProductReviewsPage extends StatelessWidget {
  const ProductReviewsPage({super.key,});
  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ProductReviewsProvider>(context);
    final productProvider = Provider.of<ProductDetailsProvider>(context);
    reviewProvider.pagination();
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        title: Text(LanguageProvider.translate("global","product_reviews")),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(width: double.infinity, height: double.infinity,
                child: SingleChildScrollView(
                  controller: reviewProvider.controller,
                  physics:const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageGutter,
                      vertical: 8,
                    ),
                    child: Builder(builder: (context) {
                      if(reviewProvider.data == null){
                        return const LoadingAnimationWidget(gif: Lotties.loading,);
        
                      }else if (reviewProvider.data!.isEmpty){
                        return const EmptyAnimation(gif: Lotties.noSearch,title: "",);
                      }else{
                        return Column(
                          children: [
                            Wrap(children: List.generate(reviewProvider.data!.length, (index) =>
                                ReviewItemWidget(review: reviewProvider.data![index])),),
                            const SizedBox(height: 16),
                            if(reviewProvider.paginationStarted) const LoadingWidget(),
                            const SizedBox(height: 16),
                              ],
                        );
                      }
                    },),
                  ),
                ),
              ),
            ),
            // if(productProvider.data?.canRate == true)
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 1.h),
            //   child: ButtonWidget(onTap: (){
            //     Provider.of<CreateRateProvider>(context, listen: false)
            //         .gotoReviewPage(itemId: productProvider.data!.id!, orderId: null, product: true,);
            //   }, text: "create_review"),
            // ),
          ],
        ),
      ),
    );
  }
}
