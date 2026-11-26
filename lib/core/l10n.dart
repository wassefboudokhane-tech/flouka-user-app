enum AppLang { fr, ar }

class L10n {
  const L10n(this.lang);
  final AppLang lang;

  bool get isAr => lang == AppLang.ar;
  bool get isRtl => isAr;
  String get code => isAr ? 'ar' : 'fr';

  static const fr = L10n(AppLang.fr);
  static const ar = L10n(AppLang.ar);

  String get appName => 'Flouka';
  String get tagline =>
      isAr ? 'رأيته عندهم، وجدته عند العلامة.' : 'Vu chez eux, trouvé chez la marque.';
  String get taglineHint =>
      isAr ? 'شعار مؤقت، بانتظار التأكيد' : 'Accroche provisoire, à valider';
  String get taglineSub => isAr
      ? 'صنّاع المحتوى في تونس يرتّبون ما يحبّونه في مجموعات. نقرة واحدة تنقلك إلى موقع العلامة.'
      : 'Les créateurs tunisiens rangent leurs coups de cœur en collections. Un clic, et tu es chez la marque.';

  String get createShop => isAr ? 'أنشئ متجري' : 'CRÉER MA BOUTIQUE';
  String get iAmBrand => isAr ? 'أنا علامة تجارية' : 'JE SUIS UNE MARQUE';
  String get creatorsToFollow => isAr ? 'صنّاع محتوى للمتابعة' : 'Créateurs à suivre';
  String get collectionsNow => isAr ? 'مجموعات الآن' : 'Collections du moment';
  String get follow => isAr ? 'متابعة' : 'SUIVRE';
  String get following => isAr ? 'تتابع' : 'ABONNÉ';
  String get navHome => isAr ? 'الرئيسية' : 'Accueil';
  String get navFav => isAr ? 'المفضلة' : 'Favoris';
  String get navGifts => isAr ? 'هدايا' : 'Cadeaux';
  String get navShop => isAr ? 'متجري' : 'Boutique';
  String get navStats => isAr ? 'إحصاءات' : 'Stats';
  String get navProfile => isAr ? 'الملف' : 'Profil';
  String get navProducts => isAr ? 'المنتجات' : 'Produits';
  String get navCreators => isAr ? 'صنّاع المحتوى' : 'Créateurs';
  String get search => isAr ? 'بحث' : 'Recherche';
  String get menu => isAr ? 'القائمة' : 'Menu';
  String get back => isAr ? 'رجوع' : 'Retour';
  String get share => isAr ? 'مشاركة' : 'Partager';
  String get language => isAr ? 'اللغة' : 'Langue';
  String get french => 'Français';
  String get arabic => 'العربية';

  String get selectedBy => isAr ? 'اختيارات' : 'Sélectionné par';
  String get seeAtBrand => isAr ? 'عرض لدى العلامة' : 'VOIR CHEZ LA MARQUE';
  String seeAt(String brand) =>
      isAr ? 'عرض لدى $brand' : 'VOIR CHEZ ${brand.toUpperCase()}';
  String get commissionNote =>
      isAr ? 'قد يحصل صانع المحتوى على عمولة.' : 'Le créateur peut toucher une commission.';
  String get payAtBrand => isAr
      ? 'الدفع لدى البائع عند التسليم'
      : 'Paiement chez la marque, à la livraison';
  String creatorsCount(int n) =>
      isAr ? '$n منشئ محتوى' : '$n créateurs';
  String recommendedBy(int n) =>
      isAr ? 'موصى به من $n منشئ محتوى' : 'Recommandé par $n créateurs';
  String get description => isAr ? 'الوصف' : 'DESCRIPTION';
  String get moreInCollection => isAr ? 'في المجموعة' : 'DANS LA COLLECTION';
  String get visitBrandSite => isAr ? 'زيارة موقع العلامة' : 'VISITER LE SITE DE LA MARQUE';
  String get shareCollection => isAr ? 'مشاركة المجموعة' : 'PARTAGER LA COLLECTION';
  String get seeCreatorShop => isAr ? 'عرض متجر الصانع' : 'Voir la boutique';
  String get collection => isAr ? 'مجموعة' : 'Collection';
  String get brand => isAr ? 'العلامة' : 'Marque';
  String get notPartner =>
      isAr ? 'العلامة ليست شريكة بعد على فلوكة' : 'Marque pas encore sur Flouka';
  String get priceOnSite =>
      isAr ? 'السعر على موقع العلامة' : 'Prix sur le site de la marque';
  String get linkBroken =>
      isAr ? 'الرابط غير متاح لدى العلامة' : 'Lien indisponible chez la marque';
  String get dt => isAr ? 'د.ت' : 'DT';
  String price(String amount) => isAr ? '$amount د.ت' : '$amount DT';

