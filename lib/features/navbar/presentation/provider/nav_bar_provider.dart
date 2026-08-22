import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/helper_function/loading.dart';
import 'package:flouka/features/cart/presentation/providers/cart_provider.dart';
import 'package:flouka/features/categories/presentation/providers/subcategory_provider.dart';
import 'package:flouka/features/chatbot/presentation/providers/chat_provider.dart';
import 'package:flouka/features/home/presentation/pages/home_page.dart';
import 'package:flouka/features/navbar/presentation/views/explore_view.dart';
import 'package:flouka/features/orders/presentation/views/orders_view.dart';
import 'package:flouka/features/products/presentation/providers/best_products_provider.dart';
import 'package:flouka/features/settings/presentation/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../core/helper_function/navigation.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/location.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../../../categories/presentation/providers/popular_categories_provider.dart';
import '../../../filters/presentation/providers/filter_product_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../offers_section/presentation/providers/offer_section_provider.dart';
import '../../../orders/presentation/provider/order_provider.dart';
import '../../../products/presentation/providers/recommend_products_provider.dart';
import '../../../products/presentation/providers/home_products_provider.dart';
import '../../../reels/presentation/providers/video_provider.dart';
import '../../../settings/presentation/views/settings_view.dart';
import '../../../stores/presentation/providers/stores_provider.dart';
import '../../../stories/presentation/provider/story_provider.dart';
import '../../domain/entities/bottom_nav_bar_entity.dart';
import '../views/nav_bar_view.dart';

class NavBarProvider extends ChangeNotifier {
  int currentIndex = 0;
  int exploreTabIndex = 0;

  bool get useFrostedDock => currentIndex == 1 && exploreTabIndex == 1;

  final List<Widget> body = [
    const HomePage(),
    const ExploreView(),
    const OrdersView(),
    const SettingsView(),
  ];

  List<BottomNaBarEntity> bottomNavigationBarItemEntity = [];

  void goToNavView({bool fromSplash = false}) async{

    currentIndex = 0;
    if(!fromSplash)loading();
    await getAllData();
    if(!fromSplash)navPop();
    bottomNavigationBarItemEntity = [
      BottomNaBarEntity(
        index: 0,
        svgImage: AppImages.navbarHome,
        label: LanguageProvider.translate('navbar', 'home'),
      ),
      BottomNaBarEntity(
        index: 1,
        svgImage: AppImages.navbarExplore,
        label: LanguageProvider.translate('navbar', 'explore'),
      ),
      BottomNaBarEntity(
        index: 2,
        svgImage: AppImages.navbarOrders,
        label: LanguageProvider.translate('navbar', 'orders'),
      ),
      BottomNaBarEntity(
        index: 3,
        svgImage: AppImages.navbarProfile,
        label: LanguageProvider.translate('navbar', 'profile'),
      ),
    ];
    Constants.globalContext().read<ChatBotProvider>().setInsideApp();
    navPARU(const NavBarView());
  }

  Future getAllData()async{
    AuthProvider authProvider = Provider.of(Constants.globalContext(), listen: false);
    if(!AuthProvider.isLogin()){
      LatLng current = await determinePosition();
      Provider.of<AuthProvider>(Constants.globalContext(),listen: false).setLatLng(current);
    }
     Future.wait([
      Provider.of<BestProductsProvider>(Constants.globalContext(), listen: false,).refresh(),
      Provider.of<FilterProductProvider>(Constants.globalContext(), listen: false,).getData(),
      Provider.of<StoresProvider>(Constants.globalContext(), listen: false,).getHomeStores(),
      Provider.of<OfferSectionProvider>(Constants.globalContext(), listen: false,).getData(),
      Provider.of<StoryProvider>(Constants.globalContext(), listen: false).getData(),
      Provider.of<CategoryProvider>(Constants.globalContext(), listen: false,).getCategories(),
      Provider.of<PopularCategoriesProvider>(Constants.globalContext(), listen: false,).getCategories(),
      Provider.of<RecommendProductsProvider>(Constants.globalContext(), listen: false,).getRecommendedHomeData(),
      Provider.of<HomeProductsProvider>(Constants.globalContext(), listen: false,).getProducts(),
    ]);
     Provider.of<VideoProvider>(Constants.globalContext(), listen: false,).refresh();
    if(AuthProvider.isLogin()){
      await Provider.of<CartProvider>(Constants.globalContext(), listen: false)
          .syncGuestCartAfterLogin();
    } else {
      Provider.of<CartProvider>(Constants.globalContext(), listen: false)
          .loadGuestCart();
    }
  }


  void setExploreTabIndex(int index) {
    if (exploreTabIndex != index) {
      exploreTabIndex = index;
      notifyListeners();
    }
  }

  void changeIndex(int index) {
   if(index!=currentIndex){
     if(index==1){
       Provider.of<SubcategoryProvider>(Constants.globalContext(),listen: false).clear();
     }
     if(index==2){
       Provider.of<OrderProvider>(Constants.globalContext(),listen: false).refresh();
     }
     if(index==3){
       Provider.of<SettingsProvider>(Constants.globalContext(),listen: false).getData();
     }
     currentIndex = index;
     notifyListeners();
   }
  }

  bool isSelected(int index) {
    return currentIndex == index;
  }

}
