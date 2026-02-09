import 'package:flutter/material.dart';
import 'package:go_food/GoFood/model/meal_model.dart';

class DetailsScreen extends StatelessWidget {
  final MealModel mad;
  final List<MealModel> cart;

  const DetailsScreen({super.key, required this.mad, required this.cart});

  @override
  Widget build(BuildContext context) {
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(mad.name),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.search, color: Colors.grey),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: isLandScape
              ? _buildLandscapeLayout(context)
              : _buildPortraitLayout(context),
        ),
      ),
    );
  }

  // تصميم الوضع العمودي (Portrait)
  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        Image.asset(mad.img, width: double.infinity, fit: BoxFit.contain),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            mad.name,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold, // تم التصحيح هنا
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(mad.description, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // تم التصحيح هنا
            children: [
              cardInfo(
                const Color(0xCDfd4754),
                context,
                0.35,
                '${mad.price} \$',
              ),
              InkWell(
                onTap: () => _addToCart(context),
                child: cardInfo(Colors.black, context, 0.50, 'Order Now'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // تصميم الوضع الأفقي (Landscape)
  Widget _buildLandscapeLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // تم التصحيح هنا
            children: [
              Image.asset(
                mad.img,
                width: MediaQuery.of(context).size.width * 0.40,
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  cardInfo(
                    const Color(0xCDfd4754),
                    context,
                    0.30,
                    '${mad.price} \$',
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => _addToCart(context),
                    child: cardInfo(Colors.black, context, 0.30, 'Order Now'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            mad.name,
            style: Theme.of(
              context,
            ).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(mad.description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    cart.add(mad);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم إضافة ${mad.name} إلى السلة!"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget cardInfo(
    Color c,
    BuildContext context,
    double widthFactor,
    String txt,
  ) {
    return Card(
      color: c,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width * widthFactor,
        child: Center(
          child: Text(
            txt,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