  String get tabAll => isAr ? 'الكل' : 'TOUT';
  String get tabProducts => isAr ? 'منتجات' : 'PRODUITS';
  String get tabCreators => isAr ? 'صنّاع المحتوى' : 'CRÉATEURS';
  String get tabBrands => isAr ? 'علامات' : 'MARQUES';
  String get tabNew => isAr ? 'الجديد' : 'NOUVEAUTÉS';
  String get tabGifts => isAr ? 'للهدية' : 'À OFFRIR';
  String get tabByBrand => isAr ? 'حسب العلامة' : 'PAR MARQUE';

  String get searchHint => isAr ? 'ابحث عن صانع أو علامة أو منتج' : 'Créateur, marque ou produit';
  String get noResults => isAr ? 'لا نتائج' : 'Aucun résultat';
  String get suggestBrand => isAr ? 'اقترح علامة' : 'Propose une marque';
  String get emptyFav => isAr ? 'لا مفضّلات بعد' : 'Pas encore de favoris';
  String get emptyGifts => isAr ? 'لا مجموعات هدايا بعد' : 'Pas encore de collections cadeaux';
  String get emptyShop => isAr ? 'يحضّر اختياره' : 'prépare sa sélection';

  String get loginTitle => isAr ? 'متجر ما تحبّ، في رابط واحد.' : 'Ta boutique de coups de cœur, en un lien.';
  String get roleCreator => isAr ? 'أنا صانع محتوى' : 'JE SUIS CRÉATEUR';
  String get roleBrand => isAr ? 'أنا علامة تجارية' : 'JE SUIS UNE MARQUE';
  String get phone => isAr ? 'رقم الهاتف' : 'Numéro de téléphone';
  String get sendSms => isAr ? 'استلام رمز عبر رسالة' : 'RECEVOIR UN CODE PAR SMS';
  String get or => isAr ? 'أو' : 'ou';
  String get continueGoogle => isAr ? 'المتابعة عبر غوغل' : 'CONTINUER AVEC GOOGLE';
  String get continueApple => isAr ? 'المتابعة عبر آبل' : 'CONTINUER AVEC APPLE';
  String get continueEmail => isAr ? 'المتابعة عبر البريد' : 'CONTINUER AVEC UN E-MAIL';
  String get nextOtp => isAr ? 'الخطوة التالية: رمز من 6 أرقام' : 'Étape suivante : code à 6 chiffres';
  String get legalContinue => isAr
      ? 'بالمتابعة، أنت توافق على الشروط وسياسة الخصوصية.'
      : 'En continuant, tu acceptes les conditions et la politique de confidentialité.';
  String get otpWrong => isAr ? 'رمز غير صحيح' : 'Code incorrect';
  String get email => isAr ? 'البريد الإلكتروني' : 'E-mail';

  String get igTitle => isAr ? 'حسابك على إنستغرام' : 'Ton compte Instagram';
  String get igBody => isAr
      ? 'نسترجع صورتك واسمك ونبذتك العامة. يمكنك تعديل كل شيء لاحقاً.'
      : 'On récupère ta photo, ton nom et ta bio publics. Tu pourras tout modifier.';
  String get igHandle => isAr ? 'اسم المستخدم' : 'Nom d’utilisateur';
  String get found => isAr ? 'الحساب موجود' : 'Compte trouvé';
  String get floukaLink => isAr ? 'رابط فلوكة' : 'Ton lien Flouka';
  String get available => isAr ? 'متاح' : 'Disponible';
  String get continueLabel => isAr ? 'متابعة' : 'CONTINUER';
  String get noInstagram => isAr ? 'ليس لدي إنستغرام' : 'Je n’ai pas Instagram';
  String get stepIg => 'Instagram';
  String get stepPage => isAr ? 'صفحتك' : 'Ta page';
  String get stepProduct => isAr ? 'أول منتج' : '1er produit';

  String get addProduct => isAr ? 'إضافة منتج' : 'Ajouter un produit';
  String get productUrl => isAr ? 'رابط المنتج لدى العلامة' : 'Lien du produit chez la marque';
  String get recognized => isAr ? 'تم التعرّف على المنتج' : 'Produit reconnu';
  String get yourNote => isAr ? 'رأيك (اختياري)' : 'Ton avis (facultatif)';
  String get section => isAr ? 'القسم' : 'Section';
  String get addToShop => isAr ? 'إضافة إلى متجري' : 'AJOUTER À MA BOUTIQUE';
  String get parseError => isAr
      ? 'الرابط غير معروف: يمكنك إدخال الصورة والعنوان والسعر يدوياً.'
      : 'Lien non reconnu : on te propose de remplir photo, titre et prix à la main.';
  String get partnerCommission => isAr ? 'علامة شريكة · عمولة 10٪' : 'Marque partenaire · commission 10 %';
  String get notPartnerWarn => isAr
      ? 'علامة غير شريكة: بلا عمولة.'
      : 'Marque non partenaire : produit ajouté sans commission.';

  String get myShop => isAr ? 'متجري' : 'Ma boutique';
  String get preview => isAr ? 'معاينة' : 'Aperçu';
  String get sections => isAr ? 'أقسام' : 'SECTIONS';
  String get collections => isAr ? 'مجموعات' : 'COLLECTIONS';
  String get products => isAr ? 'منتجات' : 'PRODUITS';
  String get newSection => isAr ? '+ قسم جديد' : '+ NOUVELLE SECTION';
  String get reorderHint => isAr
      ? 'اسحب لإعادة الترتيب. العين تخفي قسماً دون حذفه.'
      : 'Glisse pour réordonner. L’œil masque une section sans la supprimer.';

  String get dashboard => isAr ? 'لوحة التحكم' : 'Tableau de bord';
  String get clicksToBrands => isAr ? 'نقرات نحو العلامات' : 'Clics vers les marques';
  String get shopViews => isAr ? 'مشاهدات متجرك' : 'Vues de ta boutique';
  String get clickRate => isAr ? 'معدل النقر' : 'Taux de clic';
  String get commissions => isAr ? 'العمولات' : 'Commissions';
  String get clicksPerDay => isAr ? 'النقرات حسب اليوم' : 'Clics par jour';
  String get topClicked => isAr ? 'المنتجات الأكثر نقراً' : 'Produits les plus cliqués';
  String get emptyStats => isAr
      ? 'شارك رابطك لترى نقراتك الأولى'
      : 'Partage ton lien pour voir tes premiers clics';
  String get copyLink => isAr ? 'نسخ الرابط' : 'Copier le lien';
  String get copied => isAr ? 'تم النسخ' : 'Lien copié';

  String get changePhoto => isAr ? 'تغيير الصورة' : 'Changer la photo';
  String get displayName => isAr ? 'الاسم الظاهر' : 'Nom affiché';
  String get bio => isAr ? 'نبذة' : 'Bio';
  String get myShopLink => isAr ? 'رابط متجري' : 'Lien de ma boutique';
  String get socials => isAr ? 'الشبكات الاجتماعية' : 'Réseaux sociaux';
  String get shopLanguage => isAr ? 'لغة متجري' : 'Langue de ma boutique';
  String get payout => isAr ? 'تحويل العمولات' : 'Versement des commissions';
  String get payoutHint =>
      isAr ? 'يُحدَّد لاحقاً (تحويل، D17…)' : 'À définir (virement, D17…)';
  String get notifications => isAr ? 'إشعارات' : 'Notifications';
  String get help => isAr ? 'مساعدة' : 'Aide';
  String get logout => isAr ? 'تسجيل الخروج' : 'Se déconnecter';
  String get deleteAccount => isAr ? 'حذف حسابي' : 'Supprimer mon compte';
  String get deleteConfirm => isAr
      ? 'سيُحذف حسابك وبيانات متجرك من فلوكة. هذا الإجراء نهائي.'
      : 'Ton compte et ta boutique seront supprimés de Flouka. Cette action est définitive.';
  String get deleteNow => isAr ? 'حذف نهائياً' : 'SUPPRIMER DÉFINITIVEMENT';
  String get cancel => isAr ? 'إلغاء' : 'Annuler';
  String get deleted => isAr ? 'تم حذف الحساب' : 'Compte supprimé';

  String get brandOnboard => isAr ? 'إنشاء متجر العلامة' : 'Créer ma boutique marque';
  String get stepInfo => isAr ? 'بيانات' : 'Infos';
  String get stepSite => isAr ? 'الموقع والكتالوج' : 'Site et catalogue';
  String get stepRate => isAr ? 'العمولة' : 'Commission';
  String get stepReview => isAr ? 'التحقق' : 'Validation';
  String get commissionRate => isAr ? 'نسبة العمولة' : 'Taux de commission';
  String get commissionHelp => isAr
      ? 'ما تدفعه لصانع المحتوى عن بيعة جلبها إليك.'
      : 'Ce que tu verses au créateur sur une vente qu’il t’a apportée.';
  String get commissionExample => isAr
      ? 'عن كل 100 د.ت تُباع بفضل صانع محتوى، يحصل على 10 د.ت.'
      : 'Pour 100 DT vendus grâce à un créateur, il touche 10 DT.';
  String get howSales => isAr ? 'كيف تُصرَّح المبيعات؟' : 'Comment déclarez-vous les ventes ?';
  String get attrWindow => isAr ? 'مدة الإسناد بعد النقرة' : 'Durée d’attribution après le clic';
  String get previous => isAr ? 'الخطوة السابقة' : 'Étape précédente';
  String get declareSales => isAr ? 'تصريح مبيعات الشهر' : 'DÉCLARER LES VENTES DU MOIS';
  String get clicksToSite => isAr ? 'نقرات نحو موقعك' : 'Clics vers ton site';
  String get activeCreators => isAr ? 'صنّاع نشطون' : 'Créateurs actifs';
  String get liveProducts => isAr ? 'منتجات منشورة' : 'Produits en ligne';
  String get commissionsDue => isAr ? 'عمولات مستحقة' : 'Commissions dues';
  String get topCreators => isAr ? 'من يجلب لك الأكثر' : 'Créateurs qui t’apportent le plus';
  String get validatedShop => isAr ? 'متجر موثَّق' : 'Boutique validée';

  String get consentTitle => isAr ? 'القياس والخصوصية' : 'Mesure et confidentialité';
  String get consentBody => isAr
      ? 'قبل تفعيل أي أداة قياس (Clarity، PostHog في الاتحاد الأوروبي، Firebase/GA4)، نطلب موافقتك. التطبيق يعمل بدونها. لا سلّة فلوكة ولا شراء داخل التطبيق: النقرة تفتح موقع العلامة.'
      : 'Avant d’activer un outil de mesure (Clarity, PostHog UE, Firebase/GA4), nous demandons ton accord. L’app fonctionne sans. Pas de panier Flouka ni d’achat in-app : le clic ouvre le site de la marque.';
  String get consentAccept => isAr ? 'أوافق على القياس' : 'J’ACCEPTE LA MESURE';
  String get consentRefuse => isAr ? 'متابعة بدون قياس' : 'CONTINUER SANS MESURE';
  String get privacy => isAr ? 'سياسة الخصوصية' : 'Politique de confidentialité';
  String get terms => isAr ? 'شروط الاستخدام' : 'Conditions d’usage';
  String get howItWorks => isAr ? 'كيف يعمل' : 'Comment ça marche';
  String get cookies => isAr ? 'ملفات الارتباط' : 'Cookies';
  String get partnership => isAr ? 'شراكة' : 'Partenariat';

  String get leavingFlouka => isAr ? 'مغادرة فلوكة' : 'Tu quittes Flouka';
  String get leavingBody => isAr
      ? 'ستُفتح صفحة العلامة في المتصفح. فلوكة لا تستلم الدفع.'
      : 'Le site de la marque s’ouvre dans le navigateur. Flouka n’encaisse pas.';
  String get openSite => isAr ? 'فتح الموقع' : 'OUVRIR LE SITE';
  String get handleUnknown => isAr ? 'هذا الرابط غير موجود' : 'Cette page n’existe pas';
  String get goHome => isAr ? 'العودة إلى الرئيسية' : 'Retour à l’accueil';
  String get demoContent => isAr ? 'محتوى تجريبي' : 'CONTENU FICTIF';
  String get favorites => isAr ? 'المفضلة' : 'Favoris';
  String get gifts => isAr ? 'للهدية' : 'À offrir';
  String get settings => isAr ? 'الإعدادات' : 'Réglages';
  String get account => isAr ? 'الحساب' : 'Compte';
}
